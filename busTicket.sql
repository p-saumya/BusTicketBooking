CREATE TABLE Buses (
    bus_id INT PRIMARY KEY AUTO_INCREMENT,
    bus_number VARCHAR(20) NOT NULL,
    bus_type VARCHAR(50),
    total_seats INT NOT NULL,
    operator_name VARCHAR(100),
    registration_number VARCHAR(50) UNIQUE
);

CREATE TABLE Routes (
    route_id INT PRIMARY KEY AUTO_INCREMENT,
    source VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    distance_km INT,
    duration_hours DECIMAL(5,2)
);

CREATE TABLE Schedules (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    bus_id INT,
    route_id INT,
    departure_time TIME,
    arrival_time TIME,
    travel_date DATE,
    FOREIGN KEY (bus_id) REFERENCES Buses(bus_id),
    FOREIGN KEY (route_id) REFERENCES Routes(route_id)
);
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(15)
);

CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_id INT,
    schedule_id INT,
    seat_number INT,
    booking_date DATE,
    fare DECIMAL(10,2),
    status VARCHAR(20) CHECK (status IN ('Booked', 'Cancelled', 'Completed')),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (schedule_id) REFERENCES Schedules(schedule_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    payment_method VARCHAR(20) CHECK (payment_method IN ('Credit Card', 'Debit Card', 'Cash', 'Online')),
    payment_status VARCHAR(20) CHECK (payment_status IN ('Paid', 'Pending', 'Failed')),
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);

CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    experience_years INT
);

CREATE TABLE Bus_Assignments (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    bus_id INT,
    driver_id INT,
    assignment_date DATE,
    FOREIGN KEY (bus_id) REFERENCES Buses(bus_id),
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id)
);

CREATE TABLE Feedbacks (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT,
    passenger_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    feedback_date DATE,
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id)
);

CREATE TABLE Bus_Maintenance (
    maintenance_id INT PRIMARY KEY AUTO_INCREMENT,
    bus_id INT,
    maintenance_date DATE,
    description TEXT,
    cost DECIMAL(10,2),
    FOREIGN KEY (bus_id) REFERENCES Buses(bus_id)
);

CREATE TABLE Discounts (
    discount_id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE,
    description TEXT,
    discount_percentage DECIMAL(5,2),
    start_date DATE,
    end_date DATE
);

CREATE TABLE Ticket_Discounts (
    ticket_discount_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT,
    discount_id INT,
    applied_date DATE,
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id),
    FOREIGN KEY (discount_id) REFERENCES Discounts(discount_id)
);

INSERT INTO Tickets (passenger_id, schedule_id, seat_number, booking_date, fare, status)
VALUES (1, 3, 12, CURDATE(), 150.00, 'Booked');

UPDATE Tickets
SET status = 'Cancelled'
WHERE ticket_id = 5;

SELECT S.schedule_id, B.bus_number, R.source, R.destination, S.departure_time, S.arrival_time, S.travel_date
FROM Schedules S
JOIN Buses B ON S.bus_id = B.bus_id
JOIN Routes R ON S.route_id = R.route_id
WHERE B.bus_number = 'ABC123';

SELECT P.first_name, P.last_name, F.rating, F.comments
FROM Feedbacks F
JOIN Passengers P ON F.passenger_id = P.passenger_id
WHERE F.ticket_id IN (
    SELECT ticket_id FROM Tickets WHERE schedule_id = 2
);

INSERT INTO Ticket_Discounts (ticket_id, discount_id, applied_date)
VALUES (4, 2, CURDATE());

SELECT B.bus_number, M.maintenance_date, M.description, M.cost
FROM Bus_Maintenance M
JOIN Buses B ON M.bus_id = B.bus_id
WHERE B.bus_id = 1
ORDER BY M.maintenance_date DESC;




