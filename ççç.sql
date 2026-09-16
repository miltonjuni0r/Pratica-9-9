--
-- PostgreSQL database dump
--

\restrict L7yuMHv2nInSi2rtLW1r8PJjv9bCxhfdwZQajh2tsKNlocG0we70EfvNtOTZ1d1

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-09-16 19:56:34

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 24640)
-- Name: contabil; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA contabil;


ALTER SCHEMA contabil OWNER TO postgres;

--
-- TOC entry 861 (class 1247 OID 24654)
-- Name: natureza_conta_enum; Type: TYPE; Schema: contabil; Owner: postgres
--

CREATE TYPE contabil.natureza_conta_enum AS ENUM (
    'DEVEDORA',
    'CREDORA'
);


ALTER TYPE contabil.natureza_conta_enum OWNER TO postgres;

--
-- TOC entry 858 (class 1247 OID 24642)
-- Name: tipo_conta_enum; Type: TYPE; Schema: contabil; Owner: postgres
--

CREATE TYPE contabil.tipo_conta_enum AS ENUM (
    'ATIVO',
    'PASSIVO',
    'PATROMONIO_LIQUIDO',
    'RECEITA',
    'DESPESA'
);


ALTER TYPE contabil.tipo_conta_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 223 (class 1259 OID 24673)
-- Name: lancamentos; Type: TABLE; Schema: contabil; Owner: postgres
--

CREATE TABLE contabil.lancamentos (
    id integer NOT NULL,
    data_lancamento date NOT NULL,
    historico character varying(255),
    conta_debito_id integer,
    conta_credito_id integer,
    valor numeric(15,2)
);


ALTER TABLE contabil.lancamentos OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24672)
-- Name: lancamentos_id_seq; Type: SEQUENCE; Schema: contabil; Owner: postgres
--

CREATE SEQUENCE contabil.lancamentos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contabil.lancamentos_id_seq OWNER TO postgres;

--
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 222
-- Name: lancamentos_id_seq; Type: SEQUENCE OWNED BY; Schema: contabil; Owner: postgres
--

ALTER SEQUENCE contabil.lancamentos_id_seq OWNED BY contabil.lancamentos.id;


--
-- TOC entry 221 (class 1259 OID 24660)
-- Name: plano_contas; Type: TABLE; Schema: contabil; Owner: postgres
--

CREATE TABLE contabil.plano_contas (
    id integer NOT NULL,
    codigo character varying(40) NOT NULL,
    nome_conta character varying(255) NOT NULL,
    tipo_conta contabil.tipo_conta_enum NOT NULL,
    natureza_conta contabil.natureza_conta_enum DEFAULT 'DEVEDORA'::contabil.natureza_conta_enum NOT NULL
);


ALTER TABLE contabil.plano_contas OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24659)
-- Name: plano_contas_id_seq; Type: SEQUENCE; Schema: contabil; Owner: postgres
--

CREATE SEQUENCE contabil.plano_contas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contabil.plano_contas_id_seq OWNER TO postgres;

--
-- TOC entry 4942 (class 0 OID 0)
-- Dependencies: 220
-- Name: plano_contas_id_seq; Type: SEQUENCE OWNED BY; Schema: contabil; Owner: postgres
--

ALTER SEQUENCE contabil.plano_contas_id_seq OWNED BY contabil.plano_contas.id;


--
-- TOC entry 225 (class 1259 OID 24695)
-- Name: vw_visu; Type: VIEW; Schema: contabil; Owner: postgres
--

CREATE VIEW contabil.vw_visu AS
 SELECT l.data_lancamento,
    l.historico,
    p.nome_conta,
    l.valor
   FROM ((contabil.lancamentos l
     JOIN contabil.plano_contas p ON ((l.conta_credito_id = p.id)))
     JOIN contabil.plano_contas pp ON ((l.conta_debito_id = pp.id)));


ALTER VIEW contabil.vw_visu OWNER TO postgres;

--
-- TOC entry 4776 (class 2604 OID 24676)
-- Name: lancamentos id; Type: DEFAULT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.lancamentos ALTER COLUMN id SET DEFAULT nextval('contabil.lancamentos_id_seq'::regclass);


--
-- TOC entry 4774 (class 2604 OID 24663)
-- Name: plano_contas id; Type: DEFAULT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.plano_contas ALTER COLUMN id SET DEFAULT nextval('contabil.plano_contas_id_seq'::regclass);


--
-- TOC entry 4935 (class 0 OID 24673)
-- Dependencies: 223
-- Data for Name: lancamentos; Type: TABLE DATA; Schema: contabil; Owner: postgres
--

