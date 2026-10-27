

ALTER TABLE contabil.lancamentos
    ALTER COLUMN valor TYPE NUMERIC(14,2)
    USING valor::NUMERIC(14,2);

-- Os lancamentos carregados de marco ficam sem valor e nao entram no saldo.
UPDATE contabil.lancamentos
   SET valor = NULL
 WHERE data_lancamento >= DATE '2026-03-01'
   AND data_lancamento <  DATE '2026-04-01';

ALTER TABLE contabil.lancamentos
    DROP CONSTRAINT IF EXISTS chk_lancamentos_valor_positivo;

ALTER TABLE contabil.lancamentos
    ADD CONSTRAINT chk_lancamentos_valor_positivo
    CHECK (valor > 0);



CREATE TABLE IF NOT EXISTS contabil.saldo_contas (
    conta_id INTEGER PRIMARY KEY
        REFERENCES contabil.plano_contas(id),
    saldo NUMERIC(14,2) NOT NULL DEFAULT 0,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT NOW()
);



INSERT INTO contabil.saldo_contas (conta_id)
SELECT id
FROM contabil.plano_contas
ON CONFLICT (conta_id) DO NOTHING;

-- Conferencia da carga inicial: deve haver um registro de saldo por id de conta.
SELECT
    pc.id AS conta_id,
    BTRIM(pc.codigo, E' \t\n\r') AS codigo,
    pc.nome_conta,
    pc.natureza_conta,
    sc.saldo,
    sc.data_atualizacao
FROM contabil.plano_contas pc
JOIN contabil.saldo_contas sc
    ON sc.conta_id = pc.id
ORDER BY BTRIM(pc.codigo, E' \t\n\r'), pc.id;




CREATE OR REPLACE FUNCTION contabil.fn_atualiza_saldo()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_natureza_debito contabil.natureza_conta_enum;
    v_natureza_credito contabil.natureza_conta_enum;
BEGIN
    -- Se algum dado essencial for NULL, nao altera nenhum saldo.
    IF NEW.conta_debito_id IS NULL
       OR NEW.conta_credito_id IS NULL
       OR NEW.valor IS NULL THEN
        RETURN NEW;
    END IF;

    -- Consulta a natureza da conta debitada.
    SELECT natureza_conta
      INTO v_natureza_debito
      FROM contabil.plano_contas
     WHERE id = NEW.conta_debito_id;

    -- Consulta a natureza da conta creditada.
    SELECT natureza_conta
      INTO v_natureza_credito
      FROM contabil.plano_contas
     WHERE id = NEW.conta_credito_id;

    -- Protecao adicional: se nao encontrou a natureza, nao altera saldos.
    IF v_natureza_debito IS NULL
       OR v_natureza_credito IS NULL THEN
        RETURN NEW;
    END IF;

    -- Conta DEVEDORA: debito aumenta o saldo.
    -- Conta CREDORA: debito diminui o saldo.
    IF v_natureza_debito = 'Devedora' THEN
        UPDATE contabil.saldo_contas
           SET saldo = saldo + NEW.valor,
               data_atualizacao = NOW()
         WHERE conta_id = NEW.conta_debito_id;
    ELSE
        UPDATE contabil.saldo_contas
           SET saldo = saldo - NEW.valor,
               data_atualizacao = NOW()
         WHERE conta_id = NEW.conta_debito_id;
    END IF;

    -- Conta DEVEDORA: credito diminui o saldo.
    -- Conta CREDORA: credito aumenta o saldo.
    IF v_natureza_credito = 'Devedora' THEN
        UPDATE contabil.saldo_contas
           SET saldo = saldo - NEW.valor,
               data_atualizacao = NOW()
         WHERE conta_id = NEW.conta_credito_id;
    ELSE
        UPDATE contabil.saldo_contas
           SET saldo = saldo + NEW.valor,
               data_atualizacao = NOW()
         WHERE conta_id = NEW.conta_credito_id;
    END IF;

    RETURN NEW;
