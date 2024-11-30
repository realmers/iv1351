--- PostgresSQL
-- Only INSERT statements are allowed in this file

-- Insert dummy data into PersonalInformation with explicit IDs
INSERT INTO "PersonalInformation" ("id", "personNumber", "firstName", "lastName", "address", "email") VALUES
(1, '123456789012', 'John', 'Doe', '123 Main St', 'john.doe@example.com'),
(2, '234567890123', 'Jane', 'Smith', '456 Elm St', 'jane.smith@example.com'),
(3, '345678901234', 'Alice', 'Johnson', '789 Pine St', 'alice.johnson@example.com'),
(4, '456789012345', 'Bob', 'Brown', '101 Maple St', 'bob.brown@example.com'),
(5, '567890123456', 'Charlie', 'Davis', '202 Birch St', 'charlie.davis@example.com'),
(6, '678901234567', 'Diana', 'Evans', '303 Cedar St', 'diana.evans@example.com');

-- Insert dummy data into Student with explicit IDs
INSERT INTO "Student" ("id", "personalInformationId") VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);


-- Insert dummy data into Instructor with explicit IDs
INSERT INTO "Instructor" ("id", "personalInformationId", "canTeachEnsemble") VALUES
(1, 1, true),
(2, 2, false),
(3, 3, true),
(4, 4, false),
(5, 5, true),
(6, 6, false);


-- Insert dummy data into Room with explicit IDs
INSERT INTO "Room" ("id", "name", "capacity", "location") VALUES
(1, 'Room A', 30, 'Building 1'),
(2, 'Room B', 20, 'Building 2'),
(3, 'Room C', 25, 'Building 3'),
(4, 'Room D', 15, 'Building 4'),
(5, 'Room E', 35, 'Building 5'),
(6, 'Room F', 10, 'Building 6');


-- Insert historical pricing data first with explicit IDs
INSERT INTO "PricingScheme" ("id", "amount", "validFrom", "validTo", "lessonType", "discountPercentage", "paymentDate", "lessonLevel") VALUES
(1, 300.00, '2023-01-01 00:00:00', '2023-07-01 00:00:00', 'individual', 0.00, '2023-01-01 00:00:00', 'beginner'),
(2, 350.00, '2023-07-01 00:00:00', '2023-10-01 00:00:00', 'group', 0.00, '2023-07-01 00:00:00', 'intermediate'),
(3, 400.00, '2023-10-01 00:00:00', '2023-12-01 00:00:00', 'ensemble', 0.00, '2024-10-01 00:00:00', 'advanced'),
(4, 320.00, '2023-01-01 00:00:00', '2023-07-01 00:00:00', 'individual', 0.00, '2023-01-01 00:00:00', 'intermediate'),
(5, 370.00, '2023-07-01 00:00:00', '2023-10-01 00:00:00', 'group', 0.00, '2023-07-01 00:00:00', 'advanced'),
(6, 420.00, '2023-10-01 00:00:00', '2023-12-01 00:00:00', 'ensemble', 0.00, '2024-10-01 00:00:00', 'beginner'),
(7, 340.00, '2023-01-01 00:00:00', '2023-07-01 00:00:00', 'individual', 0.00, '2023-01-01 00:00:00', 'advanced'),
(8, 360.00, '2023-07-01 00:00:00', '2023-10-01 00:00:00', 'group', 0.00, '2023-07-01 00:00:00', 'beginner'),
(9, 410.00, '2023-10-01 00:00:00', '2023-12-01 00:00:00', 'ensemble', 0.00, '2024-10-01 00:00:00', 'intermediate'),
(10, 330.00, '2023-01-01 00:00:00', '2023-07-01 00:00:00', 'individual', 0.00, '2023-01-01 00:00:00', 'beginner');