INSERT INTO contabil.lancamentos VALUES (1, '2026-03-01', 'Aporte de capital dos sócios', 25, 34, 50000.00);
INSERT INTO contabil.lancamentos VALUES (2, '2026-03-02', 'Compra de mercadorias para revenda, a prazo', 27, 30, 18000.00);
INSERT INTO contabil.lancamentos VALUES (3, '2026-03-03', 'Pagamento de aluguel do mês', 40, 24, 3200.00);
INSERT INTO contabil.lancamentos VALUES (4, '2026-03-03', 'Venda de mercadorias à vista', 24, 36, 4500.00);
INSERT INTO contabil.lancamentos VALUES (5, '2026-03-03', 'Baixa do custo da mercadoria vendida', 38, 27, 2700.00);
INSERT INTO contabil.lancamentos VALUES (6, '2026-03-04', 'Venda de mercadorias a prazo', 26, 36, 6200.00);
INSERT INTO contabil.lancamentos VALUES (7, '2026-03-04', 'Baixa do CMV da venda a prazo', 38, 27, 3720.00);
INSERT INTO contabil.lancamentos VALUES (8, '2026-03-05', 'Compra de mercadorias à vista', 27, 25, 9000.00);
INSERT INTO contabil.lancamentos VALUES (9, '2026-03-05', 'Pagamento de conta de energia elétrica', 41, 25, 850.00);
INSERT INTO contabil.lancamentos VALUES (10, '2026-03-06', 'Recebimento de cliente (venda dia 04)', 25, 26, 6200.00);
INSERT INTO contabil.lancamentos VALUES (11, '2026-03-07', 'Pagamento a fornecedor', 30, 25, 9000.00);
INSERT INTO contabil.lancamentos VALUES (12, '2026-03-08', 'Venda de mercadorias à vista', 24, 36, 5100.00);
INSERT INTO contabil.lancamentos VALUES (13, '2026-03-08', 'Baixa do CMV', 38, 27, 3060.00);
INSERT INTO contabil.lancamentos VALUES (14, '2026-03-09', 'Pagamento de salários', 39, 25, 7500.00);
INSERT INTO contabil.lancamentos VALUES (15, '2026-03-09', 'Retenção de INSS/FGTS sobre a folha', 39, 32, 1650.00);
INSERT INTO contabil.lancamentos VALUES (16, '2026-03-10', 'Pagamento de telefone e internet', 43, 25, 320.00);
INSERT INTO contabil.lancamentos VALUES (17, '2026-03-10', 'Compra de mercadorias a prazo', 27, 30, 14500.00);
INSERT INTO contabil.lancamentos VALUES (18, '2026-03-11', 'Venda de mercadorias a prazo', 26, 36, 8300.00);
INSERT INTO contabil.lancamentos VALUES (19, '2026-03-11', 'Baixa do CMV', 38, 27, 4980.00);
INSERT INTO contabil.lancamentos VALUES (20, '2026-03-12', 'Pagamento de tarifas bancárias', 44, 25, 95.00);
INSERT INTO contabil.lancamentos VALUES (21, '2026-03-12', 'Combustível para entregas', 45, 24, 410.00);
INSERT INTO contabil.lancamentos VALUES (22, '2026-03-13', 'Recebimento de cliente', 25, 26, 8300.00);
INSERT INTO contabil.lancamentos VALUES (23, '2026-03-14', 'Venda de mercadorias à vista', 24, 36, 3900.00);
INSERT INTO contabil.lancamentos VALUES (24, '2026-03-14', 'Baixa do CMV', 38, 27, 2340.00);
INSERT INTO contabil.lancamentos VALUES (25, '2026-03-15', 'Pagamento de água', 42, 25, 210.00);
INSERT INTO contabil.lancamentos VALUES (26, '2026-03-15', 'Empréstimo bancário recebido', 25, 33, 20000.00);
INSERT INTO contabil.lancamentos VALUES (27, '2026-03-16', 'Compra de veículo para entregas, à vista', 29, 25, 22000.00);
INSERT INTO contabil.lancamentos VALUES (28, '2026-03-16', 'Compra de mercadorias a prazo', 27, 30, 11200.00);
INSERT INTO contabil.lancamentos VALUES (29, '2026-03-17', 'Venda de mercadorias a prazo', 26, 36, 7400.00);
INSERT INTO contabil.lancamentos VALUES (30, '2026-03-17', 'Baixa do CMV', 38, 27, 4440.00);
INSERT INTO contabil.lancamentos VALUES (31, '2026-03-18', 'Pagamento a fornecedores', 30, 25, 14500.00);
INSERT INTO contabil.lancamentos VALUES (32, '2026-03-18', 'Prestação de serviço de instalação', 25, 37, 1800.00);
INSERT INTO contabil.lancamentos VALUES (33, '2026-03-19', 'Venda de mercadorias à vista', 24, 36, 4700.00);
INSERT INTO contabil.lancamentos VALUES (34, '2026-03-19', 'Baixa do CMV', 38, 27, 2820.00);
INSERT INTO contabil.lancamentos VALUES (35, '2026-03-20', 'Pagamento de parcela do empréstimo', 33, 25, 2000.00);
INSERT INTO contabil.lancamentos VALUES (36, '2026-03-20', 'Material de escritório', 46, 24, 180.00);
INSERT INTO contabil.lancamentos VALUES (37, '2026-03-21', 'Recebimento de cliente', 25, 26, 7400.00);
INSERT INTO contabil.lancamentos VALUES (38, '2026-03-21', 'Venda de mercadorias a prazo', 26, 36, 5600.00);
INSERT INTO contabil.lancamentos VALUES (39, '2026-03-21', 'Baixa do CMV', 38, 27, 3360.00);
INSERT INTO contabil.lancamentos VALUES (40, '2026-03-22', 'Compra de mercadorias à vista', 27, 24, 6000.00);
INSERT INTO contabil.lancamentos VALUES (41, '2026-03-23', 'Pagamento de tarifas bancárias', 44, 25, 88.00);
INSERT INTO contabil.lancamentos VALUES (42, '2026-03-24', 'Venda de mercadorias à vista', 24, 36, 3300.00);
INSERT INTO contabil.lancamentos VALUES (43, '2026-03-24', 'Baixa do CMV', 38, 27, 1980.00);
INSERT INTO contabil.lancamentos VALUES (44, '2026-03-25', 'Pagamento de impostos (Simples Nacional)', 32, 25, 2450.00);
INSERT INTO contabil.lancamentos VALUES (45, '2026-03-25', 'Venda de mercadorias à vista', 24, 36, 3300.00);
INSERT INTO contabil.lancamentos VALUES (46, '2026-03-25', 'Baixa do CMV', 38, 27, 1980.00);
INSERT INTO contabil.lancamentos VALUES (47, '2026-03-26', 'Adiantamento de aluguel', 40, 25, NULL);
INSERT INTO contabil.lancamentos VALUES (48, '2026-03-27', 'Compra de mercadorias a prazo', 27, 30, 9800.00);
INSERT INTO contabil.lancamentos VALUES (49, '2026-03-28', 'Venda de mercadorias a prazo', 26, 36, 6100.00);
INSERT INTO contabil.lancamentos VALUES (50, '2026-03-28', 'Baixa do CMV', 38, 27, 3660.00);
INSERT INTO contabil.lancamentos VALUES (51, '2026-03-29', 'Pagamento de salários', 39, 25, 7500.00);
INSERT INTO contabil.lancamentos VALUES (52, '2026-03-30', 'Recebimento de cliente', 25, 26, 5600.00);
INSERT INTO contabil.lancamentos VALUES (53, '2026-03-31', 'Despesas diversas do mês', 46, 24, 150.00);


