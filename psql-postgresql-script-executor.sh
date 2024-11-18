#!/bin/bash

# Set the directory where the SQL scripts are located
SQL_SCRIPTS_DIR="/home/eglab/Desktop/PostgreSQL-CNPG-Operator-K8s-testing/sql-scripts"

# Check if the directory exists
if [ ! -d "$SQL_SCRIPTS_DIR" ]; then
    echo "Error: SQL scripts directory '$SQL_SCRIPTS_DIR' not found."
    exit 1
fi

# List all SQL files in the directory
echo "Available SQL scripts:"
select sql_file in $(ls "$SQL_SCRIPTS_DIR"/*.sql); do
    if [ -z "$sql_file" ]; then
        echo "Invalid selection. Exiting."
        exit 1
    else
        echo "You selected: $sql_file"
        break
    fi
done

# Load variables (adjust as needed)
source variables.sh

# Get the IP address of the PostgreSQL service
RW_SERVICE_IP=$(kubectl get svc -n $NS_CLUSTER ${CLUSTER_NAME}-rw -o jsonpath='{.spec.clusterIPs[0]}')

# Display user selection for superuser or regular user
echo "Select user type:"
echo "1: Superuser ($SUPER_USER)"
echo "2: Regular user ($USER)"
read -p "Enter your choice (1 or 2): " user_choice

# Set the appropriate username based on user selection
if [[ $user_choice -eq 1 ]]; then
    DB_USER=$SUPER_USER
elif [[ $user_choice -eq 2 ]]; then
    DB_USER=$USER
else
    echo "Invalid choice. Exiting."
    exit 1
fi

# Execute the selected SQL script using psql
echo "Executing SQL script '$sql_file'..."
psql -h $RW_SERVICE_IP -U $DB_USER -d $DATABASE -f "$sql_file"

# Check if the execution was successful
if [ $? -eq 0 ]; then
    echo "SQL script executed successfully."
else
    echo "Error: SQL script execution failed."
    exit 1
fi

