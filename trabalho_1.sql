DROP TABLE IF EXISTS PRODUCT_MODEL, ITEM, CLIENT, EVALUATION, SALE, CATEGORY;

CREATE TABLE PRODUCT_MODEL(
    Id INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL UNIQUE,
    Description TEXT
);

CREATE TABLE ITEM(
    Series_number INT PRIMARY KEY,
    Value INT NOT NULL CHECK (Value > 0),
    Id_model INT NOT NULL,
    FOREIGN KEY (Id_model) REFERENCES PRODUCT_MODEL (Id)
);

CREATE TABLE CLIENT(
    CPF CHAR(14) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Birth_date DATE,
    Gender CHAR(1)
);

CREATE TABLE EVALUATION(
    CPF_client CHAR(14),
    Series_number_item INT,
    Classification CHAR(1) NOT NULL,
    PRIMARY KEY (CPF_client, Series_number_item),
    FOREIGN KEY (CPF_client) REFERENCES CLIENT (CPF),
    FOREIGN KEY (Series_number_item) REFERENCES ITEM (Series_number)
);

CREATE TABLE SALE(
    CPF_client CHAR(14),
    Series_number_item INT,
    Value_sale INT NOT NULL,
    Date DATE NOT NULL,
    Hour TIME NOT NULL,
    PRIMARY KEY (CPF_client, Series_number_item),
    FOREIGN KEY (CPF_client) REFERENCES CLIENT (CPF),
    FOREIGN KEY (Series_number_item) REFERENCES ITEM (Series_number)
);

-- MODELOS DE PRODUTO
INSERT INTO PRODUCT_MODEL (Id, Name, Description)
VALUES (1, 'Notebook X1', 'Notebook ultrafino com 16GB RAM e SSD 512GB'),
       (2, 'Smartphone Z5', 'Smartphone com câmera tripla e bateria de longa duração'),
       (3, 'Fone ProSound', 'Fone de ouvido sem fio com cancelamento de ruído ativo');

-- ITENS (10 unidades no total, espalhadas entre os modelos)
INSERT INTO ITEM (Series_number, Value, Id_model)
VALUES (1001, 4500, 1),
       (1002, 4600, 1),
       (1003, 4550, 1),
       (2001, 2500, 2),
       (2002, 2550, 2),
       (2003, 2480, 2),
       (2004, 2520, 2),
       (3001, 900, 3),
       (3002, 920, 3),
       (3003, 880, 3);

-- CLIENTES
INSERT INTO CLIENT (CPF, Name, Birth_date, Gender)
VALUES ('123.456.789-00', 'Ana Silva', '1990-05-12', 'F'),
       ('987.654.321-00', 'Carlos Souza', '1985-09-23', 'M'),
       ('111.222.333-44', 'Fernanda Lima', '1998-03-15', 'F'),
       ('555.666.777-88', 'João Pereira', '1979-12-30', 'M');

-- AVALIAÇÕES (nota de 0 a 5, apenas 1 por cliente/produto)
INSERT INTO EVALUATION (CPF_client, Series_number_item, Classification)
VALUES ('123.456.789-00', 1001, '5'),
       ('987.654.321-00', 2002, '4'),
       ('111.222.333-44', 3001, '3');

-- VENDAS (cliente compra item específico)
INSERT INTO SALE (CPF_client, Series_number_item, Value_sale, Date, Hour)
VALUES ('123.456.789-00', 1001, 4400, '2025-09-01', '10:30:00'),
       ('987.654.321-00', 2002, 2500, '2025-09-01', '14:15:00'),
       ('111.222.333-44', 3001, 890, '2025-09-02', '09:45:00'),
       ('555.666.777-88', 1003, 4500, '2025-09-03', '16:20:00'),
       ('123.456.789-00', 3002, 900, '2025-09-04', '11:10:00');


CREATE TABLE CATEGORY(
    Code CHAR(3) PRIMARY KEY,
    NameCategory VARCHAR(50) NOT NULL
);

INSERT INTO CATEGORY (Code, NameCategory)
VALUES ('CPM', 'Computador'),
       ('CEL', 'Celular');

ALTER TABLE PRODUCT_MODEL
    ADD Id_category CHAR(3) NOT NULL DEFAULT 'CPM',
    ADD FOREIGN KEY (Id_category) REFERENCES CATEGORY (Code);

SELECT pm.Name AS Modelo, c.Name AS Cliente, e.Classification AS Nota
FROM EVALUATION e
    JOIN CLIENT c ON e.CPF_client = c.CPF
    JOIN ITEM i ON e.Series_number_item = i.Series_number
    JOIN PRODUCT_MODEL pm ON i.Id_model = pm.Id
ORDER BY pm.Name, c.Name;