--
-- TOC entry 4933 (class 0 OID 24660)
-- Dependencies: 221
-- Data for Name: plano_contas; Type: TABLE DATA; Schema: contabil; Owner: postgres
--

INSERT INTO contabil.plano_contas VALUES (24, '1.1.01', 'Caixa', 'ATIVO', 'DEVEDORA');
INSERT INTO contabil.plano_contas VALUES (25, '1.1.02', 'Bancos - Conta Movimento', 'ATIVO', 'DEVEDORA');
INSERT INTO contabil.plano_contas VALUES (26, '1.1.03', 'Clientes a Receber', 'ATIVO', 'DEVEDORA');
INSERT INTO contabil.plano_contas VALUES (27, '1.1.04', 'Estoque de Mercadorias', 'ATIVO', 'DEVEDORA');
INSERT INTO contabil.plano_contas VALUES (28, '1.2.01', 'Móveis e Utensílios', 'ATIVO', 'DEVEDORA');
INSERT INTO contabil.plano_contas VALUES (29, '1.2.02', 'Veículos', 'ATIVO', 'DEVEDORA');
INSERT INTO contabil.plano_contas VALUES (30, '2.1.01', 'Fornecedores a Pagar', 'PASSIVO', 'CREDORA');
INSERT INTO contabil.plano_contas VALUES (31, '2.1.02', 'Salários a Pagar', 'PASSIVO', 'CREDORA');
INSERT INTO contabil.plano_contas VALUES (32, '2.1.03', 'Impostos a Recolher', 'PASSIVO', 'CREDORA');
INSERT INTO contabil.plano_contas VALUES (33, '2.2.01', 'Empréstimos Bancários (LP)', 'PASSIVO', 'CREDORA');
INSERT INTO contabil.plano_contas VALUES (34, '3.1.01', 'Capital Social', 'PATROMONIO_LIQUIDO', 'CREDORA');
INSERT INTO contabil.plano_contas VALUES (35, '3.1.02', 'Lucros/Prejuízos Acumulados', 'PATROMONIO_LIQUIDO', 'CREDORA');
INSERT INTO contabil.plano_contas VALUES (36, '4.1.01', 'Receita de Vendas', 'RECEITA', 'CREDORA');
INSERT INTO contabil.plano_contas VALUES (37, '4.1.02', 'Receita de Serviços', 'RECEITA', 'CREDORA');
INSERT INTO contabil.plano_contas VALUES (38, '5.1.01', 'Custo das Mercadorias Vendidas', 'DESPESA', 'DEVEDORA');
INSERT INTO contabil.plano_contas VALUES (39, '5.1.02', 'Despesas com Salários', 'DESPESA', 'DEVEDORA');
INSERT INTO contabil.plano_contas VALUES (40, '5.1.03', 'Despesas com Aluguel', 'DESPESA', 'DEVEDORA');
INSERT INTO contabil.plano_contas VALUES (41, '5.1.04', 'Despesas com Energia Elétrica', 'DESPESA', 'DEVEDORA');
INSERT INTO contabil.plano_contas VALUES (42, '5.1.05', 'Despesas com Água', 'DESPESA', 'DEVEDORA');
INSERT INTO contabil.plano_contas VALUES (43, '5.1.06', 'Despesas com Telefone/Internet', 'DESPESA', 'DEVEDORA');
INSERT INTO contabil.plano_contas VALUES (44, '5.1.07', 'Despesas Bancárias/Tarifas', 'DESPESA', 'DEVEDORA');
INSERT INTO contabil.plano_contas VALUES (45, '5.1.08', 'Despesas com Combustível', 'DESPESA', 'DEVEDORA');
INSERT INTO contabil.plano_contas VALUES (46, '5.1.09', 'Despesas Diversas', 'DESPESA', 'DEVEDORA');


