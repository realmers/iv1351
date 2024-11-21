-- Insert sample data

INSERT INTO "Instructor" ("personNumber", "name", "address", "email") VALUES
('123456789012', 'John Doe', '123 Main St', 'john.doe@example.com'),
('234567890123', 'Jane Smith', '456 Elm St', 'jane.smith@example.com'),
('345678901234', 'Emily Davis', '789 Oak St', 'emily.davis@example.com'),
('456789012345', 'Michael Wilson', '101 Birch St', 'michael.wilson@example.com');

INSERT INTO "AvailableTimeSlot" ("timeslot", "instructorId") VALUES
('2023-10-01 09:00:00', 1),
('2023-10-01 10:00:00', 2),
('2023-10-02 09:00:00', 3),
('2023-10-02 10:00:00', 4);

INSERT INTO "InstructorPayment" ("paymentDate", "amount", "instructorId") VALUES
('2023-09-01', 1500.00, 1),
('2023-09-01', 1600.00, 2),
('2023-09-02', 1700.00, 3),
('2023-09-02', 1800.00, 4);

INSERT INTO "StudentLevel" ("level") VALUES
('beginner'),
('intermediate'),
('advanced');

INSERT INTO "Room" ("name", "capacity", "location") VALUES
('Room A', 30, 'Building 1'),
('Room B', 20, 'Building 2'),
('Room C', 25, 'Building 3'),
('Room D', 15, 'Building 4');

INSERT INTO "Student" ("personNumber", "name", "address", "email", "siblingId", "levelId") VALUES
('345678901234', 'Alice Johnson', '789 Pine St', 'alice.johnson@example.com', NULL, 1),
('456789012345', 'Bob Brown', '101 Maple St', 'bob.brown@example.com', NULL, 2),
('567890123456', 'Charlie Green', '202 Cedar St', 'charlie.green@example.com', NULL, 3),
('678901234567', 'Diana White', '303 Spruce St', 'diana.white@example.com', NULL, 1);

INSERT INTO "Lesson" ("minimumRequiredStudentCount", "instructorId", "groupSize", "roomId", "startTime", "endTime", "studentId") VALUES
(5, 1, 10, 1, '2023-10-01 09:00:00', '2023-10-01 10:00:00', 1),
(3, 2, 8, 2, '2023-10-01 10:00:00', '2023-10-01 11:00:00', 2),
(4, 3, 12, 3, '2023-10-02 09:00:00', '2023-10-02 10:00:00', 3),
(6, 4, 15, 4, '2023-10-02 10:00:00', '2023-10-02 11:00:00', 4);

INSERT INTO "StudentPayment" ("studentId", "discountPercentage", "paymentDate", "amount") VALUES
(1, 10.0, '2023-09-01', 900.00),
(2, 5.0, '2023-09-01', 950.00),
(3, 15.0, '2023-09-02', 850.00),
(4, 20.0, '2023-09-02', 800.00);

INSERT INTO "RentingInstrument" ("studentId", "rentTime") VALUES
(1, '2023-09-01'),
(2, '2023-09-02'),
(3, '2023-09-03'),
(4, '2023-09-04');

INSERT INTO "AvailableInstrument" ("instrumentType", "rentingInstrumentId") VALUES
('Guitar', 1),
('Piano', 2),
('Violin', 3),
('Drum', 4);

