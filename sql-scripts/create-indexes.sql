-- Create indexes on the partitions

-- Indexes for facts1 partition
CREATE INDEX IF NOT EXISTS idx_facts1_customer_id ON facts1 (customer_id);
CREATE INDEX IF NOT EXISTS idx_facts1_product_id ON facts1 (product_id);
CREATE INDEX IF NOT EXISTS idx_facts1_order_date ON facts1 (order_date);

-- Indexes for facts2 partition
CREATE INDEX IF NOT EXISTS idx_facts2_customer_id ON facts2 (customer_id);
CREATE INDEX IF NOT EXISTS idx_facts2_product_id ON facts2 (product_id);
CREATE INDEX IF NOT EXISTS idx_facts2_order_date ON facts2 (order_date);

-- Indexes for facts3 partition
CREATE INDEX IF NOT EXISTS idx_facts3_customer_id ON facts3 (customer_id);
CREATE INDEX IF NOT EXISTS idx_facts3_product_id ON facts3 (product_id);
CREATE INDEX IF NOT EXISTS idx_facts3_order_date ON facts3 (order_date);

-- Verify if indexes exist for the partitions
SELECT *
FROM pg_indexes
WHERE tablename IN ('facts1','facts2','facts3');

