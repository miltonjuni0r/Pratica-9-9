--
-- PostgreSQL database dump
--

\restrict DqM2HLe40Bet91SzaadiAnHgGkiQgPPMyepjdEx5R6YniRKRf1fkk6DwuE2CFOz

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-09-09 21:34:09

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
-- TOC entry 6 (class 2615 OID 24577)
-- Name: contabil; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA contabil;


ALTER SCHEMA contabil OWNER TO postgres;

--
-- TOC entry 859 (class 1247 OID 24590)
-- Name: natureza_conta_enum; Type: TYPE; Schema: contabil; Owner: postgres
--

CREATE TYPE contabil.natureza_conta_enum AS ENUM (
    'Devedora',
    'Credora'
);


ALTER TYPE contabil.natureza_conta_enum OWNER TO postgres;

--
-- TOC entry 856 (class 1247 OID 24579)
-- Name: tipo_conta_enum; Type: TYPE; Schema: contabil; Owner: postgres
--

CREATE TYPE contabil.tipo_conta_enum AS ENUM (
    'Ativo',
    'Passivo',
    'Patrimonio_liquido',
    'Receita',
    'Despesa'
);


ALTER TYPE contabil.tipo_conta_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 223 (class 1259 OID 24609)
-- Name: lancamentos; Type: TABLE; Schema: contabil; Owner: postgres
--

CREATE TABLE contabil.lancamentos (
    id integer NOT NULL,
    data_lancamento date NOT NULL,
    historico character varying(255),
    conta_debito_id integer,
    conta_credito_id integer,
    valor numeric(10,2)
);


ALTER TABLE contabil.lancamentos OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24608)
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
-- TOC entry 4932 (class 0 OID 0)
-- Dependencies: 222
-- Name: lancamentos_id_seq; Type: SEQUENCE OWNED BY; Schema: contabil; Owner: postgres
--

ALTER SEQUENCE contabil.lancamentos_id_seq OWNED BY contabil.lancamentos.id;


--
-- TOC entry 221 (class 1259 OID 24596)
-- Name: plano_contas; Type: TABLE; Schema: contabil; Owner: postgres
--

CREATE TABLE contabil.plano_contas (
    id integer NOT NULL,
    codigo character varying(40) NOT NULL,
    nome_conta character varying(255) NOT NULL,
    tipo_conta contabil.tipo_conta_enum NOT NULL,
    natureza_conta contabil.natureza_conta_enum DEFAULT 'Devedora'::contabil.natureza_conta_enum NOT NULL
);


ALTER TABLE contabil.plano_contas OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24595)
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
-- TOC entry 4933 (class 0 OID 0)
-- Dependencies: 220
-- Name: plano_contas_id_seq; Type: SEQUENCE OWNED BY; Schema: contabil; Owner: postgres
--

ALTER SEQUENCE contabil.plano_contas_id_seq OWNED BY contabil.plano_contas.id;


--
-- TOC entry 4769 (class 2604 OID 24612)
-- Name: lancamentos id; Type: DEFAULT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.lancamentos ALTER COLUMN id SET DEFAULT nextval('contabil.lancamentos_id_seq'::regclass);


--
-- TOC entry 4767 (class 2604 OID 24599)
-- Name: plano_contas id; Type: DEFAULT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.plano_contas ALTER COLUMN id SET DEFAULT nextval('contabil.plano_contas_id_seq'::regclass);


--
-- TOC entry 4926 (class 0 OID 24609)
-- Dependencies: 223
-- Data for Name: lancamentos; Type: TABLE DATA; Schema: contabil; Owner: postgres
--

