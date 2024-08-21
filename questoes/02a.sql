-- Mostre o nome dos fornecedores que venderam mais de X reais no mês de fevereiro de 2024

-- Inserindo pedidos da Livraria Central e Editora ABC
INSERT INTO PEDIDO (COD_PEDIDO, COD_FORNECEDOR, DATA_PEDIDO, HORA_PEDIDO, VALOR_TOTAL_PEDIDO, QUANT_ITENS_PEDIDOS)
VALUES
(1004, 3, '2024-02-01', '09:14:00', 59.80, 2),
(1005, 1, '2024-02-01', '09:14:00', 29.90, 1);

INSERT INTO ITEM_PEDIDO (COD_LIVRO, COD_PEDIDO, QUANTIDADE_ITEM, VALOR_TOTAL_ITEM)
VALUES
-- Livraria Central Comprando um "O grande livro" e dois "Histórias Fantásticas no pedido 1004"
(101, 1004, 1, 29.90),
(102, 1004, 2, 49.80),
-- Editora ABC comprando "O grande livro no pedido 1005"
(101, 1005, 1, 29.90);


SELECT NOME_FORNECEDOR 
FROM FORNECEDOR F 
JOIN PEDIDO P ON F.COD_FORNECEDOR = P.COD_FORNECEDOR 
JOIN ITEM_PEDIDO I ON I.COD_PEDIDO = P.COD_PEDIDO
WHERE EXTRACT(MONTH FROM P.DATA_PEDIDO) = 2
AND EXTRACT(YEAR FROM P.DATA_PEDIDO) = 2024
GROUP BY F.COD_FORNECEDOR, F.nome_fornecedor HAVING SUM(I.VALOR_TOTAL_ITEM) > 0;


-- Fazendo uma função para isso:
CREATE OR REPLACE FUNCTION obter_nome_dos_fornecedores_que_venderam_mais_de_x_em_fevereiro(X numeric)
RETURNS SETOF VARCHAR AS $$
BEGIN 
  RETURN QUERY
  SELECT NOME_FORNECEDOR
  FROM FORNECEDOR F 
  JOIN PEDIDO P ON F.COD_FORNECEDOR = P.COD_FORNECEDOR 
  JOIN ITEM_PEDIDO I ON I.COD_PEDIDO = P.COD_PEDIDO
  WHERE EXTRACT(MONTH FROM P.DATA_PEDIDO) = 2
  AND EXTRACT(YEAR FROM P.DATA_PEDIDO) = 2024
  GROUP BY F.COD_FORNECEDOR, F.nome_fornecedor HAVING SUM(I.VALOR_TOTAL_ITEM) > X;
END;
$$ language plpgsql;

select * from obter_nome_dos_fornecedores_que_venderam_mais_de_x_em_fevereiro(10) mais_vendedores_em_fevereiro;




