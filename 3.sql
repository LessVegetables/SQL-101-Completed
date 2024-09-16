-- 3.1. Get all the unique wares in the alphabetic order with
-- the minimal and maximal prices for each.
SELECT WARE, MIN(PRICE) AS MIN_PRICE, MAX(PRICE) AS MAX_PRICE
FROM PRODUCT
GROUP BY WARE
ORDER BY WARE;

-- 3.2 Show top 3 wares with the most difference between
-- minimal and maximal prices.
SELECT WARE, (MAX(PRICE) - MIN(PRICE)) AS PRICE_DIFFERENCE
FROM PRODUCT
GROUP BY WARE
ORDER BY PRICE_DIFFERENCE DESC
LIMIT 3;

-- 3.3. Show top 3 companies producing the largest number
-- of different products.
SELECT MANUFACTURER.COMPANY, COUNT(DISTINCT PRODUCT.WARE) AS NUM_PRODUCTS
FROM MANUFACTURER
JOIN PRODUCT ON MANUFACTURER.BILL_ID = PRODUCT.BILL_ID
GROUP BY MANUFACTURER.COMPANY
ORDER BY NUM_PRODUCTS DESC
LIMIT 3;

-- 3.4. Show the price of the most expensive ware for
-- each category. The result should be ordered by the category.
SELECT CATEGORY.CLASS, PRODUCT.WARE, MAX(PRODUCT.PRICE) AS MAX_PRICE
FROM PRODUCT
JOIN CATEGORY ON PRODUCT.WARE = CATEGORY.WARE
GROUP BY CATEGORY.CLASS
ORDER BY CATEGORY.CLASS;

-- 3.5. For each bill of materials show the company and
-- lists of all the products and materials. The result
-- must contain exactly one row per bill and sorted by
-- company. Lists in the result must be represented as
-- strings with values separated with comma.
SELECT MANUFACTURER.COMPANY, MANUFACTURER.BILL_ID,
       GROUP_CONCAT(DISTINCT MATERIAL.WARE) AS MATERIALS,
       GROUP_CONCAT(DISTINCT PRODUCT.WARE) AS PRODUCTS
FROM MANUFACTURER
LEFT JOIN MATERIAL ON MANUFACTURER.BILL_ID = MATERIAL.BILL_ID
LEFT JOIN PRODUCT ON MANUFACTURER.BILL_ID = PRODUCT.BILL_ID
GROUP BY MANUFACTURER.BILL_ID, MANUFACTURER.COMPANY
ORDER BY MANUFACTURER.COMPANY;


-- 3.6. Show the companies in the alphabetical order that
-- producing larger number of different wares than consuming.
-- SELECT COMPANY
-- FROM MANUFACTURER
-- HAVING 

-- SELECT m.COMPANY, COUNT(*)
-- FROM MANUFACTURER m
-- JOIN MATERIAL ON m.BILL_ID = MATERIAL.BILL_ID
-- GROUP BY m.COMPANY;
-- SELECT WARE, AVG(PRICE) AS AVG_PRICE
-- FROM PRODUCT
-- GROUP BY WARE
-- ORDER BY AVG_PRICE DESC LIMIT 1;

-- SELECT m.COMPANY, m.BILL_ID, MATERIAL.WARE
-- FROM MANUFACTURER m
-- JOIN MATERIAL ON m.BILL_ID = MATERIAL.BILL_ID
-- 
-- SELECT m.COMPANY, SUM(COUNT(*))
-- FROM MANUFACTURER m
-- JOIN MATERIAL ON m.BILL_ID = MATERIAL.BILL_ID
-- GROUP BY m.COMPANY;




-- 3.7. Show all the companies that produce the same
-- ware by more than 2 different ways (bills of materials).
SELECT m.COMPANY, p.WARE, COUNT(DISTINCT p.BILL_ID) AS BILL_COUNT
FROM MANUFACTURER m
JOIN PRODUCT p ON m.BILL_ID = p.BILL_ID
GROUP BY m.COMPANY, p.WARE
HAVING BILL_COUNT > 2;


-- 3.8. Get all the unique companies producing at least one
-- ware from each category in the set: Fuel, Food and Mineral.
-- The query should be easily modifiable to use any set of categories.
SELECT COMPANY
FROM MANUFACTURER m
JOIN PRODUCT p ON m.BILL_ID = p.BILL_ID
JOIN CATEGORY c ON p.WARE = c.WARE
WHERE c.CLASS IN ('Fuel', 'Food', 'Mineral')
GROUP BY COMPANY
HAVING COUNT(DISTINCT c.CLASS) = 3;


-- @block
-- 3.9. For each company get the list of all the categories of
-- materials used and the list of categories of products. The
-- result must contain exactly one row per company and each list
-- must contain only the unique entries.
SELECT  m.COMPANY,
        GROUP_CONCAT(DISTINCT mc.CLASS) AS MATERIAL_CATEGORIES,
        GROUP_CONCAT(DISTINCT pc.CLASS) AS PRODUCT_CATEGORIES
FROM MANUFACTURER m
LEFT JOIN MATERIAL mat ON m.BILL_ID = mat.BILL_ID
LEFT JOIN PRODUCT prod ON m.BILL_ID = prod.BILL_ID
LEFT JOIN CATEGORY mc ON mat.WARE = mc.WARE
LEFT JOIN CATEGORY pc ON prod.WARE = pc.WARE
GROUP BY m.COMPANY;


-- 3.10. For each company show all the production chains
-- (separate row per company/chain). Here the production chain is
-- defined as the intermediate product (ware) that both product for
-- the one bill and material for other where both bills are owned by
-- the same company. Each chain must be presented in the following
-- form (MATERIAL1,MATERIAL2,…)-[BILL_ID1]->(INTERMEDIATE_PRODUCT)-[BILL_ID2]-
-- >(PRODUCT1, PRODUCT2,…). The result must be sorted by the company.

SELECT COMPANY
ORD BY COMPANY ASC;