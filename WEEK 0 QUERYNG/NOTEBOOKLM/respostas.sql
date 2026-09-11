SELECT title, artist FROM tracks; 

SELECT title FROM tracks
WHERE release_year = 2022;

SELECT * FROM tracks LIMIT 5;

SELECT title, artist, genre FROM tracks
WHERE genre <> 'Pop';

SELECT title FROM tracks
WHERE title LIKE 'The %';

SELECT title, release_year FROM tracks
WHERE release_year BETWEEN 2010 AND 2015;

SELECT title, artist FROM tracks
WHERE title LIKE '%love%';

SELECT title, artist FROM tracks
WHERE album IS NULL;

SELECT title, artist, popularity, duration_seconds FROM tracks
WHERE popularity > 85 AND duration_seconds < 200;

SELECT title, tempo_bpm FROM tracks
WHERE tempo_bpm > 120
ORDER BY tempo_bpm ASC;

SELECT ROUND(AVG(duration_seconds), 2) AS duracao_media FROM tracks;

SELECT MAX(popularity) AS max_pop, ^Curacao_media FROM tracks;

SELECT MAX(popularity) AS max_pop, MIN(popularity) AS min_pop FROM tracks
WHERE genre = 'Rock';

SELECT COUNT(DISTINCT genre) AS total_generos FROM tracks;

SELECT title, artist, popularity, release_year FROM tracks 
WHERE release_year IN (2021, 2022) 
ORDER BY popularity DESC, title ASC 
LIMIT 5;
