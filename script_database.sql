CREATE TABLE IF NOT EXISTS `usuario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NULL,
  `senha` text NULL,
  `tipo_cadastro` ENUM('FACEBOOK', 'GOOGLE', 'APP') not null,
  `ios_token` TEXT NULL,
  `android_token` TEXT NULL,
  `refresh_token` TEXT NULL,
  img_avatar text null,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `fornecedor` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(200) NULL,
  `logo` TEXT NULL,
  `imagem` TEXT NULL,
  `endereco` VARCHAR(100) NULL,
  `telefone` VARCHAR(45) NULL,
  `latlng` POINT NULL,
  `categorias_fornecedor_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_fornecedor_categorias_fornecedor1_idx` (`categorias_fornecedor_id` ASC) VISIBLE,
  CONSTRAINT `fk_fornecedor_categorias_fornecedor1`
    FOREIGN KEY (`categorias_fornecedor_id`)
    REFERENCES `categorias_fornecedor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `usuario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NULL DEFAULT NULL,
  `senha` TEXT NULL DEFAULT NULL,
  `tipo_cadastro` ENUM('FACEBOOK', 'GOOGLE', 'APP') NOT NULL,
  `ios_token` TEXT NULL DEFAULT NULL,
  `android_token` TEXT NULL DEFAULT NULL,
  `refresh_token` TEXT NULL DEFAULT NULL,
  `img_avatar` TEXT NULL DEFAULT NULL,
  `fornecedor_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_usuario_fornecedor_idx` (`fornecedor_id` ASC) VISIBLE,
  CONSTRAINT `fk_usuario_fornecedor`
    FOREIGN KEY (`fornecedor_id`)
    REFERENCES `fornecedor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 19
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci


CREATE TABLE IF NOT EXISTS `categorias_fornecedor` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome_categoria` VARCHAR(45) NULL,
  `tipo_categoria` char(1) default 'P',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `fornecedor_servicos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fornecedor_id` INT NOT NULL,
  `nome_servico` VARCHAR(200) NULL,
  `valor_servico` DECIMAL(10,2) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_fornecedor_servicos_fornecedor1_idx` (`fornecedor_id` ASC) VISIBLE,
  CONSTRAINT `fk_fornecedor_servicos_fornecedor1`
    FOREIGN KEY (`fornecedor_id`)
    REFERENCES `fornecedor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `agendamento` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_agendamento` DATETIME NULL,
  `usuario_id` INT NOT NULL,
  `fornecedor_id` INT NOT NULL,
  `status` CHAR(2) NOT NULL DEFAULT 'P' COMMENT 'P=Pendente\nCN=Confirmada\nF=Finalizado\nC=Cancelado',
  nome varchar(200) null,
	nome_pet varchar(200) null,
  PRIMARY KEY (`id`),
  INDEX `fk_solicitacao_usuario1_idx` (`usuario_id` ASC) VISIBLE,
  INDEX `fk_solicitacao_fornecedor1_idx` (`fornecedor_id` ASC) VISIBLE,
  CONSTRAINT `fk_solicitacao_usuario1`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_solicitacao_fornecedor1`
    FOREIGN KEY (`fornecedor_id`)
    REFERENCES `fornecedor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `agendamento_servicos` (
  `agendamento_id` INT NOT NULL,
  `fornecedor_servicos_id` INT NOT NULL,
  INDEX `fk_agenda_servicos_agendamento1_idx` (`agendamento_id` ASC) VISIBLE,
  INDEX `fk_agenda_servicos_fornecedor_servicos1_idx` (`fornecedor_servicos_id` ASC) VISIBLE,
  CONSTRAINT `fk_agenda_servicos_agendamento1`
    FOREIGN KEY (`agendamento_id`)
    REFERENCES `agendamento` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_agenda_servicos_fornecedor_servicos1`
    FOREIGN KEY (`fornecedor_servicos_id`)
    REFERENCES `fornecedor_servicos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `chats` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `agendamento_id` INT NOT NULL,
  `status` CHAR(1) NULL DEFAULT 'A',
  `data_criacao` DATETIME NULL DEFAULT now(),
  PRIMARY KEY (`id`),
  INDEX `fk_chats_agendamento1_idx` (`agendamento_id` ASC) VISIBLE,
  CONSTRAINT `fk_chats_agendamento1`
    FOREIGN KEY (`agendamento_id`)
    REFERENCES `agendamento` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;