-- Query for all Amazon products in the database

SELECT *
FROM [Amazon Data]..products

-- Query for all Amazon product reviews in the database

SELECT *
FROM [Amazon Data]..reviews
ORDER BY product_id

-- Query for all Amazon Products and their reviews (Inner Join - default)

SELECT prd.*, rating, rating_count, about_product, user_id, user_name, review_id, review_title, review_content
FROM [Amazon Data]..products prd
JOIN [Amazon Data]..reviews rev
 ON prd.product_id = rev.product_id

-- Query for putting the joined table in a CTE (Common Table Expression)

WITH Amazon_CTE AS(
SELECT prd.*, rating, rating_count, about_product, user_id, user_name, review_id, review_title, review_content
FROM [Amazon Data]..products prd
JOIN [Amazon Data]..reviews rev
 ON prd.product_id = rev.product_id
 )

 SELECT *
 FROM Amazon_CTE

 -- Query for putting the join query in a stored procedure

CREATE PROCEDURE Amazon_join
as
SELECT prd.*, rating, rating_count, about_product, user_id, user_name, review_id, review_title, review_content
FROM [Amazon Data]..products prd
JOIN [Amazon Data]..reviews rev
ON prd.product_id = rev.product_id

EXEC Amazon_join

 -- Query for putting the joined table in a Temp Table

CREATE TABLE #Amazon_Temp_Table(
product_id varchar(20), product_name varchar(max), category varchar(max), discounted_price int, actual_price int, discount_percentage int, img_link nvarchar(150), product_link nvarchar(200), rating float, rating_count int, about_product nvarchar(MAX), user_id nvarchar(MAX), user_name nvarchar(MAX), review_id nvarchar(MAX), review_title nvarchar(MAX), review_content nvarchar(MAX)
)

INSERT INTO #Amazon_Temp_Table
SELECT prd.product_id, product_name, category, discounted_price, actual_price, discount_percentage, img_link, product_link, rating, rating_count, about_product, user_id, user_name, review_id, review_title, review_content
	FROM [Amazon Data]..products prd
		JOIN [Amazon Data]..reviews as rev
			ON prd.product_id = rev.product_id

SELECT *
FROM #Amazon_Temp_Table

-- Query to find all products with ratings over 4

SELECT *
FROM #Amazon_Temp_Table
WHERE rating > 4

-- Query to find all products with ratings below 3

SELECT *
FROM #Amazon_Temp_Table
WHERE rating < 3

-- Query to find all products with price above 1000 and rating above 4

SELECT *
FROM #Amazon_Temp_Table
WHERE rating > 4 AND actual_price > 1000

-- Query to find count of products in each category and group them by category

SELECT category, COUNT(category) as "Products in this Category"
FROM #Amazon_Temp_Table
GROUP BY category

-- Query to find display products along with discount amount

SELECT product_id, discount_percentage, discounted_price, actual_price, (actual_price - discounted_price) AS "Discount Amount"
FROM #Amazon_Temp_Table

-- Query for all reviews for products with an average rating greater than 3 and less than or equal to 4

SELECT product_id, category, discounted_price, rating, rating_count, review_content, review_title, review_id
FROM #Amazon_Temp_Table
WHERE rating > 3 AND rating <= 4