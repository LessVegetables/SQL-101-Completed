-- 4. Subqueries

-- 4.1 Show the product with the largest average price over the market.
SELECT WARE, AVG(PRICE) AS AVG_PRICE
FROM PRODUCT
GROUP BY WARE
ORDER BY AVG_PRICE DESC; -- LIMIT 1;

-- SELECT WARE, PR
-- FROM PRODUCT
-- WHERE PRODUCT.WARE = (
--     SELECT WARE FROM (
--         SELECT WARE, AVG(PRICE) AS PR
--         FROM PRODUCT 
--         GROUP BY WARE
--         ORDER BY PR DESC LIMIT 1
--         )
-- );


-- 4.2. Show one sample ware from each category.
-- what? Просто вернуть любой рандомный ware из product и все?
SELECT CLASS, (SELECT WARE FROM CATEGORY WHERE CATEGORY.CLASS = C.CLASS LIMIT 1)
FROM CATEGORY C;


-- 4.3. Show the most expensive ware in each category and its price
SELECT WARE, MAX(PRICE)
FROM PRODUCT
GROUP BY WARE;

-- 4.4. Show the list of all the “greedy” companies, i.e. companies selling all the wares they are producing with
-- the prices at least 20% higher than average price for this product on the market.
SELECT m.COMPANY
FROM MANUFACTURER m 
JOIN PRODUCT p ON p.BILL_ID = m.BILL_ID
WHERE p.PRICE > 1.2 *
(
    SELECT AVG(PRODUCT.PRICE)
    FROM PRODUCT
    GROUP BY PRODUCT.WARE
)
GROUP BY m.COMPANY;


-- 4.5. Show the companies that produce all the wares from any category. Result should contain the company
-- and the category and be sorted by the category. If the company covers multiple categories in such way,
-- there should be multiple rows for this company. To prove that the result is correct enrich it with the
-- additional column showing all the wares in the given category that the given company is actually producing.
SELECT m.COMPANY, c.CLASS, GROUP_CONCAT(DISTINCT p.WARE)
FROM MANUFACTURER m
JOIN PRODUCT p ON m.BILL_ID = p.BILL_ID
JOIN CATEGORY c ON p.WARE = c.WARE
GROUP BY m.COMPANY, c.CLASS
HAVING COUNT(DISTINCT p.WARE) = (
                                    SELECT COUNT(*)
                                    FROM CATEGORY c2
                                    WHERE c2.CLASS = c.CLASS
                                )
ORDER BY c.CLASS, m.COMPANY ASC;


-- 4.6. For each bill of material show the company, all the materials, products, total price of all the products
-- considering their amounts. There must be exactly one row per bill and the result must be ordered by company.
SELECT  m.BILL_ID, m.COMPANY,
        GROUP_CONCAT(DISTINCT mat.WARE),
        GROUP_CONCAT(DISTINCT p.WARE),
        SUM(p.PRICE * p.AMOUNT)
FROM MANUFACTURER m
JOIN MATERIAL mat ON m.BILL_ID = mat.BILL_ID
JOIN PRODUCT p ON m.BILL_ID = p.BILL_ID
GROUP BY m.BILL_ID
ORDER BY m.COMPANY ASC;


-- 4.7. For each product show
-- - all the unique sets of materials used in different variants of bills of materials
-- - all the possible byproducts (i.e. additional products in the same bill of materials)
-- There must be exactly one row per ware.
SELECT p.WARE, 
       GROUP_CONCAT(DISTINCT mat.WARE) AS UNIQUE_MATERIALS,
       GROUP_CONCAT(DISTINCT byp.WARE) AS POSSIBLE_BYPRODUCTS
FROM PRODUCT p
JOIN MATERIAL mat ON p.BILL_ID = mat.BILL_ID                           -- getting materials
LEFT JOIN PRODUCT byp ON p.BILL_ID = byp.BILL_ID AND p.WARE <> byp.WARE     -- getting the byproducts, (excluding the original ware itself)
GROUP BY p.WARE;



-- 4.8. Show all the companies with the largest number of different wares they produce
-- and their lists of wares in alphabetical order.
SELECT COMPANY, GROUP_CONCAT(DISTINCT WARE)
FROM (
    SELECT m.COMPANY, p.WARE
    FROM MANUFACTURER m
    JOIN PRODUCT p ON m.BILL_ID = p.BILL_ID
    GROUP BY m.COMPANY, p.WARE
) comp                              -- this subq provides us a list of all the wares a given company produces
GROUP BY COMPANY
HAVING COUNT(DISTINCT WARE) = (     -- if the count of distinct wares of the given("current") company does not match with the...
                                SELECT COUNT(DISTINCT WARE)     
                                FROM MANUFACTURER m2
                                JOIN PRODUCT p2 ON m2.BILL_ID = p2.BILL_ID
                                GROUP BY m2.COMPANY
                                ORDER BY COUNT(DISTINCT p2.WARE) DESC
                                LIMIT 1
                            );       -- ... the maximum count — then we don't "include" it
-- in the second subq we essantially create a list of all the distinct companies with 
-- their count of distinct wares (then to get the max we order by DESC and just get the top one)