-- 1.1. Get all the unique companies
SELECT DISTINCT COMPANY
FROM MANUFACTURER;

-- 1.2. Get the total number of companies
SELECT COUNT(COMPANY)
FROM MANUFACTURER;

-- 1.3. Get all the unique wares in Food category
SELECT DISTINCT WARE
FROM CATEGORY;

-- 1.4. Get a list of all unique companies which names begin with letter A or B, sorted in alphabetical order
SELECT DISTINCT COMPANY
FROM MANUFACTURER
WHERE COMPANY LIKE 'A%' OR COMPANY LIKE 'B%'
ORDER BY COMPANY ASC;

-- 1.5. Get all the unique final products (i.e. the wares that are not in use as a material anywhere)
SELECT DISTINCT WARE FROM CATEGORY
EXCEPT
SELECT DISTINCT WARE FROM MATERIAL;

-- 1.6. Get all the unique wares that could not be produced
SELECT DISTINCT WARE FROM CATEGORY
EXCEPT
SELECT DISTINCT WARE FROM PRODUCT;

-- 1.7. Get all the unique wares that both materials and products
SELECT DISTINCT WARE FROM MATERIAL
UNION
SELECT DISTINCT WARE FROM PRODUCT;

-- 1.8. Get the minimum and maximum prices of Paper
SELECT MIN(PRICE), MAX(PRICE)
FROM PRODUCT
WHERE WARE LIKE 'Paper';

-- 1.9. Get the average price and variance price of Meat, both rounded to one decimal point.
SELECT ROUND(AVG(PRICE), 1),  ROUND(MAX(PRICE) - MIN(PRICE), 1)
FROM PRODUCT
WHERE WARE LIKE 'Meat%'; -- or just 'Meat' (there are 'Meat' and 'Meat cow' in the table)