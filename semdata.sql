--- PostgresSQL

-- Insert dummy data into PersonalInformation
INSERT INTO "PersonalInformation" ("personNumber", "firstName", "lastName", "address", "email") VALUES
('123456789012', 'John', 'Doe', '123 Main St', 'john.doe@example.com'),
('234567890123', 'Jane', 'Smith'  '456 Elm St', 'jane.smith@example.com'),
('345678901234', 'Alice', 'Johnson', '789 Pine St', 'alice.johnson@example.com'),
('456789012345', 'Bob', 'Brown', '101 Maple St', 'bob.brown@example.com'),
('567890123456', 'Charlie', 'Davis', '202 Birch St', 'charlie.davis@example.com'),
('678901234567', 'Diana', 'Evans', '303 Cedar St', 'diana.evans@example.com');

-- Insert dummy data into StudentLevel
INSERT INTO "StudentLevel" ("level") VALUES
('beginner'),
('intermediate'),
('advanced');

-- Insert dummy data into Student
INSERT INTO "Student" ("siblingId", "levelId", "personalInformationId") VALUES
(NULL, 1, 1),
(NULL, 2, 2),
(NULL, 3, 3),
(NULL, 1, 4),
(NULL, 2, 5),
(NULL, 3, 6);

-- Insert dummy data into Instructor
INSERT INTO "Instructor" ("personalInformationId") VALUES
(1),
(2),
(3),
(4),
(5),
(6);

-- Insert dummy data into Room
INSERT INTO "Room" ("name", "capacity", "location") VALUES
('Room A', 30, 'Building 1'),
('Room B', 20, 'Building 2'),
('Room C', 25, 'Building 3'),
('Room D', 15, 'Building 4'),
('Room E', 35, 'Building 5'),
('Room F', 10, 'Building 6');

-- Insert ensemble data first
INSERT INTO "Ensemble" ("genre", "minimumAmountOfStudents", "maximumAmountOfStudents") VALUES
('Classical', 1, 3),
('Jazz', 3, 10),
('Rock', 4, 7),
('Pop', 2, 6);

-- Insert dummy data into Lesson with various dates and types
INSERT INTO "Lesson" ("currentAmountOfStudents", "instructorId", "roomId", "startTime", "endTime", "studentId", "levelId", "lessonType", "ensembleId") VALUES
-- October lessons
(1, 1, 1, '2023-10-01 09:00:00', '2023-10-01 10:00:00', 1, 1, 'individual', NULL),
(3, 2, 2, '2023-10-15 11:00:00', '2023-10-15 12:00:00', 2, 2, 'ensemble', 1),
-- November lessons
(4, 3, 3, '2023-11-03 09:00:00', '2023-11-03 10:00:00', 3, 3, 'group', NULL),
(5, 4, 4, '2023-11-14 11:00:00', '2023-11-14 12:00:00', 4, 1, 'group', NULL),
(6, 5, 5, '2023-11-25 09:00:00', '2023-11-25 10:00:00', 5, 2, 'ensemble', 2),
-- December lessons
(1, 6, 6, '2023-12-01 11:00:00', '2023-12-01 12:00:00', 6, 3, 'individual', NULL),
(1, 1, 1, '2023-12-05 09:00:00', '2023-12-05 10:00:00', 1, 1, 'individual', NULL),
(4, 2, 2, '2023-12-10 11:00:00', '2023-12-10 12:00:00', 2, 2, 'group', NULL),
(5, 3, 3, '2023-12-15 09:00:00', '2023-12-15 10:00:00', 3, 3, 'ensemble', 3),
(1, 4, 4, '2023-12-20 11:00:00', '2023-12-20 12:00:00', 4, 1, 'individual', NULL);

-- Insert dummy data into InstructorPayment
INSERT INTO "InstructorPayment" ("paymentDate", "amount", "instructorId") VALUES
('2023-10-01', 1000.00, 1),
('2023-10-02', 1200.00, 2),
('2023-10-03', 1100.00, 3),
('2023-10-04', 1300.00, 4),
('2023-10-05', 1400.00, 5),
('2023-10-06', 1500.00, 6);

-- Insert dummy data into StudentPayment
INSERT INTO "StudentPayment" ("studentId", "discountPercentage", "paymentDate", "amount") VALUES
(1, 10.0, '2023-10-01', 500.00),
(2, 15.0, '2023-10-02', 600.00),
(3, 20.0, '2023-10-03', 700.00),
(4, 5.0, '2023-10-04', 400.00),
(5, 25.0, '2023-10-05', 800.00),
(6, 30.0, '2023-10-06', 900.00);

-- Insert dummy data into RentingInstrument
INSERT INTO "RentingInstrument" ("studentId", "rentTime", "maxRentableInstrumentCount") VALUES
(1, '2023-10-01', 2),
(2, '2023-10-02', 2),
(3, '2023-10-03', 2),
(4, '2023-10-04', 2),
(5, '2023-10-05', 2),
(6, '2023-10-06', 2);

-- Insert dummy data into AvailableInstrument
INSERT INTO "AvailableInstrument" ("instrumentType", "rentingInstrumentId") VALUES
('Guitar', 1),
('Piano', 2),
('Violin', 3),
('Drum', 4),
('Flute', 5),
('Saxophone', 6);

-- Insert dummy data into AvailableTimeSlot
INSERT INTO "AvailableTimeSlot" ("timeslot", "instructorId") VALUES
('2023-10-01 09:00:00', 1),
('2023-10-02 11:00:00', 2),
('2023-10-03 09:00:00', 3),
('2023-10-04 11:00:00', 4),
('2023-10-05 09:00:00', 5),
('2023-10-06 11:00:00', 6);

-- Insert dummy data into ContactPerson
INSERT INTO "ContactPerson" ("studentId", "personalInformationId") VALUES
(1, 2),
(2, 1),
(3, 4),
(4, 3),
(5, 6),
(6, 5);