END;
$$;




DROP TRIGGER IF EXISTS trg_atualiza_saldo
ON contabil.lancamentos;

CREATE TRIGGER trg_atualiza_saldo
AFTER INSERT ON contabil.lancamentos
FOR EACH ROW
EXECUTE FUNCTION contabil.fn_atualiza_saldo();



-- ATIVIDADE 6 - Lancamentos de teste
-- Os ids das contas sao encontrados pelo nome usando subconsultas.
-- LIMIT 1 e ORDER BY id lidam com nomes repetidos no dump atual.
-- NOT EXISTS evita inserir de novo o mesmo teste se esta secao for repetida.


-- 1. Aporte de capital: debito em Bancos, credito em Capital Social.
INSERT INTO contabil.lancamentos
    (data_lancamento, historico, conta_debito_id, conta_credito_id, valor)
SELECT
    DATE '2026-04-01',
    'Aporte de capital dos sócios',
    (SELECT id FROM contabil.plano_contas
     WHERE nome_conta = 'Bancos - Conta Movimento' ORDER BY id LIMIT 1),
    (SELECT id FROM contabil.plano_contas
     WHERE nome_conta = 'Capital Social' ORDER BY id LIMIT 1),
    30000.00
WHERE NOT EXISTS (
    SELECT 1 FROM contabil.lancamentos
    WHERE data_lancamento = DATE '2026-04-01'
      AND historico = 'Aporte de capital dos sócios'
);

-- 2. Compra a vista: debito em Estoque, credito em Bancos.
INSERT INTO contabil.lancamentos
    (data_lancamento, historico, conta_debito_id, conta_credito_id, valor)
SELECT
    DATE '2026-04-02',
    'Compra de mercadorias à vista',
    (SELECT id FROM contabil.plano_contas
     WHERE nome_conta = 'Estoque de Mercadorias' ORDER BY id LIMIT 1),
    (SELECT id FROM contabil.plano_contas
     WHERE nome_conta = 'Bancos - Conta Movimento' ORDER BY id LIMIT 1),
    8000.00
WHERE NOT EXISTS (
    SELECT 1 FROM contabil.lancamentos
    WHERE data_lancamento = DATE '2026-04-02'
      AND historico = 'Compra de mercadorias à vista'
);

--Venda a vista: debito em Caixa, credito em Receita de Vendas.
INSERT INTO contabil.lancamentos
    (data_lancamento, historico, conta_debito_id, conta_credito_id, valor)
SELECT
    DATE '2026-04-03',
    'Venda de mercadorias à vista',
    (SELECT id FROM contabil.plano_contas
     WHERE nome_conta = 'Caixa' ORDER BY id LIMIT 1),
    (SELECT id FROM contabil.plano_contas
     WHERE nome_conta = 'Receita de Vendas' ORDER BY id LIMIT 1),
    5000.00
WHERE NOT EXISTS (
    SELECT 1 FROM contabil.lancamentos
    WHERE data_lancamento = DATE '2026-04-03'
      AND historico = 'Venda de mercadorias à vista'
);

--Baixa do custo: debito em CMV, credito em Estoque.
INSERT INTO contabil.lancamentos
    (data_lancamento, historico, conta_debito_id, conta_credito_id, valor)
SELECT
    DATE '2026-04-03',
    'Baixa do custo da mercadoria vendida',
    (SELECT id FROM contabil.plano_contas
     WHERE nome_conta = 'Custo das Mercadorias Vendidas' ORDER BY id LIMIT 1),
    (SELECT id FROM contabil.plano_contas
     WHERE nome_conta = 'Estoque de Mercadorias' ORDER BY id LIMIT 1),
    3000.00
WHERE NOT EXISTS (
    SELECT 1 FROM contabil.lancamentos
    WHERE data_lancamento = DATE '2026-04-03'
      AND historico = 'Baixa do custo da mercadoria vendida'
);

