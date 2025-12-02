-- 02_Hotel_Queries.sql

Q1: Last booked room (most recent booking)

SELECT b.booking_id, u.full_name, r.room_number, r.room_type, b.booked_at
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN rooms r ON b.room_id = r.room_id
ORDER BY b.booked_at DESC
LIMIT 1;

Q2: Billing in Nov 2021.

SELECT b.booking_id,
       u.full_name,
       SUM(bi.quantity * bi.rate) AS items_amount,
       COALESCE(SUM(bc.amount),0) AS other_amounts,
       (SUM(bi.quantity * bi.rate) + COALESCE(SUM(bc.amount),0)) AS total_bill
FROM bookings b
LEFT JOIN booking_items bi ON b.booking_id = bi.booking_id
LEFT JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN users u ON b.user_id = u.user_id
WHERE b.booked_at >= '2021-11-01'::date
  AND b.booked_at < '2021-12-01'::date
GROUP BY b.booking_id, u.full_name
ORDER BY total_bill DESC;

Q3: Bills > 1000 (identify bookings whose total billing > 1000)

WITH booking_totals AS (
  SELECT b.booking_id,
         SUM(bi.quantity * bi.rate) AS items_amount,
         COALESCE(SUM(bc.amount),0) AS other_amounts,
         (COALESCE(SUM(bi.quantity * bi.rate),0) + COALESCE(SUM(bc.amount),0)) AS total_bill
  FROM bookings b
  LEFT JOIN booking_items bi ON b.booking_id = bi.booking_id
  LEFT JOIN booking_commercials bc ON b.booking_id = bc.booking_id
  GROUP BY b.booking_id
)
SELECT bt.booking_id, bt.total_bill
FROM booking_totals bt
WHERE bt.total_bill > 1000
ORDER BY bt.total_bill DESC;

Q4: Most and least ordered items per month

WITH month_item AS (
  SELECT date_trunc('month', b.booked_at) AS month,
         i.name AS item_name,
         SUM(bi.quantity) AS total_qty
  FROM booking_items bi
  JOIN bookings b ON bi.booking_id = b.booking_id
  JOIN items i ON bi.item_id = i.item_id
  GROUP BY date_trunc('month', b.booked_at), i.name
)
, ranked AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY month ORDER BY total_qty DESC) AS rn_desc,
         ROW_NUMBER() OVER (PARTITION BY month ORDER BY total_qty ASC)  AS rn_asc
  FROM month_item
)
SELECT month, 'most_ordered' AS which, item_name, total_qty
FROM ranked
WHERE rn_desc = 1
UNION ALL
SELECT month, 'least_ordered' AS which, item_name, total_qty
FROM ranked
WHERE rn_asc = 1
ORDER BY month, which;

Q5: 2nd highest bill (per booking or global?) - assuming global 2nd highest booking total

WITH booking_totals AS (
  SELECT b.booking_id,
         b.booked_at,
         u.full_name,
         (COALESCE(SUM(bi.quantity * bi.rate),0) + COALESCE(SUM(bc.amount),0)) AS total_bill
  FROM bookings b
  LEFT JOIN booking_items bi ON b.booking_id = bi.booking_id
  LEFT JOIN booking_commercials bc ON b.booking_id = bc.booking_id
  LEFT JOIN users u ON b.user_id = u.user_id
  GROUP BY b.booking_id, b.booked_at, u.full_name
)
, ranked AS (
  SELECT *,
         DENSE_RANK() OVER (ORDER BY total_bill DESC) AS bill_rank
  FROM booking_totals
)
SELECT booking_id, full_name, booked_at, total_bill
FROM ranked
WHERE bill_rank = 2;
