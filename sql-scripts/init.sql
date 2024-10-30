-- Create the main partitioned table for customer orders
CREATE TABLE IF NOT EXISTS facts (
    id SERIAL,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    order_date DATE NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id, order_date)  -- Include order_date in the primary key
) PARTITION BY RANGE (order_date);

-- Create partitions for each tablespace
CREATE TABLE IF NOT EXISTS facts1 PARTITION OF facts
    FOR VALUES FROM ('2023-12-01') TO ('2023-12-10')
    TABLESPACE tablespace1;

CREATE TABLE IF NOT EXISTS facts2 PARTITION OF facts
    FOR VALUES FROM ('2023-12-10') TO ('2023-12-20')
    TABLESPACE tablespace2;

CREATE TABLE IF NOT EXISTS facts3 PARTITION OF facts
    FOR VALUES FROM ('2023-12-20') TO ('2024-03-01')
    TABLESPACE tablespace3;


-- Insert sample data into the partitioned table
INSERT INTO facts (customer_id, product_id, order_date, quantity, total_amount) VALUES 
(1, 101, '2023-12-01', 1, 19.99),
(2, 102, '2023-12-02', 2, 39.98),
(3, 103, '2023-12-03', 1, 24.50),
(4, 104, '2023-12-04', 3, 59.97),
(5, 105, '2023-12-05', 1, 29.99),
(6, 106, '2023-12-06', 4, 99.99),
(7, 107, '2023-12-07', 2, 49.99),
(8, 108, '2023-12-08', 1, 19.99),
(9, 109, '2023-12-09', 3, 59.97),
(10, 110, '2023-12-10', 1, 29.99),
(11, 111, '2023-12-11', 2, 39.98),
(12, 112, '2023-12-12', 1, 24.50),
(13, 113, '2023-12-13', 3, 59.97),
(14, 114, '2023-12-14', 1, 29.99),
(15, 115, '2023-12-15', 2, 39.98),
(16, 116, '2023-12-16', 1, 19.99),
(17, 117, '2023-12-17', 2, 49.99),
(18, 118, '2023-12-18', 1, 24.50),
(19, 119, '2023-12-19', 3, 59.97),
(20, 120, '2023-12-20', 1, 29.99),
(21, 121, '2024-01-01', 1, 19.99),
(22, 122, '2024-01-02', 2, 39.98),
(23, 123, '2024-01-03', 1, 24.50),
(24, 124, '2024-01-04', 3, 59.97),
(25, 125, '2024-01-05', 1, 29.99),
(26, 126, '2024-01-06', 4, 99.99),
(27, 127, '2024-01-07', 2, 49.99),
(28, 128, '2024-01-08', 1, 19.99),
(29, 129, '2024-01-09', 3, 59.97),
(30, 130, '2024-01-10', 1, 29.99);