#!/bin/bash

# Usage: ./find_and_check_smtp.sh <subnet>
# Example: ./find_and_check_smtp.sh 10.0.0.0/8

# Check if subnet argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <subnet>"
    exit 1
fi

# Assign subnet variable
SUBNET="$1"

# Scan the specified subnet for open SMTP ports and save results to smtpopen.out
echo "Scanning $SUBNET for open SMTP ports..."
masscan "$SUBNET" -p25,587,465,2525 --rate=10000 | tee smtpopen.out

# Loop over found hosts and ports, then run smtpcheck.sh for each combination
echo "Running SMTP open relay test on discovered hosts..."
paste <(cat smtpopen.out | cut -d " " -f 4 | cut -d "/" -f 1) <(cat smtpopen.out | cut -d " " -f 6) | \
while read -r port host; do
    echo "Testing $host on port $port..."
    ./smtpcheck.sh "$host" "$port"
    echo "--------------------------------"
done

echo "SMTP open relay test completed."
