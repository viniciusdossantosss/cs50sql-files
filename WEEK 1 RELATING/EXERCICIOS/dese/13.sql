SELECT "schools"."name" AS "school_name", "districts"."name" AS "district_name", "expenditures"."per_pupil_expenditure"
FROM "schools"
JOIN "districts" ON "schools"."district_id" = "districts"."id"
JOIN "expenditures" ON "districts"."id" = "expenditures"."district_id"
ORDER BY "expenditures"."per_pupil_expenditure" DESC
LIMIT 10;
