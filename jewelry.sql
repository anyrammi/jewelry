SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema jewelry
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `jewelry` ;

-- -----------------------------------------------------
-- Schema jewelry
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `jewelry` DEFAULT CHARACTER SET UTF8MB3 ;
USE `jewelry` ;

-- -----------------------------------------------------
-- Table `material`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `material` ;

CREATE TABLE IF NOT EXISTS `material` (
    `material_id` INT NOT NULL AUTO_INCREMENT,
    `type_material` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`material_id`)
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8MB3;


-- -----------------------------------------------------
-- Table `type_jewelry`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `type_jewelry` ;

CREATE TABLE IF NOT EXISTS `type_jewelry` (
    `type_jew_id` INT NOT NULL AUTO_INCREMENT,
    `type_jew` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`type_jew_id`)
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8MB3;


-- -----------------------------------------------------
-- Table `jewelry`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jewelry` ;

CREATE TABLE IF NOT EXISTS `jewelry` (
    `jewelry_id` INT NOT NULL AUTO_INCREMENT,
    `type_jew_id` INT NOT NULL,
    `material_id` INT NOT NULL,
    `price` DECIMAL(9 , 2 ) NOT NULL DEFAULT 0.00,
    `available_count` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`jewelry_id`),
    CONSTRAINT `fk_jewelry_material` FOREIGN KEY (`material_id`)
        REFERENCES `material` (`material_id`)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT `fk_jewelry_type_jew` FOREIGN KEY (`type_jew_id`)
        REFERENCES `type_jewelry` (`type_jew_id`)
        ON UPDATE CASCADE
        ON DELETE CASCADE
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8MB3;

CREATE INDEX `jewelry_available_count_idx` ON `jewelry` (`available_count` ASC, `price` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `order_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `order_status` ;

