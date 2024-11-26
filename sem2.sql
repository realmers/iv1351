-- To be used in PostgreSQL

SET search_path TO public;

CREATE TABLE "PersonalInformation" (
  "id" serial,
  "personNumber" varchar(12) UNIQUE,
  "name" varchar(100),
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

CREATE TYPE lesson_type_enum AS ENUM ('individual', 'group', 'ensemble');

CREATE TABLE "Ensemble" (
  "id" serial,
  "genre" varchar(32),
  PRIMARY KEY ("id")
);
-- Only creates the ensemble table if lesson type = ensemble
CREATE TABLE "Lesson" (
  "id" serial,
  "minimumRequiredStudentCount" integer,
  "instructorId" integer,
  "roomId" integer,
  "startTime" timestamp,
  "endTime" timestamp,
  "studentId" integer,
  "levelId" integer,
  "lessonType" lesson_type_enum,
  "ensembleId" integer,
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
  CONSTRAINT "FK_Lesson.ensembleId"
    FOREIGN KEY ("ensembleId")
      REFERENCES "Ensemble"("id")
      ON DELETE CASCADE,
  CHECK (
    ("lessonType" = 'ensemble' AND "ensembleId" IS NOT NULL) OR
    ("lessonType" IN ('individual', 'group') AND "ensembleId" IS NULL)
  )
);

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

CREATE TABLE "RentingInstrument" (
  "id" serial,
  "studentId" integer,
  "rentTime" date,
  "maxRentableInstrumentCount" integer DEFAULT 2 CHECK ("maxRentableInstrumentCount" = 2),
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_RentingInstrument.studentId"
    FOREIGN KEY ("studentId")
      REFERENCES "Student"("id")
      ON DELETE CASCADE
);

CREATE TABLE "AvailableInstrument" (
  "id" serial,
  "instrumentType" varchar(50),
  "rentingInstrumentId" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_AvailableInstrument.rentingInstrumentId"
    FOREIGN KEY ("rentingInstrumentId")
      REFERENCES "RentingInstrument"("id")
      ON DELETE CASCADE
);