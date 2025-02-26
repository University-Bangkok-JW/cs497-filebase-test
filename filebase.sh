#!/bin/bash

# Load environment variables
export $(grep -v '^#' .env | xargs)

# Configure Filebase in MinIO Client (Log output)
echo "Adding Filebase alias..."
mc alias set filebase $FILEBASE_ENDPOINT $FILEBASE_ACCESS_KEY $FILEBASE_SECRET_KEY

# Function to upload a file
upload_file() {
    echo "Uploading file: $1 to bucket: $FILEBASE_BUCKET_NAME..."
    mc cp "$1" filebase/$FILEBASE_BUCKET_NAME/ --debug
}

# Function to list files in the bucket
list_files() {
    echo "Listing files in: $FILEBASE_BUCKET_NAME..."
    mc ls filebase/$FILEBASE_BUCKET_NAME/ --debug
}

# Function to download a file
download_file() {
    echo "Downloading file: $1 from bucket: $FILEBASE_BUCKET_NAME..."
    mc cp filebase/$FILEBASE_BUCKET_NAME/"$1" ./ --debug
}

# Help function
usage() {
    echo "Usage: $0 {upload|list|download} [filename]"
    exit 1
}

# Check arguments
if [ "$#" -lt 1 ]; then
    usage
fi

# Execute function based on command
case "$1" in
    upload)
        if [ -z "$2" ]; then echo "Missing filename"; exit 1; fi
        upload_file "$2"
        ;;
    list)
        list_files
        ;;
    download)
        if [ -z "$2" ]; then echo "Missing filename"; exit 1; fi
        download_file "$2"
        ;;
    *)
        usage
        ;;
esac
