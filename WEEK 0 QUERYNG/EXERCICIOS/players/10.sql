SELECT first_name, last_name, height AS "Tallest Foreign Players"
FROM players
WHERE birth_country != 'USA' AND height IS NOT NULL
ORDER BY height DESC, first_name ASC
LIMIT 5;
