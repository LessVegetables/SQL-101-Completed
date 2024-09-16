-- Chapter 2: Join
-- 2.1. Get all the unique companies producing Drinking water in alphabetic order.
SELECT DISTINCT MANUFACTURER.COMPANY AS COMPANY
FROM PRODUCT
JOIN PRODUCT ON MANUFACTURER.BILL_ID=PRODUCT.BILL_ID
WHERE PRODUCT.WARE = "Drinking water"
ORDER BY COMPANY ASC;


-- 2.2. Get all the companies producing wares in Raw food category. Result must contain unique pairs of
-- companies and wares producing by them from the given category and must be sorted by the ware first and
-- the company name next.
SELECT DISTINCT MATERIAL.WARE, MANUFACTURER.COMPANY
FROM MATERIAL
JOIN MANUFACTURER ON MATERIAL.BILL_ID = MANUFACTURER.BILL_ID
JOIN CATEGORY ON MATERIAL.WARE = CATEGORY.WARE
WHERE CATEGORY.CLASS = "Raw Food"
ORDER BY MATERIAL.WARE ASC, MANUFACTURER.COMPANY ASC;


-- 2.3. Get all the unique wares in alphabetical order that can be produced from wares in Mineral category.
---- 1. get WARE of CLASS "Mineral"
---- 2. get BILL_ID from MATERIALS.WARE with WARE of CLASS "Mineral"
---- 3. get PRODUCT.WARE with BILL_ID as the MATERIALS.WARE with WARE of CLASS "Mineral"
SELECT DISTINCT PRODUCT.WARE AS WARE
FROM CATEGORY, MATERIAL, PRODUCT
WHERE CATEGORY.CLASS LIKE "Mineral" AND CATEGORY.WARE=MATERIAL.WARE AND MATERIAL.BILL_ID=PRODUCT.BILL_ID
ORDER BY WARE ASC;


-- 2.4. Get all the unique companies producing both wares from Fuel and Food categories. Use appropriate set operation in the query.
-- 1. get the CAT.WARE with Fuel and Food CLASS
-- 2. cross reference CAT.WARE with PRODUCT.WARE -> get PRODUCT.BILL_ID
-- 3. cross reference PRODUCT.BILL_ID with MANUFACTURER.BILL_ID -> get MANUFACTURER.COMPANY
SELECT DISTINCT MANUFACTURER.COMPANY AS COMPANY
FROM CATEGORY, PRODUCT, MANUFACTURER
WHERE CATEGORY.CLASS LIKE "Fuel" AND CATEGORY.WARE=PRODUCT.WARE AND PRODUCT.BILL_ID=MANUFACTURER.BILL_ID
UNION
SELECT DISTINCT MANUFACTURER.COMPANY AS COMPANY
FROM CATEGORY, PRODUCT, MANUFACTURER
WHERE CATEGORY.CLASS LIKE "Food" AND CATEGORY.WARE=PRODUCT.WARE AND PRODUCT.BILL_ID=MANUFACTURER.BILL_ID
ORDER BY COMPANY ASC;


-- 2.5. Rewrite the previous query without using the set operations. Enrich the result with wares from both
-- categories. It is acceptable to get multiple rows for companies producing multiple wares from any category
-- mentioned, but the rows must be unique in result.
-- SELECT DISTINCT CATEGORY.CLASS AS CLASS,
--                 CATEGORY.WARE AS WARE,
--                 MANUFACTURER.COMPANY AS COMPANY
-- FROM MANUFACTURER, CATEGORY
-- WHERE MANUFACTURER.BILL_ID IN ()
--    OR MANUFACTURER.BILL_ID IN ()
-- ORDER BY CLASS ASC, WARE ASC, COMPANY ASC;
SELECT DISTINCT MANUFACTURER.COMPANY AS COMPANY
FROM CATEGORY, PRODUCT, MANUFACTURER
WHERE CATEGORY.CLASS LIKE "Fuel" AND CATEGORY.WARE=PRODUCT.WARE AND PRODUCT.BILL_ID=MANUFACTURER.BILL_ID
   OR CATEGORY.CLASS LIKE "Food" AND CATEGORY.WARE=PRODUCT.WARE AND PRODUCT.BILL_ID=MANUFACTURER.BILL_ID
ORDER BY COMPANY ASC;


-- 2.6. Get all the companies in alphabetical order that produce at least 2 different wares from the same
-- class.
SELECT DISTINCT MANUFACTURER.COMPANY
FROM MANUFACTURER
JOIN MATERIAL ON MANUFACTURER.BILL_ID = MATERIAL.BILL_ID
JOIN CATEGORY ON MATERIAL.WARE = CATEGORY.WARE
-- GROUP BY MANUFACTURER.COMPANY, CATEGORY.CLASS
HAVING COUNT(CATEGORY.CLASS) >= 2
ORDER BY MANUFACTURER.COMPANY ASC;


