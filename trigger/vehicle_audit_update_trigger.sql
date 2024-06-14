-- CREATING A VEHICLE AUDIT TABLE FOR AN (UPDATE TRIGGER)

-- Step 1: Create the vehicle_audit Table
CREATE TABLE vehicle_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY, vehicle_id INT,
    old_registration_number VARCHAR(20),new_registration_number VARCHAR(20),
    old_colour VARCHAR(30), new_colour VARCHAR(30),
    old_insurance_expiry DATE, new_insurance_expiry DATE,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 2: Create the Trigger
DELIMITER //
CREATE TRIGGER log_vehicle_update
AFTER UPDATE ON vehicles
FOR EACH ROW
BEGIN
    INSERT INTO vehicle_audit (vehicle_id, 
		old_registration_number, new_registration_number,old_colour, 
        new_colour, old_insurance_expiry,new_insurance_expiry, change_date) 
	VALUES (OLD.vehicle_id, 
        OLD.registration_number, 
        NEW.registration_number, 
        OLD.colour, 
        NEW.colour, 
        OLD.insurance_expiry, 
        NEW.insurance_expiry, 
        CURRENT_TIMESTAMP
    );
END //
DELIMITER ;

-- Step 3: Perform an Update Operation
UPDATE vehicles
SET registration_number = 'XYZ123', colour = 'Blue', insurance_expiry = '2025-12-31'
WHERE vehicle_id = 1;

-- checking the vehicle_audit table
SELECT *
FROM vehicle_audit;