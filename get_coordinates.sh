#!/bin/bash
#The job should run on the standard partition
#SBATCH -p standard

#The name of the job is coords accessions
#SBATCH -J coords

#The job requires 1 compute node
#SBATCH -N 1

#SBATCH --account=XXX

#The job requires 1 task per node
#SBATCH --ntasks-per-node=1

#SBATCH --cpus-per-task=12

#SBATCH --mem=10gb

#The maximum walltime of the job is 3 days
#SBATCH -t 3-00:00:00

#SBATCH --mail-user=XXX
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

# Input file containing biosample accessions (one per line)
input_file="accessions.txt"

# Output file for the results
output_file="biosample_coordinates.txt"

# Print header to the output file
echo -e "Biosample Accession\tLatitude\tLongitude" > "$output_file"

# Read all accessions into an array
mapfile -t accessions < "$input_file"

# Loop through each biosample accession in the array
for biosample_accession in "${accessions[@]}"; do
    # Fetch the biosample data
    response=$(esearch -db biosample -query "$biosample_accession" | efetch -format docsum)

    # Extract the first latitude
    latitude=$(echo "$response" | grep -oP '(?<=<Attribute attribute_name="geographic location \(latitude\)">).*?(?=</Attribute>)' | head -n 1)

    # Extract the first longitude
    longitude=$(echo "$response" | grep -oP '(?<=<Attribute attribute_name="geographic location \(longitude\)">).*?(?=</Attribute>)' | head -n 1)

    # If latitude or longitude not found, set to NA
    latitude=${latitude:-NA}
    longitude=${longitude:-NA}

    # Append results to the output file
    echo -e "$biosample_accession\t$latitude\t$longitude" >> "$output_file"
done

echo "Coordinates have been saved to $output_file."

