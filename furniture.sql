CREATE DATABASE ecommerce_furniture_dataset_2024;
USE ecommerce_furniture_dataset_2024;


select * from ecommerce_furniture_dataset;

ALTER TABLE ecommerce_furniture_dataset
ADD COLUMN Original_Price DECIMAL(10,2);

SET SQL_SAFE_UPDATES = 0;

UPDATE ecommerce_furniture_dataset
SET Original_Price = CASE
    WHEN originalPrice IS NULL OR originalPrice = '' THEN 0
    WHEN originalPrice LIKE '$%' THEN CONVERT(REPLACE(REPLACE(originalPrice, '$', ''), ',', ''), DECIMAL(10,2))
    ELSE NULL
END;



ALTER TABLE ecommerce_furniture_dataset
ADD COLUMN Price_decimal DECIMAL(10,2);

SET SQL_SAFE_UPDATES = 0;

UPDATE ecommerce_furniture_dataset
SET Price_decimal = CASE
    WHEN price IS NULL or price= '' THEN 0
    WHEN price LIKE '$%' THEN CONVERT(REPLACE(REPLACE(price, '$', ''), ',', ''), DECIMAL(10,2))
    ELSE NULL
END;


SET SQL_SAFE_UPDATES = 0;

UPDATE ecommerce_furniture_dataset
SET shipping_cost = CASE
    WHEN tagText IS NULL OR tagText = 'Free shipping' OR tagText = '' THEN 0
    WHEN tagText LIKE '%+Shipping: $%' THEN 
        CONVERT(REPLACE(REPLACE(tagText, '+Shipping: $', ''), ',', ''), DECIMAL(10,2))
    ELSE NULL
END;


#check number of empty rows
SELECT * FROM ecommerce_furniture_dataset
WHERE Original_Price IS NULL 
   OR Price_decimal IS NULL 
   OR shipping_cost IS NULL
   OR sold IS NULL;

#count number of empty rows
SELECT COUNT(*) FROM ecommerce_furniture_dataset
WHERE Original_Price IS NULL 
   OR Price_decimal IS NULL 
   OR shipping_cost IS NULL
   OR sold IS NULL;

#check for duplicates
SELECT productTitle, COUNT(*) AS count_order
FROM ecommerce_furniture_dataset
GROUP BY productTitle
HAVING COUNT(*) > 1;


#1.	Find the total number of orders.

SELECT COUNT(*) AS NUMBER_OF_ORDERS FROM ecommerce_furniture_dataset
WHERE sold > 0 ;

#2. Find the Total Revenue Generated
SELECT SUM(sold*Price_decimal) as Total_Revenue FROM ecommerce_furniture_dataset;

#3. Average Price of Products
select avg(Price_decimal) as Average_products_price FROM ecommerce_furniture_dataset;

#4. Number of products with Free Shipping Tag
select count(shipping_cost) as Number_of_products from ecommerce_furniture_dataset
where shipping_cost=0;

#5. Number of products with shipping cost
select count(shipping_cost) as Number_of_products from ecommerce_furniture_dataset
where shipping_cost!=0;

#6. Find the quantity, avereage price and average renue for Free Shipping cost product vs Shipping charge product
SELECT
    CASE
        WHEN shipping_cost > 0 THEN 'Shipping Cost'
        ELSE 'Free Shipping'
    END AS Shipping_Type,
    COUNT(sold) AS Quantity_sold,
    AVG(Price_decimal) AS Average_Price,
    AVG(Price_decimal * sold) AS Average_Revenue
FROM ecommerce_furniture_dataset
where sold>0
GROUP BY Shipping_Type;

#7 find quantity sold under price Range Grouping

SELECT
  CASE
    WHEN Price_decimal > 0 AND Price_decimal <= 50 THEN 'Low Price'
    WHEN Price_decimal > 50 AND Price_decimal <= 160 THEN 'Mid Price'
    WHEN Price_decimal > 160 THEN 'High Price'
  END AS Price_Range_Grouping,
  SUM(sold) AS Quantity_Sold
FROM ecommerce_furniture_dataset
WHERE sold > 0 AND Price_decimal > 0
GROUP BY Price_Range_Grouping;

#8 Top 10 Bestselling Products (Based Only on Units Sold)
SELECT productTitle, sold, Original_Price, Price_decimal, shipping_cost
FROM ecommerce_furniture_dataset
where sold>0
ORDER BY Price_decimal DESC, sold desc LIMIT 10;

#9 Top 10 Most Expensive Products (Among Bestselling Items)
select productTitle from ecommerce_furniture_dataset
where sold>0;
select count(*) as number_of_quantity_with_zero_sale from ecommerce_furniture_dataset
where sold>0;

#10 Find Discounted Products
select productTitle, sold, Original_Price, Price_decimal, shipping_cost from ecommerce_furniture_dataset
where Original_Price>0
order by sold desc;


