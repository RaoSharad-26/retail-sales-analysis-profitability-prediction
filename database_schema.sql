use retail_sales_analysis_project;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    ship_mode VARCHAR(50),
    segment VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_id VARCHAR(50),
    quantity INT,
    discount_percent DECIMAL(5,2),
    discount DECIMAL(10,2),
    sales_price DECIMAL(10,2),
    total_revenue DECIMAL(12,2),
    profit DECIMAL(12,2)
);	
select * from orders;