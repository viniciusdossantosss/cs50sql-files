SELECT english_title AS "Complex Hiroshige Prints"
FROM views
WHERE artist = 'Hiroshige' AND entropy > 7.0
ORDER BY entropy DESC
LIMIT 3;