--
-- TOC entry 4943 (class 0 OID 0)
-- Dependencies: 222
-- Name: lancamentos_id_seq; Type: SEQUENCE SET; Schema: contabil; Owner: postgres
--

SELECT pg_catalog.setval('contabil.lancamentos_id_seq', 53, true);


--
-- TOC entry 4944 (class 0 OID 0)
-- Dependencies: 220
-- Name: plano_contas_id_seq; Type: SEQUENCE SET; Schema: contabil; Owner: postgres
--

SELECT pg_catalog.setval('contabil.plano_contas_id_seq', 46, true);


--
-- TOC entry 4780 (class 2606 OID 24680)
-- Name: lancamentos pk_lancamentos; Type: CONSTRAINT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.lancamentos
    ADD CONSTRAINT pk_lancamentos PRIMARY KEY (id);


--
-- TOC entry 4778 (class 2606 OID 24671)
-- Name: plano_contas pk_plano_contas; Type: CONSTRAINT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.plano_contas
    ADD CONSTRAINT pk_plano_contas PRIMARY KEY (id);


--
-- TOC entry 4781 (class 2606 OID 24686)
-- Name: lancamentos fk_conta_credito; Type: FK CONSTRAINT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.lancamentos
    ADD CONSTRAINT fk_conta_credito FOREIGN KEY (conta_credito_id) REFERENCES contabil.plano_contas(id);


--
-- TOC entry 4782 (class 2606 OID 24681)
-- Name: lancamentos fk_conta_debito; Type: FK CONSTRAINT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.lancamentos
    ADD CONSTRAINT fk_conta_debito FOREIGN KEY (conta_debito_id) REFERENCES contabil.plano_contas(id);


-- Completed on 2026-09-16 19:56:34

--
-- PostgreSQL database dump complete
--

\unrestrict L7yuMHv2nInSi2rtLW1r8PJjv9bCxhfdwZQajh2tsKNlocG0we70EfvNtOTZ1d1

