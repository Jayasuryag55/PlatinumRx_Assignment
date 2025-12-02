-- 02_Hotel_Queries.sql

Q1:For every user, get user_id and last booked room_no 

WITH last_booking AS (
  SELECT
    user_id,
    room_no,
    booking_date,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) AS rn
  FROM bookings
)
SELECT user_id, room_no, booking_date
FROM last_booking
WHERE rn = 1;

Q2:booking_id and total billing amount of every booking created in November 2021

SELECT
  b.booking_id,
  SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc ON bc.booking_id = b.booking_id
JOIN items i ON i.item_id = bc.item_id
WHERE b.booking_date >= '2021-11-01'::timestamp
  AND b.booking_date <  '2021-12-01'::timestamp
GROUP BY b.booking_id
ORDER BY b.booking_id;



Q3: bill_id and bill amount of all bills raised in October 2021 with bill amount > 1000

SELECT
  bc.bill_id,
  SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON i.item_id = bc.item_id
WHERE bc.bill_date >= '2021-10-01'::timestamp
  AND bc.bill_date <  '2021-11-01'::timestamp
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000
ORDER BY bill_amount DESC;



Q4: Determine the most ordered and least ordered item of each month of year 2021

WITH monthly_item_qty AS (
  SELECT
    date_trunc('month', bc.bill_date) AS month_start,
    i.item_id,
    i.item_name,
    SUM(bc.item_quantity) AS total_qty
  FROM booking_commercials bc
  JOIN items i ON i.item_id = bc.item_id
  WHERE bc.bill_date >= '2021-01-01'::timestamp
    AND bc.bill_date <  '2022-01-01'::timestamp
  GROUP BY 1, i.item_id, i.item_name
),
ranked AS (
  SELECT
    month_start,
    item_id,
    item_name,
    total_qty,
    RANK() OVER (PARTITION BY month_start ORDER BY total_qty DESC)    AS rank_desc,
    RANK() OVER (PARTITION BY month_start ORDER BY total_qty ASC)     AS rank_asc
  FROM monthly_item_qty
)
-- Most ordered per month:
SELECT 'most_ordered' AS type, month_start, item_id, item_name, total_qty
FROM ranked
WHERE rank_desc = 1
UNION ALL
-- Least ordered per month:
SELECT 'least_ordered' AS type, month_start, item_id, item_name, total_qty
FROM ranked
WHERE rank_asc = 1
ORDER BY month_start, type;



Q5: Customers with the second highest bill value of each month of 2021

WITH bill_totals AS (
  SELECT
    bc.bill_id,
    date_trunc('month', bc.bill_date) AS month_start,
    b.user_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
  FROM booking_commercials bc
  JOIN bookings b ON b.booking_id = bc.booking_id
  JOIN items i ON i.item_id = bc.item_id
  WHERE bc.bill_date >= '2021-01-01'::timestamp
    AND bc.bill_date <  '2022-01-01'::timestamp
  GROUP BY bc.bill_id, month_start, b.user_id
),
ranked AS (
  SELECT
    month_start,
    bill_id,
    user_id,
    bill_amount,
    RANK() OVER (PARTITION BY month_start ORDER BY bill_amount DESC) AS rnk
  FROM bill_totals
)
SELECT month_start, bill_id, user_id, bill_amount
FROM ranked
WHERE rnk = 2
ORDER BY month_start;
