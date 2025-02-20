-- criação do banco de dados parao cenário de E-commerce
-- drop database ecoommerce;

create database ecoommerce;
use ecoommerce;

-- criar tabela cliente
create table clients(
	idClient int auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    LName varchar(20),
    CPF char(11) not null,
    Address varchar(255),
    constraint unique_cpf_client unique (CPF)
);

alter table clients auto_increment = 1;

-- Alteração na tabela clients para diferenciar PF e PJ
ALTER TABLE clients 
ADD COLUMN ClientType ENUM('PF', 'PJ') NOT NULL,
ADD COLUMN CNPJ CHAR(14) UNIQUE NULL;

-- desc clients;
-- criar tabela produto
-- size equivale a dimensão do produto
create table product(
    idProduct int auto_increment primary key,
    Pname varchar(255) not null,
    Classification_kids bool default false,
    Category enum('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') not null,
    Avaliacao float default 0,
    Size varchar(10)
);
alter table product auto_increment = 1;

-- desc product;
-- para ser continuado no desafio termine de implementar a tabela e crie a conexão com as
-- tabelas necessárias e reflita essa modificação no diagrama ER
-- criar constraint para conexão 
create table payments(
	idClient int,
    idpayment int,
    typePayment enum('Boleto', 'Cartão', 'Dois cartões'),
    limitAvailable float,
    primary key (idClient, id_payment)
);

-- exclui a table orders para corrigir erros
-- criar tabela pedido
-- no send Value o valor mínimo para o frete é 10 reais
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    OrderStatus enum('Cancelado', 'Confirmado', 'Em processamento', 'Entregue') default 'Em Processamento',
    orderDescription varchar (255),
    sendValue float default 10,
    paymentCash boolean default false, 
    constraint fk_ordes_client foreign key (idorderClient) references clients (idClient)
		on update cascade
);
alter table orders auto_increment = 1;


-- Adicionei código de rastreamento e status na entrega
ALTER TABLE orders 
ADD COLUMN trackingCode VARCHAR(50) NULL,
ADD COLUMN deliveryStatus ENUM('Aguardando Envio', 'Em Transporte', 'Entregue') DEFAULT 'Aguardando Envio';

-- desc orders;

-- criar tabela estoque
create table productStorage(
    idProdStorage int auto_increment primary key,
    storageLocation varchar (255),
    quantidy int default 0
);

-- criar tabela fornecedor
create table supplier(
    idSupplier int auto_increment primary key,
    SocialName varchar (255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);
alter table supplier auto_increment = 1;
-- desc supplier;


-- criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
	CNPJ char(15),
    CPF char(9),
    locations varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);
alter table seller auto_increment = 1;
-- desc table seller;


-- criar tabela produto/vendedor
create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantidy int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);
-- desc productSeller;


-- criar tabela produto/pedido
create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum ('Disponível', 'Indisponível') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
);

drop table productOrder;

-- criar tabela produto/fornecedor
create table productSupplier(
    idPsSupplier int,
    idPsProduct int,
    quantity int not null,
	primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
);

-- criar tabela produto/estoque
create table storageLocation(
    idLproduct int,
    idLstorage int,
    location varchar(255) not null,
	primary key (idLproduct, idLstorage),
    constraint fk_storage_Location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_Location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

-- Criar uma nova tabela de pagamentos vinculada a clients
CREATE TABLE client_payments (
    idClientPayment INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    typePayment ENUM('Boleto', 'Cartão', 'Dois cartões'),
    limitAvailable FLOAT,
    FOREIGN KEY (idClient) REFERENCES clients(idClient) ON DELETE CASCADE
);

show tables;

show databases;
use information_schema;
show tables;
desc referential_constraints;

-- comando para recuperar e verificar as constraint de um certo BD no caso BD ecoommerce
select * from referential_constraints where constraint_schema = 'ecoommerce';


