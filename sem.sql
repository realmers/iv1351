-- 1. Project Description, the Soundgood Music School
-- The purpose is to facilitate information handling and business transactions for the Soundgood music school company, by developing a database which handles all the school's data and also an application that handles the operations specified in sections 1.1-1.3.
-- 1.1 Business Overview
-- Soundgood sells music lessons to students who want to learn to play an instrument. When someone wants to attend the school, they submit contact details, which instrument they want to learn, and their present skill. If there is room, the student is offered a place. There is no concept like 'course' or sets of lessons. Instead, students continue to take lessons as long as they wish. Students pay per lesson and instructors are payed per given lesson.
-- 1.2 Detailed Descriptions
-- Lesson
-- There are individual lessons and group lessons. A group lesson has a specified number of places (which may vary), and is not given unless a minimum number of students enroll. A lesson is given for a particular instrument and a particular level. There are three levels, beginner, intermediate and advanced. Besides lessons for a particular instrument, there are also ensembles, where students playing different instruments participate at the same lesson. Ensembles have a specific target genre (e.g., punk rock, gospel band), and there is a maximum and minimum number of students also for ensembles.
-- Group lessons and ensembles are given at scheduled time slots. Individual lessons do not have a fixed schedule, but are rather to be seen as appointments, like for example an appointment with a dentist. Administrative staff must be able to make bookings, it must therefore be possible to understand which instructor is available when, and for which instruments.
-- There is no concept like 'course' or sets of lessons, a student who has been offered a place, and accepted, continue to take lessons as long as desired, and can either book one lesson at the time or book many lessons during a longer time period.
-- Student
-- A student can take any number of lessons, for any number of instruments. Person number, name, address and contact details must be stored for each student. It must also be possible to store contact details for a contact person (e.g., parent) for each student. Furthermore, it must be possible to see which students are siblings, since there is a discount for siblings. It's not sufficient to show just whether a student has siblings, it must be possible to see who's a sibling of who.
-- Instructor
-- An instructor can be assigned to group lessons and ensembles, and can also be available to give individual lessons during specified time periods. An instructor can teach a specified set of instruments, and may also be able to teach ensembles. Person number, name, address and contact details must be stored for each instructor. 
-- Student Payment
-- Students are charged monthly for all lessons taken during the previous month. Currently, there is one price for beginner and intermediate levels, and another price for the advanced level. Also, there are different prices for individual lessons, group lessons and ensembles. There is also a discount for siblings, if two or more siblings have taken lessons during the same month, they all get a certain percentage discount. Soundgood wants to have a high level of flexibility to change not just prices, but also pricing scheme. They might, for example, not always have the same price for beginner and intermediate lessons.
-- Instructor Payment
-- There are no instructors with fixed monthly salaries, instead they are payed monthly for all lessons given during the previous month. Instructor payments depend on the same things as student fees (see above), namely level of lesson and whether a given lesson was a group or individual lesson. Instructor payments are not affected by sibling discounts.
-- Renting Instruments
-- Soundgood offers students the ability to rent instruments to be delivered at their home. There is a wide selection of instruments, wind, string etc., supporting different brands and in different quantities in stock at the soundgood music school. Each student can rent up to two specific instruments at any given period, the renting happens with a lease up to 12 month period. Students can list and search current instruments and rent them if they don't exceed their two-instrument quota. Instruments are rented per month. The fee is payed the same way lessons are payed, each month students are charged for the instruments that where rented the previous month.
-- 1.3 Requirements on the Soundgood Music School Application
-- The database must store all data described above, in sections 1.1 and 1.2, but no other data. There will also be an application providing a user interface which can be used by administrative staff to manage student enrollments, instrument rentals, bookings and payments. In addition, the database will also be used to retrieve reports and statistics of all possible kinds, but a user interface is not required for that purpose. It will instead be done by manually querying the database.
-- The database will not be used for any financial purpose like bookkeeping, taxes or bank contacts. What is written above regarding student fees and instructor payments is only about calculating what sum shall be payed to or by who, and sending that information to Soundgood's financial system.

