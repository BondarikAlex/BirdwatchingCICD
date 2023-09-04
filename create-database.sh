#!/bin/bash

# Exit immediately if a command exits with a non zero status
set -e
# Treat unset variables as an error when substituting
set -u

function create_database() {
	database=$1
	echo "  Creating user and database '$database'"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	    CREATE USER $database;
	    CREATE DATABASE $database;
	    GRANT ALL PRIVILEGES ON DATABASE $database TO $database;
EOSQL
}

if [ -n "$POSTGRES_DATABASE" ]; then
	echo "Creating database: $POSTGRES_DATABASE"
	for db in $(echo $POSTGRES_DATABASE | tr ',' ' '); do
		create_database $db
	done
	echo " Database created"
fi