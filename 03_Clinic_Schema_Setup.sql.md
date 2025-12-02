03\_Clinic\_Schema\_Setup.sql





CREATE TABLE clinic\_centers (

&nbsp;   center\_id SERIAL PRIMARY KEY,

&nbsp;   name TEXT,

&nbsp;   location TEXT

);



CREATE TABLE clinic\_sales (

&nbsp;   sale\_id SERIAL PRIMARY KEY,

&nbsp;   center\_id INT REFERENCES clinic\_centers(center\_id),

&nbsp;   sales\_channel TEXT,  

&nbsp;   amount NUMERIC(12,2),

&nbsp;   sale\_date TIMESTAMP

);



CREATE TABLE expenses (

&nbsp;   expense\_id SERIAL PRIMARY KEY,

&nbsp;   center\_id INT REFERENCES clinic\_centers(center\_id),

&nbsp;   category TEXT,

&nbsp;   amount NUMERIC(12,2),

&nbsp;   expense\_date TIMESTAMP

);



**Insert Data**



INSERT INTO clinic\_centers (name, location) VALUES

('Clinic A','Chennai'),

('Clinic B','Coimbatore');



INSERT INTO clinic\_sales (center\_id, sales\_channel, amount, sale\_date) VALUES

(1,'walkin',150.00,'2021-11-02 09:00:00'),

(1,'online',200.00,'2021-11-03 10:00:00'),

(1,'walkin',300.00,'2021-11-20 15:00:00'),

(2,'partner',400.00,'2021-11-20 12:00:00'),

(2,'online',250.00,'2021-12-05 11:00:00');



INSERT INTO expenses (center\_id, category, amount, expense\_date) VALUES

(1,'rent',100.00,'2021-11-01'),

(1,'salaries',200.00,'2021-11-10'),

(2,'equipment',150.00,'2021-11-05'),

(1,'utilities',50.00,'2021-12-01');



