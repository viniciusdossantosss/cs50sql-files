CREATE VIEW message AS
WITH mahogany(sentence_id, start_char, length) AS (
    VALUES
    (14, 98, 4),
    (114, 3, 5),
    (618, 72, 9),
    (630, 7, 3),
    (932, 12, 5),
    (2230, 50, 7),
    (2346, 44, 10),
    (3041, 14, 5)
)
SELECT substr(sentences.sentence, mahogany.start_char, mahogany.length) AS phrase
FROM mahogany
JOIN sentences ON sentences.id = mahogany.sentence_id;