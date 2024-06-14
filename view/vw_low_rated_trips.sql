 -- creating view that holds detailed summary of low-rated trips
 
CREATE VIEW vw_low_rated_trips AS
SELECT t.trip_id,
    t.start_date,
    t.end_date,
    t.trip_status,
    p.amount AS payment_amount,
    p.payment_method,
    p.payment_status,
    CONCAT(du.first_name, ' ', du.last_name) AS driver_name,
    CONCAT(pu.first_name, ' ', pu.last_name) AS passenger_name,
    r.rating,
    r.comment, 
    a.city
FROM trips t 
JOIN addresses a ON a.address_id = t.start_address_id
JOIN payment p ON t.trip_id = p.trip_id 
JOIN driver d ON t.driver_id = d.driver_id
JOIN app_users du ON d.user_id = du.user_id
JOIN app_users pu ON t.passenger_id = pu.user_id
LEFT JOIN ratings r ON t.trip_id = r.trip_id
WHERE rating <= 3;

-- use the view

SELECT *
FROM vw_low_rated_trips;