import json
import psycopg2
import sys

def export_to_json(database, user, password, host, port, output_file):
    try:
        # Connect to your PostgreSQL database
        connection = psycopg2.connect(
            dbname=database,
            user=user,
            password=password,
            host=host,
            port=port
        )
        
        cursor = connection.cursor()

        # Execute the query
        cursor.execute("SELECT tour_data FROM app_tourmodel WHERE id = 712")
        result = cursor.fetchone()

        if result:
            tour_data = result[0]

            # Write the result to a JSON file
            with open(output_file, 'w') as json_file:
                json.dump(tour_data, json_file, indent=4)

            print(f"Data exported to {output_file}")
        else:
            print("No data found for id = 712")

    except (Exception, psycopg2.Error) as error:
        print(f"Error while connecting to PostgreSQL: {error}")
    finally:
        if connection:
            cursor.close()
            connection.close()

if __name__ == "__main__":
    if len(sys.argv) != 7:
        print("Usage: python export_to_json.py <database> <user> <password> <host> <port> <output_file>")
        sys.exit(1)

    database = sys.argv[1]
    user = sys.argv[2]
    password = sys.argv[3]
    host = sys.argv[4]
    port = sys.argv[5]
    output_file = sys.argv[6]

    export_to_json(database, user, password, host, port, output_file)

