--- PostgresSQL

-- Insert dummy data into PersonalInformation
INSERT INTO "PersonalInformation" ("id", "personNumber", "firstName", "lastName", "address", "email") VALUES
(1, '123456789012', 'John', 'Doe', '123 Main St', 'john.doe@example.com'),
(2, '234567890123', 'Jane', 'Smith', '456 Elm St', 'jane.smith@example.com'),
(3, '345678901234', 'Alice', 'Johnson', '789 Pine St', 'alice.johnson@example.com'),
(4, '456789012345', 'Bob', 'Brown', '101 Maple St', 'bob.brown@example.com'),
(5, '567890123456', 'Charlie', 'Davis', '202 Birch St', 'charlie.davis@example.com'),
(6, '678901234567', 'Diana', 'Evans', '303 Cedar St', 'diana.evans@example.com');

-- Insert dummy data into Instructor
INSERT INTO "Instructor" ("id", "personalInformationId", "canTeachEnsemble") VALUES
(1, 1, true),
(2, 2, false),
(3, 3, true),
(4, 4, false),
(5, 5, true),
(6, 6, false);

-- Insert dummy data into Room
INSERT INTO "Room" ("id", "name", "capacity", "location") VALUES
(1, 'Room A', 30, 'Building 1'),
(2, 'Room B', 20, 'Building 2'),
(3, 'Room C', 25, 'Building 3'),
(4, 'Room D', 15, 'Building 4'),
(5, 'Room E', 35, 'Building 5'),
(6, 'Room F', 10, 'Building 6');

-- Insert dummy data into Lesson
INSERT INTO "Lesson" ("id", "currentAmountOfStudents", "instructorId", "roomId", "startTime", "endTime", "lessonType") VALUES
-- October lessons
(1, 1, 1, 1, '2024-10-01 09:00:00', '2024-10-01 10:00:00', 'ensemble'),
(2, 3, 2, 2, '2024-10-15 11:00:00', '2024-10-15 12:00:00', 'ensemble'),
-- November lessons
(3, 4, 3, 3, '2024-11-03 09:00:00', '2024-11-03 10:00:00', 'group'),
(4, 5, 4, 4, '2024-11-14 11:00:00', '2024-11-14 12:00:00', 'group'),
(5, 1, 5, 5, '2024-11-25 09:00:00', '2024-11-25 10:00:00', 'individual'),
-- December lessons
(6, 1, 6, 6, '2024-12-01 11:00:00', '2024-12-01 12:00:00', 'individual'),
(7, 1, 1, 1, '2024-12-05 09:00:00', '2024-12-05 10:00:00', 'individual'),
(8, 4, 2, 2, '2024-12-10 11:00:00', '2024-12-10 12:00:00', 'group'),
(9, 1, 3, 3, '2024-12-15 09:00:00', '2024-12-15 10:00:00', 'individual'),
(10, 1, 4, 4, '2024-12-20 11:00:00', '2024-12-20 12:00:00', 'individual'),
(11, 1, 1, 1, '2024-12-21 09:00:00', '2024-12-21 10:00:00', 'individual'),
(12, 1, 1, 1, '2024-12-22 09:00:00', '2024-12-22 10:00:00', 'individual'),
(13, 1, 2, 2, '2024-12-21 11:00:00', '2024-12-21 12:00:00', 'individual'),
(14, 1, 2, 2, '2024-12-22 11:00:00', '2024-12-22 12:00:00', 'individual'),
(15, 4, 3, 3, '2024-12-21 13:00:00', '2024-12-21 14:00:00', 'group'),
(16, 3, 3, 3, '2024-12-22 13:00:00', '2024-12-22 14:00:00', 'ensemble'),
(17, 6, 1, 1, '2024-12-03 18:00:00', '2024-12-02 20:00:00', 'ensemble'),
(18, 2, 2, 1, '2024-12-04 10:00:00', '2024-12-03 11:00:00', 'ensemble'),
(19, 8, 2, 1, '2024-12-05 10:00:00', '2024-12-03 11:00:00', 'ensemble');

-- Insert dummy data into Student
INSERT INTO "Student" ("id", "personalInformationId", "siblingId", "lessonId") VALUES
(1, 1, 1, 1), 
(2, 2, 2, 2),
(3, 3, 3, 3), 
(4, 4, 3, 4), 
(5, 5, 2, 5),
(6, 6, 2, 6);

