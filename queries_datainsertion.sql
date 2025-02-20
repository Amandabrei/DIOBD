-- inserir valores ao BD ecoommerce
-- e criando umas query
use ecoommerce;

show tables;

insert into clients (Fname, Minit, Lname, CPF, Address) values
	('Maria', 'M', 'Silva', 123456789, 'Rua Silva da prata 29, Carangola - Cidade das Flores'),
    ('Matheus', 'O', 'Pimentel', 987654321, 'Rua Alamea 289, Centro - Cidade das Flores'),
    ('Ricardo', 'F', 'Silva', 45678913, 'Avenida Alamead Vinha 1009, Centro - Cidade das Flores'),
    ('Julia', 'S', 'Franca', 789123456, 'Rua Laranjeiras 861, Centro - Cidade das Flores'),
    ('Roberta', 'G', 'Assis', 654789123, 'Rua Alamena das Flores 28, Centro - Cidade das Flores');
    
select * from clients;

-- idProduct, Pname, classification_kids boolean, category ('Eletronico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') avaliacao, size
insert into product  (Pname, classification_kids, category, avaliacao, size) values
	('Fone de ouvido', false, 'EletrOnico', '4', null),
    ('Barbie Elsa', true, 'Brinquedos', '3', null),
    ('Body Carters', true, 'Vestimenta', '5', null),
    ('Microfone Vedo', false, 'Móveis', '3', null),
    ('Sofá retrátil', false, 'Móveis', '3', '3X57X80'),
    ('farinha de arroz', false, 'Alimentos', '2', null),
    ('Fire Stick Amazon', false, 'Eletrônico', '3', null);
    
select * from product;

delete from orders where idOrderClient in (1,2,3,4);
insert into orders (idOrderClient, OrderStatus, orderDescription, sendValue, paymentCash) values
	(1, default, 'compra via aplicativo', null, 1),
    (2, default, 'compra via aplicativo', 50, 0),
    (3, 'Confirmado', null, null, 1),
    (4, default, 'compra via web site', 150, 0);
    
select * from orders;

insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
	(1,5,2,null),
    (2,5,1,null),
    (3,6,1,null);
    

-- storageLocation, quantity
insert into productStorage (storagelocation, quantidy) values
	('Rio de Janeiro', 1000),
    ('Rio de Janeiro', 500),
    ('São Paulo', 10),
    ('São Paulo', 100),
    ('São Paulo', 10),
    ('Brasília', 60);
    
insert into storageLocation (idLproduct, idLstorage, location) values
	(1,2,'RJ'),
    (2,6,'GO');

select * from storageLocation;

insert into supplier (SocialName, CNPJ, contact) values
	('Almeida e Filhos', 123456789123456, '21985475'),
    ('Eletrônicos Silva', 854519649143457, '21985484'),
    ('Eletrônicos Valma', 987654321345476, '21975474');

insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
	(1,1,500),
    (1,2,400),
    (2,4,633),
    (3,3,5),
    (2,5,10);
    
insert into seller (SocialName, AbstName, CNPJ, CPF, locations, contact) values
	('Tech Eletronics', null, 123456789456321, null, 'Rio de Janeiro', 219946287),
    ('Botique Durgas', null, null, 123456783, 'Rio de Janeiro', 219567895),
    ('Kids Worl', null, 45678912345585, null, 'São Paulo', 1198657484);

select * from seller;

-- idPseller, idPproduct, prodQuantidy
insert into productSeller (idPseller, idPproduct, prodQuantidy) values
	(1,6,80),
    (2,7,10);
    
select * from productSeller;

select count(*) from clients;

select * from clients c, orders o where c.idClient = idOrderClient;

select concat(Fname,' ', Lname) as Client, idOrder as Request, orderStatus as Status from clients c, orders o where c.idClient = idOrderClient;

insert into orders (idOrderClient, OrderStatus, orderDescription, sendValue, paymentCash) values
	(2, default, 'compra via aplicativo', null, 1);

select count(*) from  clients c, orders o
	where c.idClient = idOrderClient;
    
select * from product;

-- recuperar quantos pedidos foram realizados pelos clientes
select c.idClient, Fname, count(*) as Number_of_orders from clients c
	inner join orders o ON c.idClient = o.idOrderClient
	group by idClient;

-- recupererar pedido com produto associado
select * from clients c
	inner join orders o ON c.idClient = o.idOrderClient
    inner join productOrder p on p.idPOorder = o.idOrder
    group by idClient;
    
-- Quantos pedidos foram feitos por cada cliente?
SELECT c.idClient, c.Fname, c.LName, COUNT(o.idOrder) AS TotalPedidos
FROM clients c
LEFT JOIN orders o ON c.idClient = o.idOrderClient
GROUP BY c.idClient, c.Fname, c.LName
ORDER BY TotalPedidos DESC;

-- Algum vendedor também é fornecedor? no caso nenhum
SELECT s.idSeller, s.SocialName AS NomeVendedor, sup.idSupplier, sup.SocialName AS NomeFornecedor
FROM seller s
INNER JOIN supplier sup ON s.CNPJ = sup.CNPJ;

-- Relação de produtos, fornecedores e estoques
SELECT 
    p.idProduct, 
    p.Pname AS NomeProduto, 
    sup.SocialName AS NomeFornecedor, 
    ps.quantity AS QuantidadeFornecida, 
    st.storageLocation AS LocalEstoque, 
    st.quantidy AS QuantidadeEmEstoque
FROM product p
JOIN productSupplier ps ON p.idProduct = ps.idPsProduct
JOIN supplier sup ON ps.idPsSupplier = sup.idSupplier
LEFT JOIN storageLocation st ON p.idProduct = st.idLproduct;

-- Relação dos nomes dos fornecedores e produtos fornecidos
SELECT DISTINCT sup.SocialName AS NomeFornecedor, p.Pname AS NomeProduto
FROM supplier sup
JOIN productSupplier ps ON sup.idSupplier = ps.idPsSupplier
JOIN product p ON ps.idPsProduct = p.idProduct
ORDER BY sup.SocialName;

-- Filtrar clientes com mais de 3 pedidos (HAVING) - no caso nenhum
SELECT o.idOrderClient, c.Fname, c.LName, COUNT(o.idOrder) AS TotalPedidos
FROM orders o
JOIN clients c ON o.idOrderClient = c.idClient
GROUP BY o.idOrderClient, c.Fname, c.LName
HAVING COUNT(o.idOrder) > 3;

-- Produtos mais vendidos (com atributo derivado - total faturado)
SELECT p.idProduct, p.Pname, SUM(po.poQuantity) AS QuantidadeVendida,
       (SUM(po.poQuantity) * 100) AS TotalFaturado -- Supondo que cada produto custa 100
FROM product p
JOIN productOrder po ON p.idProduct = po.idPOproduct
GROUP BY p.idProduct, p.Pname
ORDER BY TotalFaturado DESC;


-- Modificações:
-- - linha 21: um alter na tabela clients add PF e PJ;
-- - linha 67: um alter na tabela orders, com status do envio;