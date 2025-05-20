# E-commerce Furniture Data Analysis Project (By using SQL in MySQL)
This dataset comprises 2,000 entries scraped from AliExpress, detailing a wide range of furniture products. It includes essential sales metrics and product information such as pricing, shipping details, discount amounts, and order quantities. The dataset provides a structured overview of the online furniture retail market, capturing key attributes like product category, number of orders, and listing prices. It serves as a valuable resource for understanding product availability and the commercial landscape of e-commerce platforms, particularly within the home and living segment.

## Dataset used
Dataset = "https://github.com/SubhankarMukherjee-portfolio/E-commerce_Furniture_Project/blob/main/ecommerce_furniture_dataset.csv"


## Project Objective
1) To clean and preprocess the dataset for analytical readiness.
2) To standardize pricing fields and derive new columns (Original_Price, Price_decimal, shipping_cost).
3) To analyze product performance through metrics like units sold, revenue, discount, and pricing tiers.
4) To identify top-performing and underperforming products and categories (e.g., Sofa, Bed, Table).
5) To segment customers based on price preferences and shipping behaviors.
6) To discover trends in free shipping, discounts, and their effect on sales.
7) To provide data-driven recommendations for inventory, pricing, and promotional strategies.

## SQL File (MySQL)
SQL File = "https://github.com/SubhankarMukherjee-portfolio/E-commerce_Furniture_Project/blob/main/furniture.sql"

## Questions solved
1) Find the total number of orders.
2) Find the total revenue generated.
3) What is the average price of the products?
4) Find the number of products with a free shipping tag.
5) Find the number of products with a shipping cost.
6) Find the quantity, average price, and average revenue for free shipping products vs. shipping charge products.
7) Find quantity sold under price range groupings.
8) Top 10 bestselling products (based only on units sold).
9) Top 10 most expensive products (among bestselling items).
10) Find discounted products.
11) Calculate discount percentage.
12) Most common price points (top 10).
13) Find products with no sales.
14) Find the impact of free shipping on average price and units sold.
15) Find total discount value.
16) Find product title keyword frequency.
17) Find revenue contribution % and discount % by product type.
18) Find product title keyword frequency for products that were not sold.

## Final Observations & Storyline
The dataset reveals that a total of 1,498 orders generated approximately ₹21.3 lakhs in revenue, with an average product price of ₹152.99 across 1,802 products. A significant portion of customers preferred free shipping, accounting for 1,388 units sold, though products with shipping charges had a slightly higher average revenue per product. Low-priced items dominated sales volume with over 37,000 units sold, while mid- and high-priced items had lower quantities. Despite heavy discounting—with a total discount value of ₹14.5 lakhs—over 421 products had zero sales, suggesting inefficiencies in pricing or promotion. Beds were the most frequently listed items, yet also had the highest number of unsold units, followed by sofas and tables. Product types such as chairs and tables showed strong sales volumes, especially when coupled with significant discounts averaging 50% or more. Notably, the highest revenue contributors were tables and sofas, each making up nearly 29% of total revenue. Overall, while discounts and free shipping drove sales, a large number of unsold products indicate the need for better inventory and pricing strategies.

