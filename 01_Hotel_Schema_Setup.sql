CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE
);

CREATE TABLE rooms (
    room_id SERIAL PRIMARY KEY,
    room_number TEXT UNIQUE,
    room_type TEXT,
    rate NUMERIC(10,2) 
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    room_id INT REFERENCES rooms(room_id),
    booked_at TIMESTAMP NOT NULL,    
    checkout_date DATE
);

CREATE TABLE items (
    item_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    price NUMERIC(10,2)
);

CREATE TABLE booking_items (
    booking_item_id SERIAL PRIMARY KEY,
    booking_id INT REFERENCES bookings(booking_id),
    item_id INT REFERENCES items(item_id),
    quantity INT DEFAULT 1,
    rate NUMERIC(10,2)
);


CREATE TABLE booking_commercials (
    commercial_id SERIAL PRIMARY KEY,
    booking_id INT REFERENCES bookings(booking_id),
    description TEXT,
    amount NUMERIC(12,2),
    created_at TIMESTAMP DEFAULT now()
);




Insert Data:



INSERT INTO users (full_name, email) VALUES
('Alice Singh','alice@example.com'),
('Bob Kumar','bob@example.com'),
('Cecilia Rao','cecilia@example.com');

INSERT INTO rooms (room_number, room_type, rate) VALUES
('101','Single',120.00),
('102','Double',200.00),
('201','Suite',450.00);

INSERT INTO bookings (user_id, room_id, booked_at, checkin_date, checkout_date) VALUES
(1,1,'2021-11-02 10:05:00','2021-11-15','2021-11-17'),
(2,2,'2021-11-20 16:30:00','2021-11-21','2021-11-22'),
(3,3,'2021-12-05 09:00:00','2021-12-06','2021-12-07'),
(1,2,'2021-12-15 12:00:00','2021-12-20','2021-12-22'),
(2,1,'2021-12-20 14:30:00','2021-12-25','2021-12-27');

INSERT INTO items (name, price) VALUES
('Breakfast', 15.00),
('Spa', 50.00),
('Laundry', 10.00),
('Minibar Soda', 5.00);

INSERT INTO booking_items (booking_id, item_id, quantity, rate) VALUES
(1,1,2,15.00),
(1,4,3,5.00),
(2,3,1,10.00),
(2,2,1,50.00),
(3,2,1,50.00),
(4,1,4,15.00),
(4,3,2,10.00),
(5,4,10,5.00);

INSERT INTO booking_commercials (booking_id, description, amount) VALUES
(1,'Room charges',240.00),
(1,'Food & items',45.00),
(2,'Room charges',200.00),
(2,'Services',60.00),
(3,'Room + Services',500.00),
(4,'Room charges',400.00),
(4,'Food',80.00),
(5,'Room charges',240.00),
(5,'Minibar',50.00); 