#11 Calculate Discount Percentage
SELECT productTitle, ROUND(((Original_Price - Price_decimal) / Original_Price) * 100, 2) AS Discount_Percentage, sold FROM ecommerce_furniture_dataset
HAVING Discount_Percentage > 0
ORDER BY Discount_Percentage DESC, sold DESC;

#12 Most Common Price Points(top 10)
SELECT Price_decimal, COUNT(*) AS Frequency FROM ecommerce_furniture_dataset
WHERE Price_decimal IS NOT NULL
GROUP BY Price_decimal
ORDER BY Frequency DESC LIMIT 10;

#13 Product with no sale
SELECT productTitle, Price_decimal FROM ecommerce_furniture_dataset
WHERE sold = 0;
SELECT count(*) as quantity_of_product_with_no_sale FROM ecommerce_furniture_dataset
WHERE sold = 0;

#14 Free Shipping Impact on Average Price and Sold
SELECT shipping_cost, COUNT(*) AS Product_Count, ROUND(AVG(Price_decimal), 2) AS Avg_Price, ROUND(AVG(sold), 2) AS Avg_Sold
FROM ecommerce_furniture_dataset
where sold>0
GROUP BY shipping_cost order by Product_Count desc;

#15 Total Discount Value Given
SELECT SUM((Original_Price - Price_decimal) * sold) AS Total_Discount_Value FROM ecommerce_furniture_dataset
WHERE Original_Price >0 AND Price_decimal >0 and sold > 0;

#16 Product Title Keyword Frequency
SELECT 
CASE
    WHEN productTitle LIKE '%Sofa%' THEN 'Sofa'
    WHEN productTitle LIKE '%Bed%' THEN 'Bed'
    WHEN productTitle LIKE '%Chair%' THEN 'Chair'
    WHEN productTitle LIKE '%Table%' THEN 'Table'
    WHEN productTitle LIKE '%Cabinet%' THEN 'Cabinet'
    ELSE 'Other'
  END AS Title_Keyword,
  COUNT(*) AS Frequency
FROM ecommerce_furniture_dataset
GROUP BY Title_Keyword
ORDER BY Frequency DESC;

#17 Revenue Contribution % and discount % by Product Type
WITH revenue_by_type AS (
  SELECT 
    CASE
      WHEN productTitle LIKE '%Sofa%' THEN 'Sofa'
      WHEN productTitle LIKE '%Chair%' THEN 'Chair'
      WHEN productTitle LIKE '%Table%' THEN 'Table'
      WHEN productTitle LIKE '%Bed%' THEN 'Bed'
      WHEN productTitle LIKE '%Cabinet%' THEN 'Cabinet'
      ELSE 'Other'
    END AS Product_Type,
    SUM(Price_decimal * sold) AS Revenue
  FROM ecommerce_furniture_dataset
  GROUP BY Product_Type
),
discounted_products AS (
  SELECT 
    CASE
      WHEN productTitle LIKE '%Sofa%' THEN 'Sofa'
      WHEN productTitle LIKE '%Chair%' THEN 'Chair'
      WHEN productTitle LIKE '%Table%' THEN 'Table'
      WHEN productTitle LIKE '%Bed%' THEN 'Bed'
      WHEN productTitle LIKE '%Cabinet%' THEN 'Cabinet'
      ELSE 'Other'
    END AS Product_Type,
    ROUND(AVG(Original_Price), 2) AS Avg_Original_Price,
    ROUND(AVG(Price_decimal), 2) AS Avg_Discounted_Price,
    ROUND(AVG(Original_Price - Price_decimal), 2) AS Avg_Discount_Amount,
    ROUND(AVG((Original_Price - Price_decimal) / Original_Price) * 100, 2) AS Avg_Discount_Percentage
  FROM ecommerce_furniture_dataset
  WHERE Original_Price > 0 AND (Original_Price - Price_decimal) > 0
  GROUP BY Product_Type
)
SELECT 
  d.Product_Type,
  d.Avg_Original_Price,
  d.Avg_Discounted_Price,
  d.Avg_Discount_Amount,
  d.Avg_Discount_Percentage,
  r.Revenue,
  ROUND(r.Revenue * 100.0 / SUM(r.Revenue) OVER (), 2) AS Revenue_Percentage
FROM discounted_products d
JOIN revenue_by_type r ON d.Product_Type = r.Product_Type
ORDER BY d.Avg_Discount_Percentage DESC;

#18 Product Title Keyword Frequency which are not sold
SELECT 
  CASE
    WHEN productTitle LIKE '%Sofa%' THEN 'Sofa'
    WHEN productTitle LIKE '%Bed%' THEN 'Bed'
    WHEN productTitle LIKE '%Chair%' THEN 'Chair'
    WHEN productTitle LIKE '%Table%' THEN 'Table'
    WHEN productTitle LIKE '%Cabinet%' THEN 'Cabinet'
    ELSE 'Other'
  END AS Title_Keyword,
  COUNT(*) AS Frequency_of_Unsold_Products
FROM ecommerce_furniture_dataset
WHERE sold = 0
GROUP BY Title_Keyword
ORDER BY Frequency_of_Unsold_Products DESC;