--  Pagamento de aluguel: debito em Despesas com Aluguel, credito em Bancos.
INSERT INTO contabil.lancamentos
    (data_lancamento, historico, conta_debito_id, conta_credito_id, valor)
SELECT
    DATE '2026-04-05',
    'Pagamento de aluguel do mês',
    (SELECT id FROM contabil.plano_contas
     WHERE nome_conta = 'Despesas com Aluguel' ORDER BY id LIMIT 1),
    (SELECT id FROM contabil.plano_contas
     WHERE nome_conta = 'Bancos - Conta Movimento' ORDER BY id LIMIT 1),
    1500.00
WHERE NOT EXISTS (
    SELECT 1 FROM contabil.lancamentos
    WHERE data_lancamento = DATE '2026-04-05'
      AND historico = 'Pagamento de aluguel do mês'
);

--Compra a prazo: debito em Estoque, credito em Fornecedores.
INSERT INTO contabil.lancamentos
    (data_lancamento, historico, conta_debito_id, conta_credito_id, valor)
SELECT
    DATE '2026-04-06',
    'Compra de mercadorias a prazo',
    (SELECT id FROM contabil.plano_contas
     WHERE nome_conta = 'Estoque de Mercadorias' ORDER BY id LIMIT 1),
    (SELECT id FROM contabil.plano_contas
     WHERE nome_conta = 'Fornecedores a Pagar' ORDER BY id LIMIT 1),
    4000.00
WHERE NOT EXISTS (
    SELECT 1 FROM contabil.lancamentos
    WHERE data_lancamento = DATE '2026-04-06'
      AND historico = 'Compra de mercadorias a prazo'
);



-- ATIVIDADE 7 - Consulta com JOIN por registro do plano de contas
-- O dump atual tem contas repetidas; esta consulta mostra cada id separado.


SELECT
    pc.id AS conta_id,
    BTRIM(pc.codigo, E' \t\n\r') AS codigo,
    pc.nome_conta,
    pc.natureza_conta,
    sc.saldo
FROM contabil.plano_contas pc
JOIN contabil.saldo_contas sc
    ON sc.conta_id = pc.id
ORDER BY BTRIM(pc.codigo, E' \t\n\r'), pc.id;


-- Consulta complementar para comparar com os saldos esperados do enunciado.
-- Agrupa registros duplicados que possuem o mesmo codigo, nome e natureza.
SELECT
    BTRIM(pc.codigo, E' \t\n\r') AS codigo,
    pc.nome_conta,
    pc.natureza_conta,
    SUM(sc.saldo) AS saldo
FROM contabil.plano_contas pc
JOIN contabil.saldo_contas sc
    ON sc.conta_id = pc.id
GROUP BY BTRIM(pc.codigo, E' \t\n\r'), pc.nome_conta, pc.natureza_conta
ORDER BY BTRIM(pc.codigo, E' \t\n\r'), pc.nome_conta;



-- ATIVIDADE 8 - Soma dos saldos agrupada por natureza
-- Os totais devem ser iguais porque todo lancamento registra debito e credito
-- pelo mesmo valor, mantendo o equilibrio contabil.


SELECT
    pc.natureza_conta,
    SUM(sc.saldo) AS total_saldo
FROM contabil.plano_contas pc
JOIN contabil.saldo_contas sc
    ON sc.conta_id = pc.id
GROUP BY pc.natureza_conta
ORDER BY pc.natureza_conta;




-- Esta trigger atualiza saldos apenas apos INSERT. Se um lancamento for alterado
-- ou excluido, o saldo acumulado nao sera corrigido automaticamente.
-- Para manter os saldos corretos, seria necessario criar tratamento para UPDATE e
-- DELETE: estornar o efeito dos dados OLD e, no UPDATE, aplicar o efeito dos dados
-- NEW; outra opcao seria recalcular os saldos usando todos os lancamentos.
