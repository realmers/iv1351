SET search_path TO public;

CREATE TABLE "PersonalInformation" (
  "id" serial,
  "personNumber" varchar(12) UNIQUE,
  "firstName" varchar(100),
  "lastName" varchar(100),
  "address" varchar(200),
  "email" varchar(100) UNIQUE,
  PRIMARY KEY ("id")
);

CREATE TYPE student_level_enum AS ENUM ('beginner', 'intermediate', 'advanced');

CREATE TABLE "StudentLevel" (
  "id" serial,
  "level" student_level_enum,
  PRIMARY KEY ("id")
);

CREATE TABLE "Student" (
  "id" serial,
  "siblingId" integer,
  "levelId" integer,
  "personalInformationId" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_Student.levelId"
    FOREIGN KEY ("levelId")
      REFERENCES "StudentLevel"("id")
      ON DELETE CASCADE,
  CONSTRAINT "FK_Student.personalInformationId"
    FOREIGN KEY ("personalInformationId")
      REFERENCES "PersonalInformation"("id")
      ON DELETE CASCADE
);

CREATE TABLE "ContactPerson" (
  "id" serial,
  "studentId" integer,
  "personalInformationId" integer,
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
  "personalInformationId" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_Instructor.personalInformationId"
    FOREIGN KEY ("personalInformationId")
      REFERENCES "PersonalInformation"("id")
      ON DELETE CASCADE
);

CREATE TABLE "AvailableTimeSlot" (
  "id" serial,
  "timeslot" timestamp,
  "instructorId" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_AvailableTimeSlot.instructorId"
    FOREIGN KEY ("instructorId")
      REFERENCES "Instructor"("id")
      ON DELETE CASCADE
);

CREATE TABLE "InstructorPayment" (
  "id" serial,
  "paymentDate" date,
  "amount" real,
  "instructorId" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_InstructorPayment.instructorId"
    FOREIGN KEY ("instructorId")
      REFERENCES "Instructor"("id")
      ON DELETE CASCADE
);

CREATE TABLE "Room" (
  "id" serial,
  "name" text,
  "capacity" integer,
  "location" text,
  PRIMARY KEY ("id")
);


CREATE TABLE "LessonCapacity" (
  "id" serial,
  "minimumAmountOfStudents" integer,
  "maximumAmountOfStudents" integer,
  PRIMARY KEY ("id")
);

CREATE TABLE "PricingScheme" (
  "id" serial,
  "price" decimal(10,2),
  "validFrom" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "validTo" timestamp,
  PRIMARY KEY ("id"),
  CHECK ("validTo" IS NULL OR "validTo" > "validFrom")
);

CREATE TABLE "Lesson" (
  "id" serial,
  "currentAmountOfStudents" integer,
  "instructorId" integer,
  "roomId" integer,
  "startTime" timestamp,
  "endTime" timestamp,
  "studentId" integer,
  "levelId" integer,
  "pricingSchemeId" integer UNIQUE NOT NULL,
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
  CONSTRAINT "FK_Lesson.levelId"
    FOREIGN KEY ("levelId")
      REFERENCES "StudentLevel"("id")
      ON DELETE CASCADE,
  CONSTRAINT "FK_Lesson.pricingSchemeId"
    FOREIGN KEY ("pricingSchemeId")
      REFERENCES "PricingScheme"("id")
      ON DELETE CASCADE
);

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
  "genre" varchar(32),
  "lessonCapacityId" integer,
  "lessonId" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_Ensemble.lessonCapacityId"
    FOREIGN KEY ("lessonCapacityId")
      REFERENCES "LessonCapacity"("id")
      ON DELETE CASCADE,
  CONSTRAINT "FK_Individual.lessonId"
    FOREIGN KEY ("lessonId")
      REFERENCES "Lesson"("id")
      ON DELETE CASCADE
);

CREATE TABLE "Group" (
  "id" serial,
  "lessonCapacityId" integer,
  "lessonId" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_Group.lessonCapacityId"
    FOREIGN KEY ("lessonCapacityId")
      REFERENCES "LessonCapacity"("id")
      ON DELETE CASCADE,
  CONSTRAINT "FK_Individual.lessonId"
    FOREIGN KEY ("lessonId")
      REFERENCES "Lesson"("id")
      ON DELETE CASCADE
);

