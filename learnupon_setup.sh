#!/bin/bash

# This script is meant to take the Franchise name as a variable, and the user email addresses as variables and create the sctrutuces needed in LearnUpon
# This will by done via the API endpoints found at https://nursenextdoor.learnupon.com/api/v1/
# This script with use curl

# Create Users
# Create Groups
# Add Users to Groups

# Load environment variables from .env file
if [ -f .env ]; then
  export $(cat .env | xargs)
fi

# LearnUpon API endpoint
API_ENDPOINT="https://nursenextdoor.learnupon.com/api/v1"

# Your LearnUpon API username and password
API_USERNAME="API_USERNAME"
API_PASSWORD="API_PASSWORD"

# Function to make API requests
make_request() {
  curl -X "$1" \
    -u "$API_USERNAME:$API_PASSWORD" \
    -H "Content-Type: application/json" \
    -d "$2" \
    "$API_ENDPOINT/$3"
}

# Function to create a user and capture user_id
create_user_and_capture_id() {
  read -p "Enter the email address for the new user: " USER_EMAIL
  read -p "Enter the first name of the user" USER_FIRST
  read -p "Enter the last name of the user" USER_LAST

  USER_DATA='{
    "first_name": "'"$USER_FIRST"'",
    "last_name": "'"$USER_LAST"'",
    "email": "'"$USER_EMAIL"'"
  }'

  # Create the user
  response=$(make_request "POST" "$USER_DATA" "users")

  # Extract user_id from the response
  user_id=$(echo "$response" | jq -r '.id')

  # Store user_id in a variable
  echo "User created with user_id: $user_id"
}

# Example: Create a group
create_group() {
  GROUP_DATA='{
    "name": "Sales Team"
  }'

  make_request "POST" "$GROUP_DATA" "groups"
}

# Example: Associate a user with a group
associate_user_with_group() {
  USER_ID="USER_ID_HERE"  # Replace with the actual user ID
  GROUP_ID="GROUP_ID_HERE"  # Replace with the actual group ID

  make_request "PUT" '{}' "groups/$GROUP_ID/users/$USER_ID"
}

# Main script

# Uncomment the following lines to execute the examples
# create_user
# create_group
# associate_user_with_group
