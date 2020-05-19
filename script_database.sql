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
    REFERENCES `cuidapet_db`.`fornecedor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;