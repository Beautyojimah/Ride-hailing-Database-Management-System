-- CREATE DATABASE RYD;

-- USE RYD;

-- 1. Users Table
CREATE TABLE App_users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    date_of_birth DATE,
    email VARCHAR(50),
    password_hash VARCHAR(20) NOT NULL,
    phone_number VARCHAR(20),
    created_at DATETIME,
    user_type ENUM('passenger', 'driver') NOT NULL,
    is_active VARCHAR(3)
);

-- 2. Driver Table
CREATE TABLE Driver (
    driver_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    license_number VARCHAR(50) NOT NULL UNIQUE,
    license_expiry DATE,
    approved VARCHAR(3),
    FOREIGN KEY (user_id) REFERENCES App_users(user_id)
);

-- 3. Pricing Table
CREATE TABLE Pricing (
    pricing_id INT AUTO_INCREMENT PRIMARY KEY,
    base_fare DECIMAL(5,2),
    per_mile DECIMAL(5,2),
    per_minute DECIMAL(5,2),
    pricing_type ENUM('standard', 'premium', 'luxury')
);

-- 4. Vehicle Table
CREATE TABLE Vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    driver_id INT NOT NULL,
    registration_number VARCHAR(20) NOT NULL,
    make VARCHAR(50),
    model VARCHAR(50),
    body_style VARCHAR(50),
    year_registered YEAR NOT NULL,
    colour VARCHAR(30),
    insurance_expiry DATE,
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);

-- 5. Addresses Table
CREATE TABLE Addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    address_line1 VARCHAR(100) NOT NULL,
    address_line2 VARCHAR(100) NULL,
    city VARCHAR(50) NOT NULL,
    postcode VARCHAR(10) NOT NULL,
    country VARCHAR(50) NOT NULL
);

-- 6. Promotions Table
CREATE TABLE Promotions (
    promotion_id INT AUTO_INCREMENT PRIMARY KEY,
    promotion_code VARCHAR(20),
    description TEXT,
    discount_type ENUM('percentage', 'amount'),
    discount_value DECIMAL(5,2),
    start_date DATE,
    end_date DATE,
    active VARCHAR(3)
);

-- 7. Trips Table
CREATE TABLE Trips (
    trip_id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT,
    driver_id INT,
    vehicle_id INT,
    start_address_id INT,
    end_address_id INT,
    start_date DATETIME,
    end_date DATETIME,
    trip_status VARCHAR(20),
    pricing_id INT,
    miles_travelled DECIMAL(7,2) NOT NULL DEFAULT 0.0,
    FOREIGN KEY (passenger_id) REFERENCES App_users(user_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (pricing_id) REFERENCES Pricing(pricing_id),
    FOREIGN KEY (start_address_id) REFERENCES Addresses(address_id),
    FOREIGN KEY (end_address_id) REFERENCES Addresses(address_id)
);

-- 8. Ratings Table
CREATE TABLE Ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    trip_id INT,
    rating_by_user_id INT,
    rating_for_user_id INT,
    rating INT,
    comment TEXT,
    FOREIGN KEY (trip_id) REFERENCES Trips(trip_id),
    FOREIGN KEY (rating_by_user_id) REFERENCES App_users(user_id),
    FOREIGN KEY (rating_for_user_id) REFERENCES App_users(user_id)
);

-- 9. Payment Table
CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    trip_id INT,
    amount DECIMAL(6,2),
    payment_method ENUM ('credit card', 'debit card', 'paypal', 'apple pay','google pay') DEFAULT 'debit card' NOT NULL,
    payment_status ENUM('approved', 'pending', 'cancelled'),
    payment_date DATETIME,
    FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
);

-- 10. Ride_Promotions Table
CREATE TABLE Ride_Promotions (
    ride_promotion_id INT AUTO_INCREMENT PRIMARY KEY,
    promotion_id INT,
    trip_id INT,
    applied_date DATETIME,
    FOREIGN KEY (promotion_id) REFERENCES Promotions(promotion_id),
    FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
);