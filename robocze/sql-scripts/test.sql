-- Create table if it doesn't exist
CREATE TABLE IF NOT EXISTS test_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Insert data into the table
INSERT INTO test_table (name, created_at) VALUES 
('David', CURRENT_TIMESTAMP),
('Eve', CURRENT_TIMESTAMP),
('Frank', CURRENT_TIMESTAMP);

