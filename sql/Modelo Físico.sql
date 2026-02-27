-- Trabalho Eng. da Informação
-- Modelo físico (PostgreSQL) - integração SAP / Strawts / MoC
-- Observação: regras do ISA (total/disjunto) ficam garantidas na carga/ETL.

CREATE TABLE fonte_sistema (
  id_fonte  SERIAL PRIMARY KEY,
  nome_fonte VARCHAR(51) NOT NULL
);

CREATE TABLE colaborador (
  matricula VARCHAR(50) PRIMARY KEY,
  nome      VARCHAR(120) NOT NULL
);

-- Supertipo (tabela principal)
CREATE TABLE acao_tarefa (
  identificador SERIAL PRIMARY KEY,
  titulo        VARCHAR(200),
  descricao     TEXT,
  prazo         DATE,
  status        VARCHAR(60),

  -- origem do registro
  id_fonte      INT NOT NULL,
  -- responsável
  matricula     VARCHAR(50) NOT NULL,

  CONSTRAINT fk_acao_fonte
    FOREIGN KEY (id_fonte) REFERENCES fonte_sistema(id_fonte),

  CONSTRAINT fk_acao_colaborador
    FOREIGN KEY (matricula) REFERENCES colaborador(matricula)
);

-- Subtipo SAP (1:1 com acao_tarefa)
CREATE TABLE acao_sap (
  identificador  INT PRIMARY KEY,
  id_da_acao_sap VARCHAR(80),

  CONSTRAINT fk_sap_acao
    FOREIGN KEY (identificador) REFERENCES acao_tarefa(identificador)
);

-- Subtipo Strawts (1:1 com acao_tarefa)
CREATE TABLE acao_strawts (
  identificador INT PRIMARY KEY,
  id_da_acao    VARCHAR(80),
  elaborador    VARCHAR(120),
  gestor        VARCHAR(120),
  gerencia_do_elaborador VARCHAR(120),
  executante    VARCHAR(120),

  CONSTRAINT fk_strawts_acao
    FOREIGN KEY (identificador) REFERENCES acao_tarefa(identificador)
);

-- Subtipo MoC (1:1 com acao_tarefa)
CREATE TABLE acao_moc (
  identificador INT PRIMARY KEY,

  gerencia_do_responsavel_da_tarefa VARCHAR(120),
  unidade_organizadora VARCHAR(120),

  status_do_plano VARCHAR(60),
  status_moc      VARCHAR(60),

  responsavel_do_plano VARCHAR(120),
  codigo_do_plano VARCHAR(80),
  titulo_da_mudanca VARCHAR(200),

  codigo_da_tarefa VARCHAR(80),
  responsavel_do_moc VARCHAR(120),

  descricao_do_plano TEXT,
  prazo_da_tarefa DATE,
  descricao_da_tarefa TEXT,

  CONSTRAINT fk_moc_acao
    FOREIGN KEY (identificador) REFERENCES acao_tarefa(identificador)
);

-- índices simples pra ajudar consulta (opcional)
CREATE INDEX idx_acao_id_fonte ON acao_tarefa(id_fonte);
CREATE INDEX idx_acao_matricula ON acao_tarefa(matricula);
CREATE INDEX idx_acao_prazo ON acao_tarefa(prazo);