SET search_path TO public;

CREATE TABLE "PersonalInformation" (
  "id" serial,
  "personNumber" varchar(12) UNIQUE NOT NULL,
  "firstName" varchar(100) NOT NULL,
  "lastName" varchar(100) NOT NULL,
  "address" varchar(200) NOT NULL,
  "email" varchar(100) UNIQUE NOT NULL,
  PRIMARY KEY ("id")
);

CREATE TABLE "Student" (
  "id" serial,
  "siblingId" integer,
  "personalInformationId" integer NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_Student.personalInformationId"
    FOREIGN KEY ("personalInformationId")
      REFERENCES "PersonalInformation"("id")
      ON DELETE CASCADE,
  CONSTRAINT "FK_Student.siblingId"
    FOREIGN KEY ("siblingId")
      REFERENCES "Student"("id")
      ON DELETE SET NULL
);



CREATE TABLE "ContactPerson" (
  "id" serial,
  "studentId" integer NOT NULL,
  "personalInformationId" integer NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_ContactPerson.studentId"
    FOREIGN KEY ("studentId")
      REFERENCES "Student"("id")
      ON DELETE CASCADE,
  CONSTRAINT "FK_ContactPerson.personalInformationId"
    FOREIGN KEY ("personalInformationId")
      REFERENCES "PersonalInformation"("id")
      ON DELETE CASCADE
);

CREATE TABLE "Instructor" (
  "id" serial,
  "personalInformationId" integer NOT NULL,
  "canTeachEnsemble" boolean NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_Instructor.personalInformationId"
    FOREIGN KEY ("personalInformationId")
      REFERENCES "PersonalInformation"("id")
      ON DELETE CASCADE
);

CREATE TABLE "AvailableTimeSlot" (
  "id" serial,
  "timeslot" timestamp NOT NULL,
  "instructorId" integer NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_AvailableTimeSlot.instructorId"
    FOREIGN KEY ("instructorId")
      REFERENCES "Instructor"("id")
      ON DELETE CASCADE
);

CREATE TABLE "Room" (
  "id" serial,
  "name" text NOT NULL,
  "capacity" integer NOT NULL,
  "location" text NOT NULL,
  PRIMARY KEY ("id")
);


