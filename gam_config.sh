#!/bin/bash

# Check if GAM is installed
if ! command -v gam &> /dev/null; then
    echo "GAM is not installed. Please install GAM first: https://github.com/jay0lee/GAM"
    exit 1
fi

# Get Franchise Name as input
read -p "Enter Franchise Name: " franchise_name

# Get Franchise Location as input (assuming it's either "Canada" or "US")
read -p "Enter Franchise Location (Canada or US): " franchise_location

# Define the base path for OUs
base_path="/Nurse Next Door/FP/"

# Create OU with location-specific path. This should be broken down as $base_path/$franchise_location_$franchise_state_$franchise_name
location_path=""
if [ "$franchise_location" == "Canada" ]; then
    location_path="Canada/CA_"
elif [ "$franchise_location" == "US" ]; then
    location_path="US/US_"
else
    echo "Invalid location. Please enter either 'Canada' or 'US'."
    exit 1
fi

full_path="$base_path$location_path$franchise_name"

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

echo "OU and Groups created successfully for $franchise_name in $franchise_location."