COPY contabil.lancamentos (id, data_lancamento, historico, conta_debito_id, conta_credito_id, valor) FROM stdin;
2	2026-03-02	Compra de mercadorias para revenda a prazo	4	4	1800000.00
3	2026-03-01	Aporte de capital dos sócios	2	12	50000.00
4	2026-03-02	Compra de mercadorias para revenda a prazo	25	8	18000.00
5	2026-03-03	Pagamento de aluguel do mês	38	1	3200.00
6	2026-03-03	Venda de mercadorias à vista	1	14	4500.00
7	2026-03-03	Custo das Mercadorias Vendidas	16	25	2700.00
8	2026-03-04	Venda de mercadorias a prazo	3	14	6200.00
9	2026-03-04	Custo das Mercadorias Vendidas	16	25	3720.00
10	2026-03-05	Compra de mercadorias à vista	25	2	9000.00
11	2026-03-05	Pagamento de conta de energia elétrica	5	39	2850.00
12	2026-03-06	Recebimento de cliente (venda dia 04)	2	3	6200.00
13	2026-03-07	Pagamento a fornecedor	8	2	9000.00
14	2026-03-08	Venda de mercadorias à vista	1	14	5100.00
15	2026-03-08	Custo das Mercadorias Vendidas	36	25	3060.00
16	2026-03-09	Pagamento de salários	17	2	7500.00
17	2026-03-09	Retenção de INSS/FGTS sobre a folha	17	10	1650.00
18	2026-03-10	Pagamento de telefone e internet	21	2	320.00
19	2026-03-10	Compra de mercadorias a prazo	25	8	14500.00
20	2026-03-11	Venda de mercadorias a prazo	3	14	8300.00
21	2026-03-11	Custo das Mercadorias Vendidas	36	25	4980.00
22	2026-03-12	Pagamento de tarifas bancárias	22	2	95.00
23	2026-03-12	Combustível para entregas	23	1	410.00
24	2026-03-13	Recebimento de cliente	2	3	8300.00
25	2026-03-14	Venda de mercadorias à vista	1	14	3900.00
26	2026-03-14	Custo das Mercadorias Vendidas	36	25	2340.00
27	2026-03-15	Pagamento de água	20	2	210.00
28	2026-03-15	Empréstimo bancário recebido	2	11	20000.00
29	2026-03-16	Compra de veículo para entregas, à vista	27	2	22000.00
30	2026-03-16	Compra de mercadorias a prazo	25	8	11200.00
31	2026-03-17	Venda de mercadorias a prazo	3	14	7400.00
32	2026-03-17	Custo das Mercadorias Vendidas	36	25	4440.00
33	2026-03-18	Pagamento a fornecedores	8	2	14500.00
34	2026-03-18	Prestação de serviço de instalação	2	15	1800.00
35	2026-03-19	Venda de mercadorias à vista	1	14	4700.00
36	2026-03-19	Custo Mercadorias Vendidas	36	25	2820.00
37	2026-03-20	Pagamento de parcela do empréstimo	11	2	2000.00
38	2026-03-20	Material de escritório	24	1	180.00
39	2026-03-21	Recebimento de cliente	2	3	7400.00
40	2026-03-21	Venda de mercadorias a prazo	3	14	5600.00
41	2026-03-21	Custo das Mercadorias Vendidas	36	25	3360.00
42	2026-03-22	Compra de mercadorias à vista	25	1	6000.00
43	2026-03-23	Pagamento de tarifas bancárias	22	2	88.00
44	2026-03-24	Venda de mercadorias à vista	1	14	3300.00
45	2026-03-24	Custo das Mercadorias Vendidas	36	25	1980.00
46	2026-03-25	Pagamento de impostos (Simples Nacional)	10	2	2450.00
47	2026-03-25	Venda de mercadorias à vista	1	14	3300.00
48	2026-03-25	Custo das Mercadorias Vendidas	36	25	1980.00
49	2026-03-26	Adiantamento de aluguel	38	2	0.00
50	2026-03-27	Compra de mercadorias a prazo	25	8	9800.00
51	2026-03-28	Venda de mercadorias a prazo	3	14	6100.00
52	2026-03-28	Custo das Mercadorias Vendidas	36	25	3660.00
53	2026-03-29	Pagamento de salários	17	2	7500.00
54	2026-03-30	Recebimento de cliente	2	3	5600.00
55	2026-03-31	Despesas diversas do mês	24	24	150.00
\.


--
-- TOC entry 4924 (class 0 OID 24596)
-- Dependencies: 221
-- Data for Name: plano_contas; Type: TABLE DATA; Schema: contabil; Owner: postgres
--

