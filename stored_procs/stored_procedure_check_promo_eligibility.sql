USE RYD;

-- 1. check promotion validity based on whether the promo is active, before the end date and passenger has used the code previously. 

-- Flow of logic
	-- collect passenger id and promotion code
    -- find whether promo is active and valid (end_date). Identify the variable(s) that I may need 
    -- check if passenger has used the promo_id before. Identify the variable(s) that I may need 
    -- determine my validity logic
    -- show result
    -- test the stored procedure. 

DELIMITER $$
CREATE PROCEDURE CheckPromotionEligibility(IN p_passenger_id INT, IN p_promo_id INT, OUT is_eligible VARCHAR(50))
BEGIN
	-- Collect the active and end_date data for the specified promotion_id
    DECLARE promo_active VARCHAR(50);
    DECLARE promo_end_date DATE;
	DECLARE has_used_before VARCHAR(50);
    
	SELECT active, end_date INTO promo_active, promo_end_date
    FROM promotions
    WHERE promotion_id = p_promo_id;
    
    -- Check if the passenger has used this promotion before.
    -- Query to check if there exists an entry in the ride_promotions table 
    -- where both the promotion_id and passenger_id match the input values.
	
    SELECT EXISTS(
		SELECT "Yes"
		FROM ride_promotions rp
		JOIN trips t
		ON t.trip_id = rp.trip_id
		WHERE promotion_id = p_promo_id AND passenger_id = p_passenger_id
		) INTO has_used_before;
    
    -- Determine eligibility 
    IF promo_active = "Yes" AND promo_end_date <= promo_end_date And has_used_before = "0"
		THEN 
        SET is_eligible = "Hurray!!! Passenger is eligible";
    ELSE
		SET is_eligible = "Ohhh Sorry!! not eligible";
	END IF;
    
    -- output result
    SELECT is_eligible;
     
    END $$
DELIMITER ;

-- calling the procedure
CALL CheckPromotionEligibility(123, 2, @is_eligible);
SELECT @is_eligible AS Eligible;


-- 2. If passengers are eligible for a promo, then we need to apply the promo to their trip and update their payment amount 