-- Insert dummy data into Lesson with various dates and types
INSERT INTO "Lesson" ("id", "currentAmountOfStudents", "instructorId", "roomId", "startTime", "endTime", "studentId", "pricingSchemeId", "lessonType") VALUES
-- October lessons
(1, 1, 1, 1, '2023-10-01 09:00:00', '2023-10-01 10:00:00', 1, 3, 'ensemble'),
(2, 3, 2, 2, '2023-10-15 11:00:00', '2023-10-15 12:00:00', 2, 6, 'ensemble'),
-- November lessons
(3, 4, 3, 3, '2023-11-03 09:00:00', '2023-11-03 10:00:00', 3, 2, 'group'),
(4, 5, 4, 4, '2023-11-14 11:00:00', '2023-11-14 12:00:00', 4, 5, 'group'),
(5, 1, 5, 5, '2023-11-25 09:00:00', '2023-11-25 10:00:00', 5, 1, 'individual'),
-- December lessons
(6, 1, 6, 6, '2023-12-01 11:00:00', '2023-12-01 12:00:00', 6, 4, 'individual'),
(7, 1, 1, 1, '2023-12-05 09:00:00', '2023-12-05 10:00:00', 1, 7, 'individual'),
(8, 4, 2, 2, '2023-12-10 11:00:00', '2023-12-10 12:00:00', 2, 8, 'group'),
(9, 1, 3, 3, '2023-12-15 09:00:00', '2023-12-15 10:00:00', 3, 9, 'individual'),
(10, 1, 4, 4, '2023-12-20 11:00:00', '2023-12-20 12:00:00', 4, 10, 'individual');

-- Add Individual lessons
INSERT INTO "Individual" ("id", "lessonId") VALUES
(1, 5),
(2, 6),
(3, 7),
(4, 9),
(5, 10);

-- Insert ensemble data first
INSERT INTO "LessonCapacity" ("id", "minimumAmountOfStudents", "maximumAmountOfStudents") VALUES
(1, 1, 3), 
(2, 3, 10), 
(3, 4, 7),
(4, 2, 6);

INSERT INTO "Ensemble" ("id", "genre", "lessonCapacityId", "lessonId") VALUES
(1, 'Classical', 1, 1),
(2, 'Jazz', 2, 2);

-- Insert group lesson configurations
INSERT INTO "LessonCapacity" ("id", "minimumAmountOfStudents", "maximumAmountOfStudents") VALUES
(5, 2, 5), 
(6, 3, 8), 
(7, 4, 10);

-- Adjust Group data to match model
INSERT INTO "Group" ("id", "lessonCapacityId", "lessonId") VALUES
(1, 5, 3),
(2, 6, 4),
(3, 7, 8);

-- Insert dummy data into RentingInstrument with updated fields
INSERT INTO "RentingInstrument" ("id", "studentId", "startTime", "endTime", "monthlyFee") VALUES
(1, 1, '2023-10-01', '2024-04-01', 150.00),
(2, 2, '2023-10-02', '2024-03-02', 200.00),
(3, 3, '2023-10-03', '2024-02-03', 175.00),
(4, 4, '2023-10-04', '2024-01-04', 225.00),
(5, 5, '2023-10-05', '2024-05-05', 190.00),
(6, 6, '2023-10-06', '2024-06-06', 160.00);

-- First insert the available instruments without rental references
INSERT INTO "AvailableInstrument" ("id", "instrumentType", "instrumentBrand", "instrumentQuantity", "rentingInstrumentId") VALUES
(1, 'Guitar', 'Yamaha', 5, NULL),
(2, 'Piano', 'Steinway', 2, NULL),
(3, 'Violin', 'Stradivarius', 3, NULL),
(4, 'Drum', 'Pearl', 4, NULL),
(5, 'Flute', 'Armstrong', 6, NULL),
(6, 'Saxophone', 'Selmer', 3, NULL);

-- Insert dummy data into AvailableTimeSlot
INSERT INTO "AvailableTimeSlot" ("id", "timeslot", "instructorId") VALUES
(1, '2023-10-01 09:00:00', 1),
(2, '2023-10-02 11:00:00', 2),
(3, '2023-10-03 09:00:00', 3),
(4, '2023-10-04 11:00:00', 4),
(5, '2023-10-05 09:00:00', 5),
(6, '2023-10-06 11:00:00', 6);

-- Insert dummy data into ContactPerson
INSERT INTO "ContactPerson" ("id", "studentId", "personalInformationId") VALUES
(1, 1, 2),
(2, 2, 1),
(3, 3, 4),
(4, 4, 3),
(5, 5, 6),
(6, 6, 5);

