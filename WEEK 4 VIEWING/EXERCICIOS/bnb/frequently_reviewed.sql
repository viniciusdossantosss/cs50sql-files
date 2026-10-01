CREATE VIEW frequently_reviewed AS
SELECT listings.id, listings.property_type, listings.host_name, COUNT(reviews.listing_id) AS reviews
FROM listings
JOIN reviews ON listings.id = reviews.listing_id
GROUP BY listings.id
ORDER BY reviews DESC LIMIT 10;