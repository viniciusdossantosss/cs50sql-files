CREATE TABLE users (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE schools (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "foundation_year" NUMERIC NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE companies (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "industry" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE users_users (
    "user1_id" INTEGER,
    "user2_id" INTEGER,
    PRIMARY KEY("user1_id", "user2_id"),
    FOREIGN KEY ("user1_id") REFERENCES "users"("id"),
    FOREIGN KEY ("user2_id") REFERENCES "users"("id")
);

CREATE TABLE users_schools (
    "id" INTEGER,
    "user_id" INTEGER,
    "school_id" INTEGER,
    "start_date" NUMERIC NOT NULL,
    "end_date" NUMERIC,
    "type_of_degree" TEXT NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY ("user_id") REFERENCES "users"("id"),
    FOREIGN KEY ("school_id") REFERENCES "schools"("id")
);

CREATE TABLE users_companies (
    "id" INTEGER,
    "user_id" INTEGER,
    "company_id" INTEGER,
    "start_date" NUMERIC NOT NULL,
    "end_date" NUMERIC,
    "title" TEXT NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY ("user_id") REFERENCES "users"("id"),
    FOREIGN KEY ("company_id") REFERENCES "companies"("id")
);
