#!/bin/bash

# Load variables
source variables.sh

#define variable that points at ip address of service with rw capabilities for running postgresql primary instance
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

# Display options to the user
echo "Select an option:"
echo "1: Execute SQL file and remain logged in"
echo "2: Log into the database interactively"
echo "3: Drop the created table from the database"
echo "4: Check partitions and tablespaces"
read -p "Enter your choice (1, 2, 3 or 4): " choice

case $choice in
    1)
        echo "Executing SQL file..."
        psql -h $RW_SERVICE_IP -U $DB_USER -d $DATABASE < $SCRIPT_INIT
        echo "SQL file executed successfully."
        
        # Remain logged in after executing the SQL file
        echo "You are now logged into the database."
        psql -h $RW_SERVICE_IP -U $DB_USER -d $DATABASE
        ;;
        
    2)
        echo "Logging into the database..."
        psql -h $RW_SERVICE_IP -U $DB_USER -d $DATABASE
        ;;
        
    3)
        # Prompt for the table names to drop, separated by spaces
        read -p "Enter the names of the tables to drop (separated by spaces, default: facts): " table_names

        # Use default table name if no input is provided
        table_names=${table_names:-facts}

        if [[ -z "$table_names" || "$table_names" == "all" ]]; then
            # If no input is given or "all" is entered, drop all tables
            echo "No specific table names provided. Dropping all tables in the database..."
            
            # Generate the DROP TABLE command for all tables in the database
            drop_commands=$(psql -h $RW_SERVICE_IP -U $DB_USER -d $DATABASE -t -c "
                SELECT string_agg('DROP TABLE IF EXISTS ' || tablename || ';', ' ')
                FROM pg_tables
                WHERE schemaname = 'public';
            " -A)

            # Execute the combined DROP TABLE commands in a single psql call
            if [[ -n "$drop_commands" ]]; then
                psql -h $RW_SERVICE_IP -U $DB_USER -d $DATABASE -c "$drop_commands"
                echo "All tables dropped successfully."
            else
                echo "No tables found to drop."
            fi
        fi

        # Convert the space-separated list into an array
        IFS=' ' read -ra table_array <<< "$table_names"

        # Construct a single SQL command with multiple DROP TABLE statements
        drop_commands=""
        for table_name in "${table_array[@]}"; do
            # Trim whitespace from table name
            table_name=$(echo "$table_name" | xargs)
            drop_commands+="DROP TABLE IF EXISTS $table_name; "
        done

        # Execute the combined DROP TABLE commands in a single psql call
        echo "Executing drop commands for specified tables..."
        psql -h $RW_SERVICE_IP -U $DB_USER -d $DATABASE -c "$drop_commands"
        echo "Tables dropped successfully."
        ;;
    4)
        echo "Checking existing partitions and tablespaces..."
        psql -h $RW_SERVICE_IP -U $DB_USER -d $DATABASE < $SCRIPT_TABLESPACE
        ;;

    *)
        echo "Invalid choice. Please select 1, 2, or 3."
        ;;
esac
