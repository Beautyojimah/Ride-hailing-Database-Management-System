-- creating the report table. 

CREATE TABLE monthly_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    month_starting DATE,
    total_earnings DECIMAL(10, 2),
    total_trips INT,
    average_rating DECIMAL(3, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE EVENT IF NOT EXISTS generate_monthly_reports
ON SCHEDULE EVERY 1 MONTH STARTS '2024-06-10 17:54:00' -- starting today
DO
BEGIN
    -- Variables to store aggregated data
    DECLARE total_earnings_month DECIMAL(10, 2);
    DECLARE total_trips_month INT;
    DECLARE average_rating_month DECIMAL(3, 2);

    -- Calculate total earnings for the past month
    SELECT SUM(amount) INTO total_earnings_month
    FROM payment
    WHERE DATE(payment_date) >= now() - INTERVAL 1 MONTH AND DATE(payment_date) < curdate();

    -- Calculate total number of trips for the past month
    SELECT COUNT(trip_id) INTO total_trips_month
    FROM trips
    WHERE DATE(start_date) >= now() - INTERVAL 1 MONTH AND DATE(start_date) < curdate();

    -- Calculate average driver rating for the past month
    SELECT ROUND(AVG(rating),2) INTO average_rating_month
    FROM ratings r
    JOIN trips t
    ON r.trip_id = t.trip_id
    WHERE DATE(t.start_date) >= now() - INTERVAL 1 MONTH AND DATE(t.start_date) < curdate();

    -- Insert the calculated data into the monthly_reports table
    INSERT INTO monthly_reports (month_starting, total_earnings, total_trips, average_rating)
    VALUES (CURDATE(), total_earnings_month, total_trips_month, average_rating_month);
END$$

DELIMITER ;

-- Turning On the event scheduler
SET GLOBAL event_scheduler = ON;

-- checking the monthly_reports table to confirm if report has been generated. 
SELECT *
FROM monthly_reports;


