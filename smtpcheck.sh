#!/bin/bash

# Usage: ./smtp_open_relay_test.sh <host_ip> <port>
# Example: ./smtp_open_relay_test.sh 10.10.11.88 25

# Check if IP and port arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <host_ip> <port>"
    exit 1
fi

# Assign arguments and constants
HOST_IP="$1"
PORT="$2"
FROM_EMAIL="test1@test1.com"
TO_EMAIL="sheerazali@cobaltcore.io"
SUBJECT="SMTP Open Mail Relay Test"
MESSAGE="SMTP Open Mail Relay Test from host $HOST_IP on port $PORT."

# Use here document to input commands into telnet
{
  sleep 1
  echo "helo test"
  sleep 1
  echo "MAIL FROM: $FROM_EMAIL"
  sleep 1
  echo "RCPT TO: $TO_EMAIL"
  sleep 1
  echo "DATA"
  sleep 1
  echo "SUBJECT: $SUBJECT"
  echo "$MESSAGE"
  echo "."
  sleep 1
  echo "QUIT"
} | telnet "$HOST_IP" "$PORT"

echo "SMTP Open Relay Test email sent to $TO_EMAIL from $HOST_IP on port $PORT"
