SELECT COUNT(*) FROM "players"
WHERE "bats" IS 'R' AND "throws" IS 'L'
OR "bats" IS 'L' AND "throws" IS 'R';
