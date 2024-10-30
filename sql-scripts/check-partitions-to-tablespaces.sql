SELECT 
    t.relname AS partition_name,
    ts.spcname AS tablespace_name
FROM 
    pg_class t
JOIN 
    pg_namespace n ON n.oid = t.relnamespace
JOIN 
    pg_tablespace ts ON ts.oid = t.reltablespace
WHERE 
    t.relkind = 'r'  -- Only regular tables
    AND n.nspname = 'public'  -- Adjust schema name if necessary
    AND t.relname LIKE 'facts_%';  -- Only partitions of the facts table