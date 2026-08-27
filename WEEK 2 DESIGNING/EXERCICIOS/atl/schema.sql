CREATE TABLE passengers (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "birth_date" NUMERIC NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE checkins (
    "id" INTEGER,
    "date_time" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "flight_id" INTEGER,
    "passenger_id" INTEGER,
    PRIMARY KEY("id")
    FOREIGN KEY("flight_id") REFERENCES "flights"("id"),
    FOREIGN KEY("passenger_id") REFERENCES "passengers"("id")
);

CREATE TABLE airlines (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "concourse" TEXT NOT NULL CHECK ("concourse" IN ("A", "B", "C", "D", "E", "F", "T")),
    PRIMARY KEY("id")
);

CREATE TABLE "flights" (
    "id" INTEGER,
    "flight_num" INTEGER NOT NULL,
    "airline_id" INTEGER,
    "code_airport_depart" INTEGER NOT NULL,
    "code_airport_heading" INTEGER NOT NULL,
    "date_time_depart" NUMERIC NOT NULL,
    "date_time_heading" NUMERIC NOT NULL,
    FOREIGN KEY("airline_id") REFERENCES "airlines"("id")
);    
