SELECT "first_name", "last_name"
FROM "players"
WHERE "id" IN (
    -- Subconsulta 1: IDs dos 10 mais baratos por hit em 2001
    SELECT "players"."id"
    FROM "players"
    JOIN "salaries" ON "players"."id" = "salaries"."player_id"
    JOIN "performances" ON "players"."id" = "performances"."player_id"
        AND "salaries"."year" = "performances"."year"
    WHERE "salaries"."year" = 2001
      AND "performances"."H" > 0
    ORDER BY ("salaries"."salary" / "performances"."H") ASC
    LIMIT 10
)
AND "id" IN (
    -- Subconsulta 2: IDs dos 10 mais baratos por RBI em 2001
    SELECT "players"."id"
    FROM "players"
    JOIN "salaries" ON "players"."id" = "salaries"."player_id"
    JOIN "performances" ON "players"."id" = "performances"."player_id"
        AND "salaries"."year" = "performances"."year"
    WHERE "salaries"."year" = 2001
      AND "performances"."RBI" > 0
    ORDER BY ("salaries"."salary" / "performances"."RBI") ASC
    LIMIT 10
)
ORDER BY "id" ASC;
