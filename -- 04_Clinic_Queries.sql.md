-- 04\_Clinic\_Queries.sql



**Q1: Revenue by Channel (total revenue aggregated by sales\_channel)**



SELECT sales\_channel, SUM(amount) AS total\_revenue

FROM clinic\_sales

GROUP BY sales\_channel

ORDER BY total\_revenue DESC;



**Q2: Revenue per Center per Month**



SELECT c.center\_id, c.name,

&nbsp;      date\_trunc('month', cs.sale\_date) AS month,

&nbsp;      SUM(cs.amount) AS revenue

FROM clinic\_sales cs

JOIN clinic\_centers c ON cs.center\_id = c.center\_id

GROUP BY c.center\_id, c.name, date\_trunc('month', cs.sale\_date)

ORDER BY c.center\_id, month;



**3: Profit/Loss by Month (Revenue - Expenses)**



WITH rev AS (

&nbsp; SELECT center\_id, date\_trunc('month', sale\_date) AS month, SUM(amount) AS revenue

&nbsp; FROM clinic\_sales

&nbsp; GROUP BY center\_id, date\_trunc('month', sale\_date)

),

exp AS (

&nbsp; SELECT center\_id, date\_trunc('month', expense\_date) AS month, SUM(amount) AS expenses

&nbsp; FROM expenses

&nbsp; GROUP BY center\_id, date\_trunc('month', expense\_date)

)

SELECT COALESCE(r.center\_id, e.center\_id) AS center\_id,

&nbsp;      COALESCE(c.name, 'Unknown') AS center\_name,

&nbsp;      COALESCE(r.month, e.month) AS month,

&nbsp;      COALESCE(r.revenue,0) AS revenue,

&nbsp;      COALESCE(e.expenses,0) AS expenses,

&nbsp;      (COALESCE(r.revenue,0) - COALESCE(e.expenses,0)) AS profit\_loss

FROM rev r

FULL OUTER JOIN exp e

&nbsp; ON r.center\_id = e.center\_id AND r.month = e.month

LEFT JOIN clinic\_centers c ON COALESCE(r.center\_id, e.center\_id) = c.center\_id

ORDER BY center\_id, month;



