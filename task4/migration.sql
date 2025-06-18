-- Table storing customer details
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY, -- Unique ID for each customer
    first_name VARCHAR(100) NOT NULL, -- Customer's first name
    last_name VARCHAR(100) NOT NULL, -- Customer's last name
    email VARCHAR(100) NOT NULL UNIQUE, -- Customer's unique email address
    address VARCHAR(255) NOT NULL, -- Street address
    city VARCHAR(100) NOT NULL, -- City of residence
    state VARCHAR(100), -- Optional state/province
    postal_code INT CHECK (postal_code > 0), -- Numeric postal/ZIP code
    phone VARCHAR(100), -- Contact phone number
    country VARCHAR(100) NOT NULL -- Country of residence
);

-- Table storing shipment information linked to customers
CREATE TABLE Shipments (
    shipment_id INT PRIMARY KEY, -- Unique shipment identifier
    customer_id INT NOT NULL, -- Foreign key to the customer
    shipment_date DATE NOT NULL, -- Date the shipment was created
    origin VARCHAR(100) NOT NULL, -- Origin location
    destination VARCHAR(100) NOT NULL, -- Destination location
    status VARCHAR(100) NOT NULL CHECK (
        status IN ('Pending', 'In Transit', 'Delivered', 'Cancelled')
    ), -- Shipment status
    total_weight DECIMAL(6,2) NOT NULL CHECK (total_weight >= 0), -- Total shipment weight in kg
    carrier VARCHAR(20) NOT NULL, -- Name of the carrier
    tracking_number VARCHAR(100) UNIQUE, -- Optional unique tracking ID
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) -- Link to Customers
);

-- Table for packages within shipments
CREATE TABLE Packages (
    package_id INT PRIMARY KEY, -- Unique ID for each package
    shipment_id INT NOT NULL, -- Foreign key to related shipment
    description VARCHAR(255), -- Optional package description
    weight DECIMAL(6,2) NOT NULL CHECK (weight >= 0), -- Weight of the package
    length_cm INT CHECK (length_cm > 0), -- Package length in cm
    width_cm INT CHECK (width_cm > 0), -- Package width in cm
    height_cm INT CHECK (height_cm > 0), -- Package height in cm
    fragile BOOL NOT NULL DEFAULT FALSE, -- Indicates if package is fragile
    declared_value DECIMAL(6,2) CHECK (declared_value >= 0), -- Value declared for insurance
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id) -- Link to Shipments
);
-- Table for driver details
CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY, -- Unique driver ID
    first_name VARCHAR(100) NOT NULL, -- Driver's first name
    last_name VARCHAR(100) NOT NULL, -- Driver's last name
    phone VARCHAR(100), -- Contact number
    vehicle_type VARCHAR(20) NOT NULL, -- Type of vehicle (e.g. Van, Truck)
    license_number VARCHAR(50) NOT NULL UNIQUE -- Unique license number
);

-- Relationship between drivers and packages they handled
CREATE TABLE Driver_Packages (
    driver_id INT, -- Driver involved
    package_id INT, -- Package handled
    handled_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Time of handling
    PRIMARY KEY (driver_id, package_id), -- Composite PK ensures uniqueness
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id), -- Reference to Drivers
    FOREIGN KEY (package_id) REFERENCES Packages(package_id) -- Reference to Packages
);

-- Import data into Customers table
LOAD DATA INFILE 'customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(customer_id, first_name, last_name, email,phone, address,city,state, postal_code,country);

-- Import data into Shipments table
LOAD DATA INFILE 'shipments.csv'
INTO TABLE Shipments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(shipment_id, customer_id, shipment_date, origin, destination, status, total_weight, carrier, tracking_number);

-- Import data into Packages table
LOAD DATA INFILE 'packages.csv'
INTO TABLE Packages
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(package_id, shipment_id, description, weight, length_cm, width_cm, height_cm, fragile, declared_value);

-- Import data into Drivers table
LOAD DATA INFILE 'drivers.csv'
INTO TABLE Drivers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(driver_id, first_name, last_name, phone, license_number,vehicle_type);

LOAD DATA INFILE 'driver_packages.csv'
INTO TABLE Driver_Packages
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(driver_id, package_id, handled_at);
