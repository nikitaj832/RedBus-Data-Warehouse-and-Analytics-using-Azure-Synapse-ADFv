RedBus Data Warehouse & Analytics using Azure Synapse
📌 Project Overview

This project demonstrates the end-to-end design and implementation of a Data Warehouse for an online bus booking system (RedBus) using Azure Synapse Analytics and Azure Data Factory (ADF).

The goal is to extract raw bus booking data from CSV, transform it into a star schema (Fact + Dimensions), and enable business insights such as popular routes, top-paying customers, bus preferences, and payment trends.

🛠️ Tech Stack

Azure Synapse Analytics – Data Warehouse & SQL queries

Azure Data Factory (ADF) – ETL/ELT pipeline for loading data

Azure Blob Storage – CSV file staging area

SQL (SQL for Synapse) – Data modeling & queries

📂 Project Structure
RedBus-DataWarehouse/
│
├── data/
│   └── red_bus.csv            # Raw input dataset
│
├── sql/
│   ├── create_tables.sql      # Fact & Dimension schema
│   ├── insert_queries.sql     # Data transformation & insert
│   ├── test_queries.sql       # Analytical queries
│
├── pipeline/
│   └── adf_pipeline.json      # Azure Data Factory pipeline config
│
└── README.md                  # Project documentation

🏗️ Data Model (Star Schema)

Fact Table:

FactBooking (BookingID, PassengerID, RouteID, BusID, PaymentID)

Dimension Tables:

DimPassenger (Passenger_ID, First_Name, Last_Name, Age)

DimRoute (RouteID, City_From, City_To)

DimBus (BusID, Bus_Type, Seat_Type)

DimPayment (PaymentID, Payment_Method, Booking_Type, Ticket_Fare)

📌 Diagram:
FactBooking 🔗 → DimPassenger, DimRoute, DimBus, DimPayment

🔍 Sample Analytical Queries

Top 5 passengers by number of bookings

SELECT TOP 5 p.First_Name, COUNT(*) AS TotalBookings
FROM FactBooking f
JOIN DimPassenger p ON f.PassengerID = p.Passenger_ID
GROUP BY p.First_Name
ORDER BY TotalBookings DESC;


Most popular bus type

SELECT b.Bus_Type, COUNT(*) AS TotalTrips
FROM FactBooking f
JOIN DimBus b ON f.BusID = b.BusID
GROUP BY b.Bus_Type
ORDER BY TotalTrips DESC;


Highest revenue route

SELECT r.City_From, r.City_To, SUM(p.Ticket_Fare) AS TotalRevenue
FROM FactBooking f
JOIN DimRoute r ON f.RouteID = r.RouteID
JOIN DimPayment p ON f.PaymentID = p.PaymentID
GROUP BY r.City_From, r.City_To
ORDER BY TotalRevenue DESC;


(Full list of 10+ test queries included in sql/test_queries.sql)

🚀 How to Run

Upload red_bus.csv into Azure Blob Storage

Use ADF pipeline (pipeline/adf_pipeline.json) to load into staging table (red_bus) in Synapse

Run create_tables.sql to create Fact + Dimension schema

Run insert_queries.sql to populate Fact & Dimension tables

Use test_queries.sql to validate and generate insights

📊 Key Insights

Identified most profitable routes

Determined preferred bus and seat types

Analyzed payment method usage

Found top passengers by bookings & spend

📖 Future Improvements

Automate pipeline scheduling in ADF

Integrate with Power BI for dashboarding

Add incremental data loading and slowly changing dimensions (SCD)

🙌 Acknowledgements

Dataset inspired by RedBus booking system (simulated sample data).

Tools: Microsoft Azure (Synapse, ADF, Blob Storage).

✨ Built with ❤️ for learning Data Engineering and Cloud Analyticsv