-- Insert PricingScheme data with updated structure
INSERT INTO "PricingScheme" ("id", "validFrom", "validTo", "lessonLevel", "lessonId", "discountPercentage") VALUES
(1, '2024-01-01 00:00:00', '2024-07-01 00:00:00', 'beginner', 5, 0.00),
(2, '2024-07-01 00:00:00', '2024-10-01 00:00:00', 'intermediate', 3, 0.00),
(3, '2024-10-01 00:00:00', '2024-12-01 00:00:00', 'advanced', 1, 0.00),
(4, '2024-01-01 00:00:00', '2024-07-01 00:00:00', 'intermediate', 6, 0.00),
(5, '2024-07-01 00:00:00', '2024-10-01 00:00:00', 'advanced', 4, 0.00),
(6, '2024-10-01 00:00:00', '2024-12-01 00:00:00', 'beginner', 2, 0.00);

-- First insert the available instruments
INSERT INTO "AvailableInstrument" ("id", "instrumentType", "instrumentBrand", "instrumentQuantity") VALUES
(1, 'Guitar', 'Yamaha', 5),
(2, 'Piano', 'Steinway', 2),
(3, 'Violin', 'Stradivarius', 3),
(4, 'Drum', 'Pearl', 4),
(5, 'Flute', 'Armstrong', 6),
(6, 'Saxophone', 'Selmer', 3);

-- Insert dummy data into RentingInstrument
INSERT INTO "RentingInstrument" ("id", "studentId", "availableInstrumentId", "startTime", "endTime") VALUES
(1, 1, 1, '2024-10-01', '2025-04-01'),
(2, 2, 2, '2024-10-02', '2025-03-02'),
(3, 3, 3, '2024-10-03', '2025-02-03'),
(4, 4, 4, '2024-10-04', '2025-01-04'),
(5, 5, 5, '2024-10-05', '2025-05-05'),
(6, 6, 6, '2024-10-06', '2025-06-06');

-- Add MonthlyFee records
INSERT INTO "MonthlyFee" ("id", "amount", "paymentDate", "PricingSchemeId", "RentingInstrumentId") VALUES
(1, 300.00, '2024-01-01 00:00:00', 1, 1),
(2, 350.00, '2024-07-01 00:00:00', 2, 2),
(3, 400.00, '2024-10-01 00:00:00', 3, 3),
(4, 320.00, '2024-01-01 00:00:00', 4, 4),
(5, 370.00, '2024-07-01 00:00:00', 5, 5),
(6, 420.00, '2024-10-01 00:00:00', 6, 6);

-- Add Individual lessons
INSERT INTO "Individual" ("id", "lessonId") VALUES
(1, 5),
(2, 6),
(3, 7),
(4, 9),
(5, 10),
(6, 11),
(7, 12),
(8, 13),
(9, 14);

-- Insert ensemble data first
INSERT INTO "LessonCapacity" ("id", "minimumAmountOfStudents", "maximumAmountOfStudents") VALUES
(1, 1, 3), 
(2, 3, 10), 
(3, 4, 7),
(4, 2, 6),
(5, 2, 5),
(6, 3, 8), 
(7, 4, 10),
(8, 3, 8),
(9, 3, 8);

INSERT INTO "Ensemble" ("id", "genre", "lessonCapacityId", "lessonId") VALUES
(1, 'Classical', 1, 1),
(2, 'Jazz', 2, 2),
(3, 'Rock', 1, 16),
(4, 'Rock', 8, 17),
(5, 'Pop', 2, 18),
(6, 'Jazz', 9, 19);

-- Adjust Group data to match model
INSERT INTO "Group" ("id", "lessonCapacityId", "lessonId") VALUES
(1, 5, 3),
(2, 6, 4),
(3, 7, 8),
(4, 5, 15);

-- Insert dummy data into AvailableTimeSlot
INSERT INTO "AvailableTimeSlot" ("id", "timeslot", "instructorId") VALUES
(1, '2024-10-01 09:00:00', 1),
(2, '2024-10-02 11:00:00', 2),
(3, '2024-10-03 09:00:00', 3),
(4, '2024-10-04 11:00:00', 4),
(5, '2024-10-05 09:00:00', 5),
(6, '2024-10-06 11:00:00', 6);

-- Insert dummy data into ContactPerson
INSERT INTO "ContactPerson" ("id", "studentId", "personalInformationId") VALUES
(1, 1, 2),
(2, 2, 1),
(3, 3, 4),
(4, 4, 3),
(5, 5, 6),
(6, 6, 5);

