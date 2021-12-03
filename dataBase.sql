CREATE TABLE IF NOT EXISTS endereco (
  idendereco SERIAL,
  logradouro TEXT NULL,
  telefone TEXT NULL,
  cep TEXT NULL,
  endereco VARCHAR(45) NULL,
  PRIMARY KEY (idendereco));

CREATE TABLE IF NOT EXISTS categoria (
  idcategoria SERIAL,
  descricao TEXT NULL,
  PRIMARY KEY (idcategoria));

CREATE TABLE IF NOT EXISTS usuario (
  idusuario SERIAL,
  idCategoria INT NOT NULL,
  idEndereco INT NULL,
  nome VARCHAR(60) NULL,
  cpf VARCHAR(11) NULL,
  email VARCHAR(55) NULL,
  senha VARCHAR(20) NULL,
  fotoPerfil TEXT NULL,	
  status BOOLEAN NULL,
  PRIMARY KEY (idusuario),
  CONSTRAINT idEndereco
    FOREIGN KEY (idEndereco)
    REFERENCES endereco (idendereco)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT idCategoria
    FOREIGN KEY (idCategoria)
    REFERENCES categoria (idcategoria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE IF NOT EXISTS especie (
  idespecie SERIAL,
  descricao TEXT NULL,
  PRIMARY KEY (idespecie));

CREATE TABLE IF NOT EXISTS raca (
  idraca SERIAL,
  idespecie INT NULL,
  descricao TEXT NULL,
  PRIMARY KEY (idraca),
  CONSTRAINT idespecie
    FOREIGN KEY (idespecie)
    REFERENCES especie (idespecie)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE IF NOT EXISTS porte (
  idporte SERIAL,
  descricao TEXT NULL,
  PRIMARY KEY (idporte));

CREATE TABLE IF NOT EXISTS animal (
  idanimal SERIAL,
  idusuario INT NULL,
  idespecie INT NULL,
  idraca INT NULL,
  idporte INT NULL,
  nome VARCHAR(50) NULL,
  idade INT NULL,
  fotoanimal TEXT NULL,
  status BOOLEAN NULL,
  PRIMARY KEY (idanimal),
  CONSTRAINT idespecie
    FOREIGN KEY (idespecie)
    REFERENCES especie (idespecie)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT idusuario
    FOREIGN KEY (idusuario)
    REFERENCES usuario (idusuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT idraca
    FOREIGN KEY (idraca)
    REFERENCES raca (idraca)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT idporte
    FOREIGN KEY (idporte)
    REFERENCES porte (idporte)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE IF NOT EXISTS coordenada (
  idcoordenada SERIAL,
  latitude TEXT NULL,
  longitude TEXT NULL,
  PRIMARY KEY (idcoordenada));


CREATE TABLE IF NOT EXISTS aviso (
  idaviso SERIAL,
  idcoordenada INT NULL,
  idAnimal INT NULL,
  descricao VARCHAR(100) NULL,
  data TIMESTAMP NULL,
  status BOOLEAN NULL,
  estado INT NULL,
  PRIMARY KEY (idaviso),
  CONSTRAINT idcoordenada
    FOREIGN KEY (idcoordenada)
    REFERENCES coordenada (idcoordenada)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT idanimal
    FOREIGN KEY (idAnimal)
    REFERENCES animal (idanimal)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE IF NOT exists mensagem (
  idmensagem SERIAL,
  idorigem INT NULL,
  iddestino INT NULL,
  conteudo VARCHAR(150) NULL,
  PRIMARY KEY (idmensagem),
  CONSTRAINT idorigem
    FOREIGN KEY (idorigem)
    REFERENCES usuario (idusuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT iddestino
    FOREIGN KEY (iddestino)
    REFERENCES usuario (idusuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE IF NOT EXISTS chat (
  idchat SERIAL,
  idmensagem INT NULL,
  PRIMARY KEY (idchat),
  CONSTRAINT idmensagem
    FOREIGN KEY (idmensagem)
    REFERENCES public.mensagem (idmensagem)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

insert into categoria (descricao) values ('usuario');
insert into categoria (descricao) values ('admin');
insert into especie (descricao) values ('canino');
insert into porte (descricao) values ('grande');
insert into raca (idespecie, descricao) values (1, 'bulldog');