-- 2.7. Get all the unique wares in alphabetical order that can be produced using nothing besides wares in
-- Mineral category.
SELECT DISTINCT PRODUCT.WARE
FROM PRODUCT
JOIN CATEGORY ON MATERIAL.WARE = CATEGORY.WARE
JOIN MATERIAL ON PRODUCT.BILL_ID = MATERIAL.BILL_ID
WHERE CATEGORY.CLASS = "Mineral"
ORDER BY PRODUCT.WARE ASC;


-- SELECT DISTINCT WARE
-- FROM PRODUCT
-- WHERE BILL_ID IN (
--         SELECT BILL_ID FROM MATERIAL
--         EXCEPT
--         SELECT BILL_ID
--         FROM MATERIAL
--         WHERE WARE NOT IN (SELECT WARE FROM CATEGORY WHERE CLASS LIKE "Mineral")
-- )
-- ORDER BY WARE ASC;


-- 2.8. Get all the unique companies in alphabetical order implementing production chains. The production
-- chain is at least two subsequent bills of materials when the first bill producing ware that is in use as material
-- in the second bill. Example of such chain in terms of wares is Grain->Meat cow->Meat.
SELECT DISTINCT COMPANY
FROM MANUFACTURER
WHERE BILL_ID IN
(
    SELECT BILL_ID
    FROM PRODUCT
    WHERE BILL_ID IN
    (
        SELECT BILL_ID
        FROM MATERIAL
        WHERE WARE IN
        (
            SELECT WARE
            FROM PRODUCT
        )
    )
)
-- помоему это не совсем правильно. Надо будет взглянуть ещё раз.
ORDER BY COMPANY ASC;


-- MINE
SELECT DISTINCT MANUFACTURER.COMPANY
FROM MANUFACTURER
JOIN PRODUCT P1 ON MANUFACTURER.BILL_ID = P1.BILL_ID
JOIN MATERIAL ON PRODUCT.BILL_ID = MATERIAL.BILL_ID
JOIN PRODUCT P2 ON MATERIAL.WARE = P2.WARE
ORDER BY MANUFACTURER.COMPANY ASC;

-- sqlite> SELECT DISTINCT MANUFACTURER.COMPANY
--    ...> FROM MANUFACTURER
--    ...> JOIN PRODUCT P1 ON MANUFACTURER.BILL_ID = P1.BILL_ID
--    ...> JOIN MATERIAL ON PRODUCT.BILL_ID = MATERIAL.BILL_ID
--    ...> JOIN PRODUCT P2 ON MATERIAL.WARE = P2.WARE
--    ...> ORDER BY MANUFACTURER.COMPANY ASC;
-- Parse error: no such column: PRODUCT.BILL_ID
--                                            
--  WTF DO YOU MEAN THERE'S NO COLUMN PRODUCT

-- FUCKING GOOGLE GEMINIES. WHY DOES THIS WORK AND MINE DOESN'T
SELECT DISTINCT F1.COMPANY AS StartCompany
FROM MANUFACTURER F1
JOIN MATERIAL M1 ON F1.BILL_ID = M1.BILL_ID
JOIN MANUFACTURER F2 ON M1.WARE = M2.WARE -- Alias for M1.WARE for readability
JOIN MATERIAL M2 ON F2.BILL_ID = M2.BILL_ID
WHERE F1.COMPANY <> F2.COMPANY;     -- so apperanly <> checks if the values are equal, and returns 1 if not equal (so !=)


-- 2.9. Modify the query from the previous task to show also the production chain in terms of wares (3 of
-- them) with additional sorting by middle one (that both a material and a product for the given company).

-- add GROUP BY M1, P1, M2
-- and ORDER BY Company ASC, M1, P1 ASC, M2;

-- SELECT DISTINCT MANUFACTURER.COMPANY AS COMPANY,
--                 PRODUCT.WARE AS PW,
--                 MATERIAL.WARE AS MW,
--                 MATERIAL.WARE AS MW2
-- FROM MANUFACTURER, PRODUCT, MATERIAL
-- WHERE BILL_ID, PR, MW, MW2 IN
-- (
--     SELECT BILL_ID, PR, MW, MW2
--     FROM PRODUCT
--     WHERE BILL_ID IN
--     (
--         SELECT BILL_ID
--         FROM MATERIAL
--         WHERE WARE IN
--         (
--             SELECT WARE
--             FROM PRODUCT
--         )
--     )
-- )
-- ORDER BY COMPANY ASC, PW ASC, MW ASC;