-- Table for storing unique locations (used by customers and shipments)
CREATE TABLE Locations (
    location_id INT PRIMARY KEY,                         -- Unique ID for each location
    address VARCHAR(255),                                -- Street address (e.g., "123 Main St")
    city VARCHAR(100),                                   -- City name (e.g., "New York")
    state VARCHAR(100),                                  -- State or province (optional)
    postal_code INT CHECK (postal_code > 0),             -- ZIP or postal code; must be positive
    country VARCHAR(100) NOT NULL                        -- Country name (e.g., "USA"); required
);

-- Table for storing customer information
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,                         -- Unique ID for each customer
    first_name VARCHAR(100) NOT NULL,                    -- Customer's first name
    last_name VARCHAR(100) NOT NULL,                     -- Customer's last name
    email VARCHAR(100) NOT NULL UNIQUE,                  -- Unique email for contacting the customer
    phone VARCHAR(100),                                  -- Customer's phone number (optional)
    location_id INT NOT NULL,                            -- Foreign key linking to customer's address
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

-- Table for storing shipment details
CREATE TABLE Shipments (
    shipment_id INT PRIMARY KEY,                         -- Unique ID for each shipment
    customer_id INT NOT NULL,                            -- Foreign key linking to the customer
    shipment_date DATE NOT NULL,                         -- Date when the shipment was created
    origin_id INT NOT NULL,                              -- Foreign key to origin location
    destination_id INT NOT NULL,                         -- Foreign key to destination location
    status VARCHAR(100) NOT NULL CHECK (
        status IN ('Pending', 'In Transit', 'Delivered', 'Cancelled')
    ),                                                   -- Shipment status must be one of the listed values
    total_weight DECIMAL(6,2) NOT NULL CHECK (total_weight >= 0), -- Total weight in kg; must be non-negative
    carrier VARCHAR(20) NOT NULL,                        -- Shipping carrier name (e.g., FedEx, UPS)
    tracking_number VARCHAR(100) UNIQUE,                 -- Optional unique tracking ID
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (origin_id) REFERENCES Locations(location_id),
    FOREIGN KEY (destination_id) REFERENCES Locations(location_id)
);

-- Table for packages within shipments
CREATE TABLE Packages (
    package_id INT PRIMARY KEY,                                 -- Unique ID for each package
    shipment_id INT NOT NULL,                                   -- Foreign key to related shipment
    description VARCHAR(255),                                   -- Optional package description
    weight DECIMAL(6,2) NOT NULL CHECK (weight >= 0),           -- Weight of the package
    length_cm INT CHECK (length_cm > 0),                        -- Package length in cm
    width_cm INT CHECK (width_cm > 0),                          -- Package width in cm
    height_cm INT CHECK (height_cm > 0),                        -- Package height in cm
    fragile BOOL NOT NULL DEFAULT FALSE,                        -- Indicates if package is fragile
    declared_value DECIMAL(6,2) CHECK (declared_value >= 0),    -- Value declared for insurance
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id) -- Link to Shipments
);
-- Table for driver details
CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY,                                  -- Unique driver ID
    first_name VARCHAR(100) NOT NULL,                           -- Driver's first name
    last_name VARCHAR(100) NOT NULL,                            -- Driver's last name
    phone VARCHAR(100),                                         -- Contact number
    vehicle_type VARCHAR(20) NOT NULL,                          -- Type of vehicle (e.g. Van, Truck)
    license_number VARCHAR(50) NOT NULL UNIQUE                  -- Unique license number
);

-- Relationship between drivers and packages they handled
CREATE TABLE Driver_Packages (
    driver_id INT,                                              -- Driver involved
    package_id INT,                                             -- Package handled
    handled_at DATETIME DEFAULT CURRENT_TIMESTAMP,              -- Time of handling
    PRIMARY KEY (driver_id, package_id),                        -- Composite PK ensures uniqueness
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id),      -- Reference to Drivers
    FOREIGN KEY (package_id) REFERENCES Packages(package_id)    -- Reference to Packages
);
