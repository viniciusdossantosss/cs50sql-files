
-- *** The Lost Letter ***

-- To see how the tables are
SELECT * FROM "addresses" LIMIT 10;
SELECT * FROM "drivers" LIMIT 10;
SELECT * FROM "scans" LIMIT 10;
SELECT * FROM "packages" LIMIT 10;

-- To see the id of Anneke
SELECT * FROM "addresses"
WHERE "address" = '900 Somerville Avenue';

-- To see the information of packages of this address
SELECT * FROM "scans"
WHERE "address_id" = (
     SELECT "id" FROM "addresses"
     WHERE "address" = '900 Somerville Avenue'
);

-- To see if the destination was correct
SELECT * FROM "addresses"
WHERE "id" = '854';

-- To make sure where is the package

SELECT * FROM "scans"
WHERE "address_id" IN (
     SELECT "id" FROM "addresses"
     WHERE "address" = '900 Somerville Avenue'
     UNION
     SELECT "id" FROM "addresses"
     WHERE "address" = '2 Finnigan Street'
);


-- *** The Devious Delivery ***

-- To identify the package
SELECT * FROM "packages"
WHERE "contents" LIKE '%duck%' AND "from_address_id" IS NULL;

-- To identify the destiny
SELECT * FROM "addresses"
WHERE "id" = (
    SELECT "to_address_id" FROM "packages"
    WHERE "contents" LIKE '%duck%' AND "from_address_id" IS NULL
);

-- To identify the scans
SELECT * FROM "scans"
WHERE "package_id" = (
    SELECT "id" FROM "packages"
    WHERE "contents" LIKE '%duck%' AND "from_address_id" IS NULL
);

-- To identify the last destiny
SELECT * FROM "addresses"
WHERE "id" = '348';


-- *** The Forgotten Gift ***

-- To get the ids of the addresses
SELECT * FROM "addresses"
WHERE "address" IN (
    '109 Tileston Street',
    '728 Maple Place'
);

-- To get the package id
SELECT "id" FROM "packages"
WHERE "from_address_id" = '9873' AND "to_address_id" = '4983';

-- To get the content
SELECT * FROM "packages"
WHERE "from_address_id" = '9873' AND "to_address_id" = '4983';

-- To get the id of the driver
SELECT * FROM "scans"
WHERE "package_id" = '9523';

-- To get the name of the driver
SELECT * FROM "drivers"
WHERE "id" = '17';

