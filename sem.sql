SET search_path TO public;

CREATE TYPE "lessonType" AS ENUM ('individual', 'group', 'ensemble');
CREATE TYPE "lessonLevel" AS ENUM ('beginner', 'intermediate', 'advanced');

CREATE TABLE "PersonalInformation" (
  "id" serial,
  "personNumber" varchar(12) UNIQUE NOT NULL,
  "firstName" varchar(100) NOT NULL,
  "lastName" varchar(100) NOT NULL,
  "address" varchar(200) NOT NULL,
  "email" varchar(100) UNIQUE NOT NULL,
  PRIMARY KEY ("id")
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
CREATE TABLE "Lesson" (
  "id" serial,
  "currentAmountOfStudents" integer NOT NULL,
  "instructorId" integer NOT NULL,
  "roomId" integer NOT NULL,
  "startTime" timestamp NOT NULL,
  "endTime" timestamp NOT NULL,
  "lessonType" "lessonType" NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_Lesson.instructorId"
    FOREIGN KEY ("instructorId")
      REFERENCES "Instructor"("id")
      ON DELETE CASCADE,
  CONSTRAINT "FK_Lesson.roomId"
    FOREIGN KEY ("roomId")
      REFERENCES "Room"("id")
      ON DELETE CASCADE
);

CREATE TABLE "Student" (
  "id" serial,
  "siblingId" integer,
  "personalInformationId" integer NOT NULL,
  "lessonId" integer NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_Student.personalInformationId"
    FOREIGN KEY ("personalInformationId")
      REFERENCES "PersonalInformation"("id")
      ON DELETE CASCADE,
  CONSTRAINT "FK_Student.lessonId"
    FOREIGN KEY ("lessonId")
      REFERENCES "Lesson"("id")
      ON DELETE CASCADE
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

CREATE TABLE "PricingScheme" (
  "id" serial,
  "validFrom" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "validTo" timestamp,
  "discountPercentage" decimal(2,2),
  "lessonLevel" "lessonLevel" NOT NULL,
  "lessonId" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_PricingScheme.lessonId"
    FOREIGN KEY ("lessonId")
      REFERENCES "Lesson"("id")
      ON DELETE CASCADE,
  CHECK ("validTo" IS NULL OR "validTo" > "validFrom")
);

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

CREATE TABLE "MonthlyFee" (
  "id" serial,
  "amount" decimal(10,2) NOT NULL,
  "paymentDate" timestamp NOT NULL,
  "PricingSchemeId" integer NOT NULL,
  "RentingInstrumentId" integer NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_MonthlyFee.PricingSchemeId"
    FOREIGN KEY ("PricingSchemeId")
      REFERENCES "PricingScheme"("id")
      ON DELETE CASCADE,
  CONSTRAINT "FK_MonthlyFee.RentingInstrumentId"
    FOREIGN KEY ("RentingInstrumentId")
      REFERENCES "RentingInstrument"("id")
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

-- Renting constraints:
-- 1. Ensures rental end date is after start date

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

