SELECT "name" FROM 'teams'
JOIN "performances" ON "teams"."id" = "performances"."team_id"
JOIN "players" ON "players"."id" = "performances"."player_id"
WHERE "performances"."player_id" = (
    SELECT "id" FROM "players"
    WHERE "first_name" = 'Satchel' AND "last_name" = 'Paige'
)
GROUP BY "teams"."name";
