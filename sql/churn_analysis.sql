-- European Bank Customer Churn Analysis
-- Table: bank_customers
-- Objective: Identify customer segments associated with churn.

-- 1. Inspect the dataset
SELECT *
FROM bank_customers
LIMIT 10;

-- 2. Check the total number of customers
SELECT COUNT(*) AS total_customers
FROM bank_customers;

-- 3. Calculate overall churn
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS churn_rate_pct
FROM bank_customers;

-- 4. Analyse churn by geography
SELECT
    geography,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS churn_rate_pct
FROM bank_customers
GROUP BY geography
ORDER BY churn_rate_pct DESC;

-- 5. Analyse churn by gender
SELECT
    gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS churn_rate_pct
FROM bank_customers
GROUP BY gender
ORDER BY churn_rate_pct DESC;

-- 6. Analyse churn by activity status
SELECT
    is_active_member,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS churn_rate_pct
FROM bank_customers
GROUP BY is_active_member
ORDER BY churn_rate_pct DESC;

-- 7. Analyse churn by number of products
SELECT
    num_of_products,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS churn_rate_pct
FROM bank_customers
GROUP BY num_of_products
ORDER BY num_of_products;

-- 8. Analyse churn by age group
WITH age_groups AS (
    SELECT
        CASE
            WHEN age <= 30 THEN '18-30'
            WHEN age <= 40 THEN '31-40'
            WHEN age <= 50 THEN '41-50'
            ELSE '51+'
        END AS age_group,
        exited
    FROM bank_customers
)
SELECT
    age_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS churn_rate_pct
FROM age_groups
GROUP BY age_group
ORDER BY
    CASE age_group
        WHEN '18-30' THEN 1
        WHEN '31-40' THEN 2
        WHEN '41-50' THEN 3
        ELSE 4
    END;

-- 9. Compare average balance by churn status
SELECT
    exited,
    COUNT(*) AS total_customers,
    ROUND(AVG(balance), 2) AS average_balance
FROM bank_customers
GROUP BY exited
ORDER BY exited;

-- 10. Rank countries by churn rate
WITH country_summary AS (
    SELECT
        geography,
        AVG(exited::numeric) * 100 AS churn_rate_pct
    FROM bank_customers
    GROUP BY geography
)
SELECT
    geography,
    ROUND(churn_rate_pct, 2) AS churn_rate_pct,
    RANK() OVER (ORDER BY churn_rate_pct DESC) AS churn_rank
FROM country_summary
ORDER BY churn_rank;
