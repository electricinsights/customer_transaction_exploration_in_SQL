-- 1. List of customers with full demographic details
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    d.address, 
    d.postcode, 
    d.state, 
    d.country, 
    d.property_valuation
FROM 
    muzammildb.dbo.CustomerDemographic AS c
JOIN 
    CustomerAddress AS d 
    ON c.customer_id = d.customer_id;

-- 2. Segment customers by state and gender
SELECT 
    d.state, 
    c.gender, 
    COUNT(*) AS customer_count
FROM 
    muzammildb.dbo.CustomerDemographic AS c
JOIN 
    CustomerAddress AS d 
    ON c.customer_id = d.customer_id
GROUP BY 
    d.state, c.gender;

-- 3. Analyze bike-related purchases over the past 3 years
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    c.past_3_years_bike_related_purchases
FROM 
    muzammildb.dbo.CustomerDemographic AS c
WHERE 
    c.past_3_years_bike_related_purchases > 0;

-- 4. Find customers who own a car and their job titles
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    c.job_title, 
    c.owns_car
FROM 
    muzammildb.dbo.CustomerDemographic AS c
WHERE 
    c.owns_car = 'Yes'
ORDER BY 
    customer_id;

-- 5. Summarize transactions by product line
SELECT 
    t.product_line, 
    COUNT(*) AS transaction_count, 
    SUM(t.list_price) AS total_revenue
FROM 
    muzammildb.dbo.Transactions AS t
GROUP BY 
    t.product_line
ORDER BY 
    total_revenue DESC;

-- 6. Analyze online vs. offline orders
SELECT 
    t.online_order, 
    COUNT(*) AS order_count, 
    SUM(t.list_price) AS total_revenue
FROM 
    muzammildb.dbo.Transactions AS t
GROUP BY 
    t.online_order;

-- 7. Sales trends over time (monthly)
SELECT 
    YEAR(t.transaction_date) AS year, 
    MONTH(t.transaction_date) AS month, 
    COUNT(*) AS transaction_count, 
    SUM(t.list_price) AS total_revenue
FROM 
    muzammildb.dbo.Transactions AS t
GROUP BY 
    YEAR(t.transaction_date), 
    MONTH(t.transaction_date)
ORDER BY 
    year, month;

-- 8. Analyze order status
SELECT 
    t.order_status, 
    COUNT(*) AS order_count, 
    SUM(t.list_price) AS total_revenue
FROM 
    muzammildb.dbo.Transactions AS t
GROUP BY 
    t.order_status;

-- 9. Assess brand performance
SELECT 
    t.brand, 
    COUNT(*) AS transaction_count, 
    SUM(t.list_price) AS total_revenue
FROM 
    muzammildb.dbo.Transactions AS t
GROUP BY 
    t.brand
ORDER BY 
    total_revenue DESC;

-- 10. Evaluate product class performance
SELECT 
    t.product_class, 
    COUNT(*) AS transaction_count, 
    SUM(t.list_price) AS total_revenue
FROM 
    muzammildb.dbo.Transactions AS t
GROUP BY 
    t.product_class;

-- 11. Identify high-value customers based on total spend
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    SUM(t.list_price) AS total_spent
FROM 
    muzammildb.dbo.CustomerDemographic AS c
JOIN 
    muzammildb.dbo.Transactions AS t 
    ON c.customer_id = t.customer_id
GROUP BY 
    c.customer_id, 
    c.first_name, 
    c.last_name
HAVING 
    SUM(t.list_price) > 500;

-- 12. Profile new customer data
SELECT 
    n.first_name, 
    n.last_name, 
    n.gender, 
    n.job_title, 
    n.job_industry_category, 
    n.wealth_segment
FROM 
    muzammildb.dbo.NewCustomerList AS n
WHERE 
    n.job_title IS NOT NULL;

-- 13. Customers with the highest tenure
SELECT 
    TOP 10 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    c.tenure
FROM 
    CustomerDemographic AS c
ORDER BY 
    c.tenure DESC;

-- 14. Cross-sell opportunities
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    t.product_id, 
    COUNT(t.transaction_id) AS purchase_count
FROM 
    muzammildb.dbo.CustomerDemographic AS c
JOIN 
    muzammildb.dbo.Transactions AS t 
    ON c.customer_id = t.customer_id
WHERE 
    t.product_id IN (SELECT DISTINCT product_id FROM muzammildb.dbo.Transactions)
GROUP BY 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    t.product_id;

-- 15. Property valuation distribution
SELECT 
    d.property_valuation, 
    COUNT(*) AS customer_count
FROM 
    muzammildb.dbo.CustomerAddress AS d
GROUP BY 
    d.property_valuation;

-- 16. Summarize job industry
SELECT 
    c.job_industry_category, 
    COUNT(*) AS customer_count
FROM 
    muzammildb.dbo.CustomerDemographic AS c
WHERE 
    job_industry_category IS NOT NULL
GROUP BY 
    c.job_industry_category;

-- 17. Customer spend by wealth segment
SELECT 
    c.wealth_segment, 
    SUM(t.list_price) AS total_spent
FROM 
    muzammildb.dbo.CustomerDemographic AS c
JOIN 
    muzammildb.dbo.Transactions AS t 
    ON c.customer_id = t.customer_id
GROUP BY 
    c.wealth_segment;

-- 18. Find top products sold by revenue
SELECT 
    TOP 10 
    t.product_id, 
    SUM(t.list_price) AS total_revenue
FROM 
    muzammildb.dbo.Transactions AS t
GROUP BY 
    t.product_id
ORDER BY 
    total_revenue DESC;

-- 19. Customer distribution by country
SELECT 
    d.country, 
    COUNT(*) AS customer_count
FROM 
    muzammildb.dbo.CustomerAddress AS d
GROUP BY 
    d.country;

-- 20. Analyze decreased indicator for customers
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    c.deceased_indicator
FROM 
    CustomerDemographic AS c
WHERE 
    c.deceased_indicator = 'N';