COPY contabil.plano_contas (id, codigo, nome_conta, tipo_conta, natureza_conta) FROM stdin;
1	1.1.01	Caixa	Ativo	Devedora
2	\t1.1.02\t	Bancos - Conta Movimento	Ativo	Devedora
3	1.1.03	Clientes a Receber	Ativo	Devedora
4	1.1.04	Estoque de Mercadorias	Ativo	Devedora
5	1.1.04	Estoque de Mercadorias	Ativo	Devedora
6	1.2.01	Móveis e Utensílios	Ativo	Devedora
7	1.2.02	Veículos	Ativo	Devedora
8	2.1.01	Fornecedores a Pagar	Passivo	Credora
9	2.1.02	Salarios a Pagar	Passivo	Credora
10	2.1.03	Impostos a Recolher	Passivo	Credora
11	2.2.01	Emprestimos Bancarios (LP)	Passivo	Credora
12	3.1.01	Capital Social	Patrimonio_liquido	Credora
13	3.1.02	Lucros/Prejuízos Acumulados	Patrimonio_liquido	Credora
14	4.1.01	Receita de Vendas	Receita	Credora
15	4.1.02	Receita de Serviços	Receita	Credora
16	5.1.01	Custo das Mercadorias Vendidas	Despesa	Devedora
17	5.1.02	Despesas com Salários	Despesa	Devedora
18	5.1.03	Despesas com Aluguel	Despesa	Devedora
19	5.1.04	Despesas com Energia Eletrica	Despesa	Devedora
20	5.1.05	Despesas com Água	Despesa	Devedora
21	5.1.06	Despesas com Telefone/Internet	Despesa	Devedora
22	5.1.07	Despesas Bancárias/Tarifas	Despesa	Devedora
23	5.1.08	Despesas com Combustível	Despesa	Devedora
24	5.1.09	Despesas Diversas	Despesa	Devedora
25	1.1.04	Estoque de Mercadorias	Ativo	Devedora
26	1.2.01	Móveis e Utensílios	Ativo	Devedora
27	1.2.02	Veículos	Ativo	Devedora
28	2.1.01	Fornecedores a Pagar	Passivo	Credora
29	2.1.02	Salarios a Pagar	Passivo	Credora
30	2.1.03	Impostos a Recolher	Passivo	Credora
31	2.2.01	Emprestimos Bancarios (LP)	Passivo	Credora
32	3.1.01	Capital Social	Patrimonio_liquido	Credora
33	3.1.02	Lucros/Prejuízos Acumulados	Patrimonio_liquido	Credora
34	4.1.01	Receita de Vendas	Receita	Credora
35	4.1.02	Receita de Serviços	Receita	Credora
36	5.1.01	Custo das Mercadorias Vendidas	Despesa	Devedora
37	5.1.02	Despesas com Salários	Despesa	Devedora
38	5.1.03	Despesas com Aluguel	Despesa	Devedora
39	5.1.04	Despesas com Energia Eletrica	Despesa	Devedora
40	5.1.05	Despesas com Água	Despesa	Devedora
41	5.1.06	Despesas com Telefone/Internet	Despesa	Devedora
42	5.1.07	Despesas Bancárias/Tarifas	Despesa	Devedora
43	5.1.08	Despesas com Combustível	Despesa	Devedora
44	5.1.09	Despesas Diversas	Despesa	Devedora
\.


--
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 222
-- Name: lancamentos_id_seq; Type: SEQUENCE SET; Schema: contabil; Owner: postgres
--

SELECT pg_catalog.setval('contabil.lancamentos_id_seq', 55, true);


--
-- TOC entry 4935 (class 0 OID 0)
-- Dependencies: 220
-- Name: plano_contas_id_seq; Type: SEQUENCE SET; Schema: contabil; Owner: postgres
--

SELECT pg_catalog.setval('contabil.plano_contas_id_seq', 44, true);


--
-- TOC entry 4773 (class 2606 OID 24616)
-- Name: lancamentos pk_lancamentos; Type: CONSTRAINT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.lancamentos
    ADD CONSTRAINT pk_lancamentos PRIMARY KEY (id);


--
-- TOC entry 4771 (class 2606 OID 24607)
-- Name: plano_contas pk_plano_contas; Type: CONSTRAINT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.plano_contas
    ADD CONSTRAINT pk_plano_contas PRIMARY KEY (id);


--
-- TOC entry 4774 (class 2606 OID 24622)
-- Name: lancamentos fk_conta_credito; Type: FK CONSTRAINT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.lancamentos
    ADD CONSTRAINT fk_conta_credito FOREIGN KEY (conta_credito_id) REFERENCES contabil.plano_contas(id);


--
-- TOC entry 4775 (class 2606 OID 24617)
-- Name: lancamentos fk_conta_debito; Type: FK CONSTRAINT; Schema: contabil; Owner: postgres
--

ALTER TABLE ONLY contabil.lancamentos
    ADD CONSTRAINT fk_conta_debito FOREIGN KEY (conta_debito_id) REFERENCES contabil.plano_contas(id);


-- Completed on 2026-09-09 21:34:09

--
-- PostgreSQL database dump complete
--

\unrestrict DqM2HLe40Bet91SzaadiAnHgGkiQgPPMyepjdEx5R6YniRKRf1fkk6DwuE2CFOz

