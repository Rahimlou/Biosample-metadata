#!/bin/bash
#The job should run on the standard partition
#SBATCH -p standard

#The name of the job is biosample accessions
#SBATCH -J biosample

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

# File containing SRA accessions (one per line)
sra_file=$(cat sra_accessions.txt)  # Change this to your filename

# Read each SRA accession from the file
for acc in $sra_file;
do
    # Fetch the BioSample accession
    biosample=$(esearch -db sra -query $acc | efetch -format runinfo | cut -f 2)

    # Print the result
    if [ -n "$biosample" ]; then
        echo -e "$acc\t$biosample" >> biosample_results.txt
    else
        echo -e "$acc\tNo BioSample Found" >> biosample_results.txt
    fi
done