-- Trigger function: check_lesson_type
-- Purpose: Ensures correct lesson type and reference combinations
-- When: Runs before INSERT or UPDATE on Lesson table
-- What it does: Raises an exception if the lesson type and references are not consistent
CREATE OR REPLACE FUNCTION check_lesson_type()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW."lessonType" = 'individual' AND EXISTS (SELECT 1 FROM "GroupLesson" WHERE "lessonId" = NEW."id") THEN
        RAISE EXCEPTION 'Individual lesson cannot have a group lesson reference';
    ELSIF NEW."lessonType" = 'individual' AND EXISTS (SELECT 1 FROM "EnsembleLesson" WHERE "lessonId" = NEW."id") THEN
        RAISE EXCEPTION 'Individual lesson cannot have an ensemble lesson reference';
    ELSIF NEW."lessonType" = 'group' AND NOT EXISTS (SELECT 1 FROM "GroupLesson" WHERE "lessonId" = NEW."id") THEN
        RAISE EXCEPTION 'Group lesson must have a group lesson reference';
    ELSIF NEW."lessonType" = 'group' AND EXISTS (SELECT 1 FROM "EnsembleLesson" WHERE "lessonId" = NEW."id") THEN
        RAISE EXCEPTION 'Group lesson cannot have an ensemble lesson reference';
    ELSIF NEW."lessonType" = 'ensemble' AND NOT EXISTS (SELECT 1 FROM "EnsembleLesson" WHERE "lessonId" = NEW."id") THEN
        RAISE EXCEPTION 'Ensemble lesson must have an ensemble lesson reference';
    ELSIF NEW."lessonType" = 'ensemble' AND EXISTS (SELECT 1 FROM "GroupLesson" WHERE "lessonId" = NEW."id") THEN
        RAISE EXCEPTION 'Ensemble lesson cannot have a group lesson reference';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_lesson_type
BEFORE INSERT OR UPDATE ON "Lesson"
FOR EACH ROW
EXECUTE FUNCTION check_lesson_type();

-- Trigger function: check_group_lesson_enrollment
-- Purpose: Prevents scheduling group lessons that don't meet minimum student requirements
-- When: Runs before INSERT or UPDATE on Lesson table
-- What it does: Raises an exception if trying to create/modify a group lesson
--              with fewer students than the minimum required for that group
CREATE OR REPLACE FUNCTION check_group_lesson_enrollment()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW."lessonType" = 'group' AND NEW."currentAmountOfStudents" < (
        SELECT "minimumAmountOfStudents"
        FROM "LessonCapacity"
        WHERE "id" = (
          SELECT "lessonCapacityId"
          FROM "Group"
          WHERE "id" = NEW."GroupId"
        )
    ) THEN
        RAISE EXCEPTION 'Group lesson cannot be scheduled with fewer students than the minimum requirement';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_group_lesson_minimum
BEFORE INSERT OR UPDATE ON "Lesson"
FOR EACH ROW
EXECUTE FUNCTION check_group_lesson_enrollment();

-- Pricing constraints:
-- Ensures end date is always after start date for pricing periods
CREATE TABLE "StudentPayment" (
  "id" serial,
  "studentId" integer,
  "discountPercentage" real,
  "paymentDate" date,
  "amount" real,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_StudentPayment.studentId"
    FOREIGN KEY ("studentId")
      REFERENCES "Student"("id")
      ON DELETE CASCADE
);

-- Renting constraints:
-- 1. Ensures rental end date is after start date
-- 2. Limits rental duration to maximum of 12 months
CREATE TABLE "RentingInstrument" (
  "id" serial,
  "studentId" integer,
  "startTime" timestamp,
  "endTime" timestamp,
  "monthlyFee" decimal(10,2),
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_RentingInstrument.studentId"
    FOREIGN KEY ("studentId")
      REFERENCES "Student"("id")
      ON DELETE CASCADE,
  CHECK ("endTime" > "startTime"),
  CHECK (
    EXTRACT(YEAR FROM AGE("endTime", "startTime")) * 12 +
    EXTRACT(MONTH FROM AGE("endTime", "startTime")) <= 12
  )
);

CREATE TABLE "AvailableInstrument" (
  "id" serial,
  "instrumentType" varchar(50),
  "instrumentBrand" varchar(50),
  "instrumentQuantity" integer,
  "rentingInstrumentId" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_AvailableInstrument.rentingInstrumentId"
    FOREIGN KEY ("rentingInstrumentId")
      REFERENCES "RentingInstrument"("id")
      ON DELETE CASCADE,
  CHECK ("instrumentQuantity" >= 0)
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
        JOIN "AvailableInstrument" ai ON ri."id" = ai."rentingInstrumentId"
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

