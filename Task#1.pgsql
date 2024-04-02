CREATE TABLE USERS (
    user_id SERIAL PRIMARY KEY,
    credentials VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL
);

INSERT INTO USERS (credentials, email) VALUES 
('Johnatan', 'johaham-uvi85@outlook.com'), 
('Eddy', 'pig-anogewe74@hotmail.com'), 
('Lily', 'cubeh_ujiku7@yahoo.com');

ALTER TABLE USERS
ADD COLUMN USER_TYPE VARCHAR(5);

ALTER TABLE USERS
ADD CONSTRAINT check_user_type CHECK (USER_TYPE IN ('Guest', 'Host'));

SELECT * FROM USERS;

UPDATE USERS
SET USER_TYPE = 'Guest'
WHERE USER_ID IN (1, 2);

UPDATE USERS
SET USER_TYPE = 'Host'
WHERE USER_ID IN (3);

CREATE TABLE APPARTMENTS (
    appartment_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    amount_ppl__residence INT NOT NULL,
    price DECIMAL(8, 2) NOT NULL,
    animals_approve BOOLEAN,
    facility_id INT NOT NULL,
    availability BOOLEAN NOT NULL,
    FOREIGN KEY (user_id)
        REFERENCES USERS (user_id)
);

SELECT * FROM APPARTMENTS;

INSERT INTO Appartments (user_ID, Amount_ppl__Residence, Price, Animals_approve, Facility_id, Availability) VALUES
(1, 4, 150.00, TRUE, 1, TRUE), 
(2, 2, 100.00, FALSE, 2, TRUE),    
(3, 6, 200.00, TRUE, 1, FALSE);

CREATE TABLE Facilities (
    facility_id SERIAL PRIMARY KEY,
    facility_name VARCHAR(100)
);

INSERT INTO Facilities (Facility_name) VALUES ('TV'), ('A/C'), ('Coffee Machine'), ('Microwave');

SELECT * FROM Facilities;

ALTER TABLE Appartments
ADD FOREIGN KEY (facility_id)
REFERENCES Facilities (facility_id);

CREATE TABLE Reservation (
    reserv_id SERIAL PRIMARY KEY,
    appartment_ID INT,
    user_ID INT,
    date_from DATE,
    date_to DATE,
    FOREIGN KEY (appartment_ID) REFERENCES Appartments(appartment_ID),
    FOREIGN KEY (user_ID) REFERENCES Users(user_ID)
);

SELECT * FROM Reservation;

INSERT INTO Reservation (appartment_ID, user_ID, date_from, date_to)
VALUES 
(1, 1, '2024-04-01', '2024-04-05'),
(2, 2, '2024-04-10', '2024-04-15'),
(3, 3, '2024-04-20', '2024-04-25');

CREATE TABLE Payment (
    payment_id SERIAL PRIMARY KEY,
    reserv_id INT,
    user_id INT,
    payment_confirm BOOLEAN,
    bill VARCHAR(255),
    FOREIGN KEY (reserv_id) REFERENCES Reservation(reserv_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO Payment (reserv_id, user_id, payment_confirm, bill)
VALUES 
(1, 1, true, 'Payment for Reservation 1'),
(2, 2, false, 'Payment for Reservation 2'),
(3, 3, true, 'Payment for Reservation 3');

CREATE TABLE Reviews (
    review_id SERIAL PRIMARY KEY,
    user_id INT,
    appartment_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (appartment_id) REFERENCES Appartments(appartment_id)
);

INSERT INTO Reviews (user_id, appartment_id)
VALUES 
(1, 1),
(2, 2),
(3, 3);

-- Задание 3.1: Найти пользователя с наибольшим количеством бронирований. Вернуть имя пользователя и user_id

SELECT u.user_id, u.credentials, COUNT(*) AS num_reservations
FROM Reservation 
JOIN Users u ON Reservation.user_id = u.user_id
GROUP BY u.user_id, u.credentials
ORDER BY num_reservations DESC
LIMIT 1;
