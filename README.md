# Ride-hailing-Database-Management-System

![Ride Share Image](image/ride_share_image.webp "Ride Share Image")

## Project Overview

This project is a ride-hailing database management system designed to manage and facilitate the operations of a ride-sharing service, RYD (Reach Your Destination). It includes extensive back-end functionalities such as dynamic pricing, automated monthly reporting, detailed analytics, and customer support mechanisms.

## Features

- **User Management**: Handles registration, authentication, and profile management for drivers and passengers.
- **Ride Management**: Supports booking, updating, and tracking rides.
- **Dynamic Pricing**: Fares calculated using stored procedures based on distance, time, pricing strategy and promotion eligibility.
- **Payment Processing**: Manages transactions with comprehensive records of all payments.
- **Ratings System**: Collects and averages ratings for drivers and trips, enhancing service quality.
- **Automated Reporting**: Monthly reports generated automatically to provide business insights.
- **Customer Support Tools**: Database views for assisting with customer service and managing complaints, particularly focusing on lower-rated trips.
- **Data Analysis**: Advanced queries and reports that provide insights into user activity, revenue, and popular locations.

## Technologies Used

- **Database**: MySQL for all data storage and querying.
- **Business Intelligence**: Use of SQL for advanced queries and Tableau for visualizing data.

## Database Design

- **ER Diagram**: Includes detailed entity-relationship diagrams showing all entities and their relationships. It can be found in the `image` folder.
- **Schema Definitions**: Describes each table and its fields, including types and constraints.

## Getting Started

### Prerequisites

- MySQL Server
- Tableau Public (for visualizing analytical data)

### Installation

1. **Database Setup**
   - Ensure MySQL is installed and running on your machine.
   - Execute the `Schema_creation.sql` scripts provided within this repository to create and populate the database schema.   

2. **Tableau Setup**
   - Install Tableau Public.

## Usage
- **Dataset Import**: Using the SQL workbench GUI, import the data for each table. The dataset is found in the `dataset` folder.
- **Stored Procedures**: Input the necessary parameters to use the various stored procedures.
- **Stored Function**: Use the stored function to calculate vehicle validity
- **Views**: Review and use the views to manage customer complaints for low-rated trips. 
- **Data Analysis**: Utilise the provided SQL queries to answer business questions. manage operations and generate reports.
- **Visualise result**: Export the result of your analysis from MySQL workbench as a csv. Load the exported result into Tableau and visualise the result.  
  
## API Documentation

- This project does not include an API but relies on direct database manipulation and queries for all functionalities.

## Authors

- **[Beauty Ojimah]**
- **[Olawunmi Falana]**
- **[Omolara Olusola]**
- **[Gillian White]**
- **[Hannah Bessant]**
- **[Odunayo Adeyemi]**   

## Acknowledgments

- Hat tip to everyone who contributed to the project.

