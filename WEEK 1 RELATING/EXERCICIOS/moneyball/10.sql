SELECT "players"."first_name", "players"."last_name", "salaries"."salary", "performances"."HR", "salaries"."year"
FROM "players"
JOIN "salaries" ON "salaries"."player_id" = "players"."id"
JOIN "performances" ON "players"."id" = "performances"."player_id" AND "performances"."year" = "salaries"."year"
ORDER BY "players"."id" ASC, "performances"."year" DESC, "performances"."HR" DESC, "salaries"."salary" DESC;

