#!/bin/bash

# Check if GAM is installed
if ! command -v gam &> /dev/null; then
    echo "GAM is not installed. Please install GAM first: https://github.com/jay0lee/GAM"
    exit 1
fi

# We would set the gam peth variable here.

# Get Franchise Name as input
read -p "Enter Franchise Name: " franchise_name

# Get Franchise Country as input (assuming it's either "Canada" or "US")
read -p "Enter Franchise Country (Canada or US): " franchise_country

# Get Franchise State/Province as input (must be abbreviation "AZ" == Arizona, "ON" == Ontario etc.)
read -p "Enter Franchise State (or Province). This must be the short form, two letter, abbeviation: " franchise_state

# Define the base path for OUs
base_path="/FP/"

# Create OU with location-specific path. This should be broken down as $base_path/$franchise_location_$franchise_state_$franchise_name
country_code=""
if [ "$franchise_country" == "Canada" ]; then
    country_code="CA"
elif [ "$franchise_country" == "US" ]; then
    country_code="US"
else
    echo "Invalid location. Please enter either 'Canada' or 'US'."
    exit 1
fi

full_path="$base_path$franchise_country/${country_code}_${franchise_state}_$franchise_name"

# Create top-level Franchise OU
gam create org "$full_path"

# Create sub-OUs
sub_ous=("Owner" "Operations" "CD" "CG")

for sub_ou in "${sub_ous[@]}"; do
    sub_ou_path="$full_path/$sub_ou"
    gam create org "$sub_ou_path"
done

# Create Groups. this currently looks wonky. needs work
groups=("" "Sales" "IT") # These groups are wrong

for sub_ou in "${sub_ous[@]}"; do
    for group in "${groups[@]}"; do
        full_group_name="${franchise_name}_${sub_ou}_${group}@nursenextdoor.com"
        gam create group "$full_group_name" parentorg "$full_path/$sub_ou" # These cannot be assoscaited with the sub ou's
    done
done

echo "OU and Groups created successfully for $franchise_name in $franchise_country."