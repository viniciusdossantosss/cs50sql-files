SELECT "salaries"."salary" FROM "salaries"
JOIN "performances" ON "salaries"."player_id" = "performances"."player_id"
AND "salaries"."year" = "performances"."year"
WHERE "performances"."HR" = (
    SELECT MAX("HR") FROM "performances"
    WHERE "year" = '2001'
);