CREATE TABLE IF NOT EXISTS `order_status` (
    `status_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`status_id`)
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8MB3;


-- -----------------------------------------------------
-- Table `role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `role` ;

CREATE TABLE IF NOT EXISTS `role` (
    `role_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`role_id`)
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8MB3;


-- -----------------------------------------------------
-- Table `user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user` ;

CREATE TABLE IF NOT EXISTS `user` (
    `user_id` INT NOT NULL AUTO_INCREMENT,
    `name` CHAR(50) NOT NULL,
    `login` VARCHAR(50) NOT NULL,
    `password` VARCHAR(50) NOT NULL,
    `role_id` INT NOT NULL,
    PRIMARY KEY (`user_id`),
    CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`)
        REFERENCES `role` (`role_id`)
        ON UPDATE CASCADE
        ON DELETE CASCADE
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8MB3;

CREATE UNIQUE INDEX `user_login_idx` ON `user` (`login` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `order` ;

CREATE TABLE IF NOT EXISTS `order` (
    `order_id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `status_id` INT NOT NULL,
    `total_price` DECIMAL(9 , 2 ) NOT NULL DEFAULT 0.00,
    `create_date` DATETIME NOT NULL,
    `end_date` DATETIME NOT NULL,
    PRIMARY KEY (`order_id`),
    CONSTRAINT `fk_order_status` FOREIGN KEY (`status_id`)
        REFERENCES `order_status` (`status_id`)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`)
        REFERENCES `user` (`user_id`)
        ON UPDATE CASCADE
        ON DELETE CASCADE
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8MB3;


-- -----------------------------------------------------
-- Table `order_jewelry`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `order_jewelry` ;

CREATE TABLE IF NOT EXISTS `order_jewelry` (
    `order_id` INT NOT NULL,
    `jewelry_id` INT NOT NULL,
    `count` INT NOT NULL,
    `price` DECIMAL(9 , 2 ) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (`jewelry_id` , `order_id`),
    CONSTRAINT `fk_order_jewelry_jewelry` FOREIGN KEY (`jewelry_id`)
        REFERENCES `jewelry` (`jewelry_id`)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT `fk_order_jewelry_order` FOREIGN KEY (`order_id`)
        REFERENCES `order` (`order_id`)
        ON UPDATE CASCADE
        ON DELETE CASCADE
)  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8MB3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- -----------------------------------------------------
-- Data inserts
-- -----------------------------------------------------

-- -----------------------------------------------------
-- material
-- -----------------------------------------------------
INSERT INTO `material` (`material_id`, `type_material`) VALUES (1, 'срібло');
INSERT INTO `material` (`material_id`, `type_material`) VALUES (2, 'золото');

-- -----------------------------------------------------
-- type_jewelry
-- -----------------------------------------------------
INSERT INTO `type_jewelry` (`type_jew_id`, `type_jew`) VALUES (1, 'каблучки');
INSERT INTO `type_jewelry` (`type_jew_id`, `type_jew`) VALUES (2, 'сережки');
INSERT INTO `type_jewelry` (`type_jew_id`, `type_jew`) VALUES (3, 'браслети');
INSERT INTO `type_jewelry` (`type_jew_id`, `type_jew`) VALUES (4, 'підвіски');

-- -----------------------------------------------------
-- jewelry
-- -----------------------------------------------------
#каблучки
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (1, 1, 1, 654.88, 15);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (2, 1, 1, 520.00, 10);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (3, 1, 1, 323.66, 8);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (4, 1, 1, 756.00, 3);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (5, 1, 2, 3455.30, 0);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (6, 1, 2, 2339.02, 22);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (7, 1, 2, 3151.33, 16);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (8, 1, 2, 5259.60, 4);

#сережки
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (9, 2, 1, 325.01, 14);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (10, 2, 1, 360.23, 65);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (11, 2, 1, 254.36, 25);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (12, 2, 1, 950.00, 15);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (13, 2, 2, 75420.36, 45);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (14, 2, 2, 6598.69, 28);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (15, 2, 2, 54620.02, 26);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (16, 2, 2, 1425.26, 8);

#браслети
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (17, 3, 1, 654.23, 5);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (18, 3, 1, 365.00, 1);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (19, 3, 1, 987.25, 8);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (20, 3, 1, 1230.00, 31);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (21, 3, 2, 2541.00, 20);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (22, 3, 2, 2365.72, 12);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (23, 3, 2, 3125.43, 6);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (24, 3, 2, 5230.90, 25);

#підвіски
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (25, 4, 1, 254.02, 75);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (26, 4, 1, 360.00, 20);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (27, 4, 1, 523.66, 18);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (28, 4, 1, 258.00, 33);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (29, 4, 2, 2465.70, 14);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (30, 4, 2, 3349.62, 2);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (31, 4, 2, 1181.23, 6);
INSERT INTO `jewelry` (`jewelry_id`, `type_jew_id`, `material_id`, `price`, `available_count`) VALUES (32, 4, 2, 2249.60, 34);

-- -----------------------------------------------------
-- role
-- -----------------------------------------------------
INSERT INTO `role` (`role_id`, `name`) VALUES (1, 'адміністор');
INSERT INTO `role` (`role_id`, `name`) VALUES (2, 'клієнт');

-- -----------------------------------------------------
-- user
-- -----------------------------------------------------
INSERT INTO `user` (`user_id`, `name`, `login`, `password`, `role_id`) VALUES (1, 'Адміністратор', 'admin', 'admin', 1);
INSERT INTO `user` (`user_id`, `name`, `login`, `password`, `role_id`) VALUES (2, 'Сергій', 'pers2', 'pers2', 2);
INSERT INTO `user` (`user_id`, `name`, `login`, `password`, `role_id`) VALUES (3, 'Марина', 'pers3', 'pers3', 2);
INSERT INTO `user` (`user_id`, `name`, `login`, `password`, `role_id`) VALUES (4, 'Крило', 'pers4', 'pers4', 2);
INSERT INTO `user` (`user_id`, `name`, `login`, `password`, `role_id`) VALUES (5, 'Данило', 'pers5', 'pers5', 2);
INSERT INTO `user` (`user_id`, `name`, `login`, `password`, `role_id`) VALUES (6, 'Михайло', 'pers6', 'pers6', 2);
INSERT INTO `user` (`user_id`, `name`, `login`, `password`, `role_id`) VALUES (7, 'Олег', 'pers7', 'pers7', 2);
INSERT INTO `user` (`user_id`, `name`, `login`, `password`, `role_id`) VALUES (8, 'Олена', 'pers8', 'pers8', 2);
INSERT INTO `user` (`user_id`, `name`, `login`, `password`, `role_id`) VALUES (9, 'Оксана', 'pers9', 'pers9', 2);
INSERT INTO `user` (`user_id`, `name`, `login`, `password`, `role_id`) VALUES (10, 'Андрій', 'pers10', 'pers10', 2);
INSERT INTO `user` (`user_id`, `name`, `login`, `password`, `role_id`) VALUES (11, 'Віталій', 'pers11', 'pers11', 2);

-- -----------------------------------------------------
-- order_status
-- -----------------------------------------------------
INSERT INTO `order_status` (`status_id`, `name`) VALUES (1, 'нове');
INSERT INTO `order_status` (`status_id`, `name`) VALUES (2, 'підтверджене');
INSERT INTO `order_status` (`status_id`, `name`) VALUES (3, 'виконане');
INSERT INTO `order_status` (`status_id`, `name`) VALUES (4, 'скасоване');

-- -----------------------------------------------------
-- order
-- -----------------------------------------------------
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (1, 2, 2, 1040.00, '2023-05-16 09:05:00', '2023-05-18 12:04:00');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (2, 2, 2, 756.00, '2023-05-14 10:32:00', '2023-05-18 13:30:40');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (3, 3, 3, 365.00, '2022-03-18 11:45:36', '2022-05-18 14:45:00');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (4, 3, 3, 2541.00, '2023-04-18 13:15:00', '2023-04-23 16:15:00');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (5, 3, 4, 3125.43, '2022-03-10 14:30:00', '2022-03-14 17:30:54');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (6, 4, 1, 1032.00, '2023-04-19 15:45:15', '2023-04-22 15:45:00');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (7, 4, 3, 1181.23, '2022-11-07 17:50:00', '2022-11-18 20:03:00');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (8, 5, 3, 5230.90, '2022-12-28 18:15:02', '2022-12-30 21:15:00');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (9, 5, 4, 75420.36, '2022-10-14 19:30:40', '2022-10-19 22:30:27');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (10, 5, 3, 763.08, '2023-02-11 20:45:19', '2023-02-15 10:45:00');

INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (11, 6, 3, 762.06, '2022-07-23 09:07:00', '2022-07-25 12:12:00');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (12, 6, 2, 4936.25, '2023-02-18 10:30:50', '2023-02-23 13:30:20');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (13, 7, 1, 3151.33, '2023-05-18 14:45:40', '2023-05-12 14:45:30');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (14, 8, 3, 75420.36, '2023-04-18 13:15:30', '2023-04-24 16:15:40');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (15, 8, 4, 3349.62, '2022-06-16 14:30:20', '2022-06-19 17:30:50');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (16, 9, 3, 4499.20, '2022-05-19 15:45:00', '2023-05-18 18:45:58');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (17, 9, 1, 7623.00, '2023-05-20 17:08:00', '2023-05-23 17:00:51');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (18, 9, 3, 54620.02, '2022-06-19 18:15:00', '2022-06-24 21:15:00');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (19, 9, 3, 6598.69, '2023-03-08 19:30:00', '2023-03-13 22:30:28');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (20, 9, 3, 1425.26, '2023-04-04 20:45:00', '2023-04-09 10:45:13');
 
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (21, 9, 4, 62643.97, '2023-01-18 09:48:10', '2023-01-28 12:46:15');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (22, 10, 1, 6684.86, '2023-05-20 13:30:04', '2023-05-23 13:30:00');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (23, 10, 3, 4349.93, '2023-03-18 11:45:30', '2023-03-24 14:45:17');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (24, 11, 3, 2365.72, '2023-04-26 13:15:30', '2023-05-01 16:15:00');
INSERT INTO `order` (`order_id`, `user_id`, `status_id`, `total_price`, `create_date`, `end_date`) VALUES (25, 11, 4, 320.00, '2023-01-14 14:30:06', '2023-01-19 17:30:28');

-- -----------------------------------------------------
-- order_jewelry
-- -----------------------------------------------------
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (1, 2, 2, 520.00);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (2, 4, 1, 756.00);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (3, 18, 1, 365.00);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (4, 21, 1, 2541.00);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (5, 23, 1, 3125.43);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (6, 28, 4, 258.00);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (7, 31, 1, 1181.23);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (8, 24, 1, 5230.90);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (9, 13, 1, 75420.36);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (10, 11, 3, 254.36);

INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (11, 25, 3, 254.02);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (12, 19, 5, 987.25);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (13, 7, 1, 3151.33);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (14, 13, 1, 75420.36);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (15, 30, 1, 3349.62);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (16, 32, 2, 2249.60);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (17, 21, 3, 2541.00);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (18, 15, 1, 54620.02);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (19, 14, 1, 6598.69);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (20, 16, 1, 1425.26);

INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (21, 16, 1, 1425.26);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (21, 14, 1, 6598.69);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (21, 15, 1, 54620.02);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (22, 8, 1, 5259.60);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (22, 16, 1, 1425.26);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (23, 17, 1, 654.23);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (23, 29, 1, 2465.70);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (23, 20, 1, 1230.00);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (24, 22, 1, 2365.72);
INSERT INTO `order_jewelry` (`order_id`, `jewelry_id`, `count`, `price`) VALUES (25, 26, 1, 360.00);
