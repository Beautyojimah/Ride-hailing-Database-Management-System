CREATE TABLE debug_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(255),
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DELIMITER $$
CREATE PROCEDURE ApplyPromo(
    IN p_passenger_id INT, 
    IN p_promo_id INT, 
    IN p_trip_id INT, 
    IN p_pricing_id INT, 
    IN p_miles_travelled DECIMAL(5,2)
)
BEGIN
    DECLARE p_base_fare, p_per_mile, p_per_minute, p_amount, p_discount_value DECIMAL(10,2);
    DECLARE p_start_date, p_end_date DATETIME;
    DECLARE p_time_diff, num_of_trip, new_trip_id INT;
    DECLARE is_eligible VARCHAR(50);
    DECLARE trip_exists INT;

    -- Check promotion eligibility
    CALL CheckPromotionEligibility(p_passenger_id, p_promo_id, is_eligible);

    IF is_eligible = "Hurray!!! Passenger is eligible" THEN
        -- Log eligibility
        INSERT INTO debug_log(message) VALUES ('Passenger is eligible');

        -- Check if the trip already exists
        SELECT COUNT(*) INTO trip_exists
        FROM trips
        WHERE trip_id = p_trip_id;

        IF trip_exists = 0 THEN
            -- Insert the new trip if it does not exist
            INSERT INTO trips(passenger_id, driver_id, vehicle_id, start_address_id, end_address_id, start_date, end_date, trip_status, pricing_id, miles_travelled)
            VALUES(p_passenger_id, 27, 97, 72, 95, CURRENT_TIMESTAMP(), ADDTIME(CURRENT_TIMESTAMP(), '00:25:00'), 'completed', p_pricing_id, p_miles_travelled);
            
            -- Retrieve the new trip_id 
            SET new_trip_id = LAST_INSERT_ID();
            
            -- Set the trip dates for calculation
            SET p_start_date = CURRENT_TIMESTAMP();
            SET p_end_date = ADDTIME(CURRENT_TIMESTAMP(), '00:25:00');
        ELSE
            -- Use the existing trip data
            SELECT start_date, end_date 
            INTO p_start_date, p_end_date
            FROM trips
            WHERE trip_id = p_trip_id;
            
            SET new_trip_id = p_trip_id;
        END IF;

        -- Debugging: Log trip dates
        IF p_start_date IS NULL OR p_end_date IS NULL THEN
            INSERT INTO debug_log(message) VALUES ('Trip dates are NULL');
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trip dates are NULL';
        ELSE
            INSERT INTO debug_log(message) VALUES (CONCAT('Trip dates - Start: ', p_start_date, ', End: ', p_end_date));
        END IF;
        
        -- Calculate the time difference and convert to minutes
        SET p_time_diff = TIMESTAMPDIFF(MINUTE, p_start_date, p_end_date);

        -- Debugging: Log trip duration
        INSERT INTO debug_log(message) VALUES (CONCAT('Trip duration (minutes): ', p_time_diff));

        -- Calculate the trip amount
        SELECT base_fare, per_mile, per_minute 
        INTO p_base_fare, p_per_mile, p_per_minute
        FROM pricing
        WHERE pricing_id = p_pricing_id;
        
        -- Debugging: Log pricing details
        INSERT INTO debug_log(message) VALUES (CONCAT('Pricing details - Base fare: ', p_base_fare, ', Per mile: ', p_per_mile, ', Per minute: ', p_per_minute));

        SET p_amount = p_base_fare + (p_per_mile * p_miles_travelled) + (p_per_minute * p_time_diff);
        INSERT INTO debug_log(message) VALUES (CONCAT('Calculated amount: ', p_amount));

        SELECT discount_value 
        INTO p_discount_value
        FROM promotions
        WHERE promotion_id = p_promo_id;

        -- Debugging: Log discount value
        INSERT INTO debug_log(message) VALUES (CONCAT('Discount value: ', p_discount_value));

        -- Apply the discount based on the promotion type
        IF p_promo_id = 1 THEN
            SELECT COUNT(trip_id) 
            INTO num_of_trip -- Count the total number of trips taken by the passenger
            FROM trips
            WHERE passenger_id = p_passenger_id;

            IF num_of_trip >= 10 THEN -- Check if it's the 11th ride
                SET p_amount = p_amount - p_discount_value;
            ELSE 
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "OFF5 cannot be applied"; 
            END IF;
        ELSEIF p_promo_id = 2 THEN
            SET p_amount = p_amount * (1 - (p_discount_value / 100));
        END IF;

        -- Debugging: Log discounted amount
        INSERT INTO debug_log(message) VALUES (CONCAT('Discounted amount: ', p_amount));

        -- Check if the same promotion already exists for this trip and passenger
        IF EXISTS (SELECT 1 FROM ride_promotions WHERE promotion_id = p_promo_id AND trip_id = new_trip_id) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Promotion already applied for this trip and passenger';
        ELSE
            -- Insert payment record using the new_trip_id
            INSERT INTO payment(trip_id, amount, payment_method, payment_status, payment_date)
            VALUES (new_trip_id, p_amount, 'debit card', 'approved', CURRENT_TIMESTAMP());
            
            -- Debugging: Log payment insert
            INSERT INTO debug_log(message) VALUES ('Inserted payment record');
            
            -- Insert into ride_promotion table
            INSERT INTO ride_promotions(promotion_id, trip_id, applied_date)
            VALUES (p_promo_id, new_trip_id, CURRENT_TIMESTAMP());
            
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Promotion applied successfully';
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Not eligible for Promo.";        
    END IF;             
END $$
DELIMITER ;