CREATE TABLE "LessonCapacity" (
  "id" serial,
  "minimumAmountOfStudents" integer NOT NULL,
  "maximumAmountOfStudents" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE TYPE "lessonType" AS ENUM ('individual', 'group', 'ensemble');
CREATE TYPE "lessonLevel" AS ENUM ('beginner', 'intermediate', 'advanced');

CREATE TABLE "PricingScheme" (
  "id" serial,
  "amount" decimal(10,2) NOT NULL,
  "validFrom" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "validTo" timestamp,
  "lessonType" "lessonType" NOT NULL,
  "discountPercentage" decimal(2,2),
  "paymentDate" timestamp,
  "lessonLevel" "lessonLevel" NOT NULL,
  PRIMARY KEY ("id"),
  CHECK ("validTo" IS NULL OR "validTo" > "validFrom")
);

CREATE TABLE "Lesson" (
  "id" serial,
  "currentAmountOfStudents" integer NOT NULL,
  "instructorId" integer NOT NULL,
  "roomId" integer NOT NULL,
  "startTime" timestamp NOT NULL,
  "endTime" timestamp NOT NULL,
  "studentId" integer,
  "pricingSchemeId" integer NOT NULL UNIQUE,  
  "lessonType" "lessonType" NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_Lesson.instructorId"
    FOREIGN KEY ("instructorId")
      REFERENCES "Instructor"("id")
      ON DELETE CASCADE,
  CONSTRAINT "FK_Lesson.roomId"
    FOREIGN KEY ("roomId")
      REFERENCES "Room"("id")
      ON DELETE CASCADE,
  CONSTRAINT "FK_Lesson.studentId"
    FOREIGN KEY ("studentId")
      REFERENCES "Student"("id")
      ON DELETE CASCADE,
  CONSTRAINT "FK_Lesson.pricingSchemeId"
    FOREIGN KEY ("pricingSchemeId")
      REFERENCES "PricingScheme"("id")
      ON DELETE CASCADE
);

-- Add check constraints after the Lesson table is created
CREATE OR REPLACE FUNCTION check_lesson_type() 
RETURNS TRIGGER AS $$
BEGIN
    -- Get the lesson type from the inserted/updated record
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        IF NEW."lessonType"::text = 'individual' AND EXISTS (
            SELECT 1 FROM "Group" g WHERE g."lessonId" = NEW."id"
            UNION
            SELECT 1 FROM "Ensemble" e WHERE e."lessonId" = NEW."id"
        ) THEN
            RAISE EXCEPTION 'Individual lesson cannot be a group or ensemble lesson';
        END IF;

        IF NEW."lessonType"::text = 'group' AND EXISTS (
            SELECT 1 FROM "Individual" i WHERE i."lessonId" = NEW."id"
            UNION
            SELECT 1 FROM "Ensemble" e WHERE e."lessonId" = NEW."id"
        ) THEN
            RAISE EXCEPTION 'Group lesson cannot be an individual or ensemble lesson';
        END IF;

        IF NEW."lessonType"::text = 'ensemble' AND EXISTS (
            SELECT 1 FROM "Individual" i WHERE i."lessonId" = NEW."id"
            UNION
            SELECT 1 FROM "Group" g WHERE g."lessonId" = NEW."id"
        ) THEN
            RAISE EXCEPTION 'Ensemble lesson cannot be an individual or group lesson';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_lesson_type
BEFORE INSERT OR UPDATE ON "Lesson"
FOR EACH ROW
EXECUTE FUNCTION check_lesson_type();

CREATE TABLE "Individual"(
  "id" serial,
  "lessonId" integer UNIQUE,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_Individual.lessonId"
    FOREIGN KEY ("lessonId")
      REFERENCES "Lesson"("id")
      ON DELETE CASCADE
);

CREATE TABLE "Ensemble" (
  "id" serial,
  "genre" varchar(32) NOT NULL,
  "lessonCapacityId" integer,
  "lessonId" integer UNIQUE,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_Ensemble.lessonCapacityId"
    FOREIGN KEY ("lessonCapacityId")
      REFERENCES "LessonCapacity"("id")
      ON DELETE CASCADE,
  CONSTRAINT "FK_Ensemble.lessonId"
    FOREIGN KEY ("lessonId")
      REFERENCES "Lesson"("id")
      ON DELETE CASCADE
);

CREATE TABLE "Group" (
  "id" serial,
  "lessonCapacityId" integer,
  "lessonId" integer UNIQUE,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_Group.lessonCapacityId"
    FOREIGN KEY ("lessonCapacityId")
      REFERENCES "LessonCapacity"("id")
      ON DELETE CASCADE,
  CONSTRAINT "FK_Group.lessonId"
    FOREIGN KEY ("lessonId")
      REFERENCES "Lesson"("id")
      ON DELETE CASCADE
);

-- Add trigger function to validate lesson types
CREATE OR REPLACE FUNCTION validate_lesson_type()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_TABLE_NAME = 'Individual' THEN
        IF NOT EXISTS (SELECT 1 FROM "Lesson" WHERE "id" = NEW."lessonId" AND "lessonType" = 'individual') THEN
            RAISE EXCEPTION 'Lesson must be of type individual';
        END IF;
    ELSIF TG_TABLE_NAME = 'Group' THEN
        IF NOT EXISTS (SELECT 1 FROM "Lesson" WHERE "id" = NEW."lessonId" AND "lessonType" = 'group') THEN
            RAISE EXCEPTION 'Lesson must be of type group';
        END IF;
    ELSIF TG_TABLE_NAME = 'Ensemble' THEN
        IF NOT EXISTS (SELECT 1 FROM "Lesson" WHERE "id" = NEW."lessonId" AND "lessonType" = 'ensemble') THEN
            RAISE EXCEPTION 'Lesson must be of type ensemble';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for each table
CREATE TRIGGER validate_individual_lesson
BEFORE INSERT OR UPDATE ON "Individual"
FOR EACH ROW
EXECUTE FUNCTION validate_lesson_type();

CREATE TRIGGER validate_group_lesson
BEFORE INSERT OR UPDATE ON "Group"
FOR EACH ROW
EXECUTE FUNCTION validate_lesson_type();

CREATE TRIGGER validate_ensemble_lesson
BEFORE INSERT OR UPDATE ON "Ensemble"
FOR EACH ROW
EXECUTE FUNCTION validate_lesson_type();

-- Pricing constraints:
-- Ensures end date is always after start date for pricing periods

-- Renting constraints:
-- 1. Ensures rental end date is after start date
-- 2. Limits rental duration to maximum of 12 months
CREATE TABLE "AvailableInstrument" (
  "id" serial,
  "instrumentType" varchar(50) NOT NULL,
  "instrumentBrand" varchar(50) NOT NULL,
  "instrumentQuantity" integer NOT NULL,
  PRIMARY KEY ("id"),
  CHECK ("instrumentQuantity" >= 0)
);

CREATE TABLE "RentingInstrument" (
  "id" serial,
  "studentId" integer NOT NULL,
  "availableInstrumentId" integer NOT NULL,
  "startTime" timestamp NOT NULL,
  "endTime" timestamp NOT NULL,
  "monthlyFee" decimal(10,2) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_RentingInstrument.studentId"
    FOREIGN KEY ("studentId")
      REFERENCES "Student"("id")
      ON DELETE CASCADE,
  CONSTRAINT "FK_RentingInstrument.availableInstrumentId"
    FOREIGN KEY ("availableInstrumentId")
      REFERENCES "AvailableInstrument"("id")
      ON DELETE CASCADE,
  CHECK ("endTime" > "startTime"),
  CHECK (
    EXTRACT(YEAR FROM AGE("endTime", "startTime")) * 12 +
    EXTRACT(MONTH FROM AGE("endTime", "startTime")) <= 12
  )
);

-- Trigger function: check_instrument_limit
-- Purpose: Enforces the two-instrument rental limit per student
-- When: Runs before INSERT on RentingInstrument table
-- What it does: Counts current active rentals for the student
--              Raises exception if adding another would exceed limit
CREATE OR REPLACE FUNCTION check_instrument_limit()
RETURNS TRIGGER AS $$
BEGIN
    IF (
        SELECT COUNT(*)
        FROM "RentingInstrument" ri
        JOIN "AvailableInstrument" ai ON ri."availableInstrumentId" = ai."id"
        WHERE ri."studentId" = NEW."studentId"
        AND CURRENT_DATE BETWEEN ri."startTime" AND ri."endTime"
    ) >= 2 THEN
        RAISE EXCEPTION 'Student cannot rent more than 2 instruments at the same time';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_instrument_limit
BEFORE INSERT ON "RentingInstrument"
FOR EACH ROW
EXECUTE FUNCTION check_instrument_limit();

-- Trigger function: delete_expired_rentals
-- Purpose: Automatic cleanup of expired instrument rentals
-- When: Runs before INSERT or UPDATE on RentingInstrument table
-- What it does: Removes rental records that have passed their end date
CREATE OR REPLACE FUNCTION delete_expired_rentals()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM "RentingInstrument"
    WHERE "endTime" < CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER cleanup_expired_rentals
BEFORE INSERT OR UPDATE ON "RentingInstrument"
FOR EACH ROW
EXECUTE FUNCTION delete_expired_rentals();

