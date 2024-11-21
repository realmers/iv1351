
SET search_path TO public;

CREATE TABLE "Instructor" (
  "id" serial,
  "personNumber" varchar(12) UNIQUE,
  "name" varchar(100),
  "address" varchar(200),
  "email" varchar(200) UNIQUE,
  PRIMARY KEY ("id")
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

CREATE TYPE student_level_enum AS ENUM ('beginner', 'intermediate', 'advanced');

CREATE TABLE "StudentLevel" (
  "id" serial,
  "level" student_level_enum,
  PRIMARY KEY ("id")
);

CREATE TABLE "Room" (
  "id" serial,
  "name" text,
  "capacity" integer,
  "location" text,
  PRIMARY KEY ("id")
);

CREATE TABLE "Student" (
  "id" serial,
  "personNumber" varchar(12) UNIQUE,
  "name" varchar(100),
  "address" varchar(200),
  "email" varchar(100) UNIQUE,
  "siblingId" integer,
  "levelId" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT "FK_Student.levelId"
    FOREIGN KEY ("levelId")
      REFERENCES "StudentLevel"("id")
      ON DELETE CASCADE
);

CREATE TABLE "Lesson" (
  "id" serial,
  "minimumRequiredStudentCount" integer,
  "instructorId" integer,
  "groupSize" integer,
  "roomId" integer,
  "startTime" timestamp,
  "endTime" timestamp,
  "studentId" integer,
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
      ON DELETE CASCADE
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

