-- 04\_Clinic\_Queries.sql


**Q1: Revenue from each sales channel in a given year**



SELECT
  sales_channel,
  SUM(amount) AS revenue
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime) = 2021
GROUP BY sales_channel
ORDER BY revenue DESC;



**Q2: Top 10 most valuable customers for a given year**



SELECT
  cs.uid,
  c.name,
  SUM(cs.amount) AS total_spent
FROM clinic_sales cs
LEFT JOIN customer c ON c.uid = cs.uid
WHERE EXTRACT(YEAR FROM cs.datetime) = 2021
GROUP BY cs.uid, c.name
ORDER BY total_spent DESC
LIMIT 10;




**3: Month-wise revenue, expense, profit, status (profitable / not-profitable) for a given year**



WITH revenue_month AS (
  SELECT date_trunc('month', datetime) AS month_start, SUM(amount) AS revenue
  FROM clinic_sales
  WHERE EXTRACT(YEAR FROM datetime) = 2021
  GROUP BY 1
),
expense_month AS (
  SELECT date_trunc('month', datetime) AS month_start, SUM(amount) AS expense
  FROM expenses
  WHERE EXTRACT(YEAR FROM datetime) = 2021
  GROUP BY 1
)
SELECT
  COALESCE(r.month_start, e.month_start) AS month_start,
  COALESCE(r.revenue, 0) AS revenue,
  COALESCE(e.expense, 0) AS expense,
  COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit,
  CASE WHEN COALESCE(r.revenue,0) - COALESCE(e.expense,0) > 0 THEN 'profitable' ELSE 'not-profitable' END AS status
FROM revenue_month r
FULL OUTER JOIN expense_month e USING (month_start)
ORDER BY month_start;




