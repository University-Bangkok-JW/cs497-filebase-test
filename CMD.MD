# Information

This file is created to manually execute commands for debugging functions.

## 🔍 Debugging Steps

### Check if MinIO Client (mc) is Configured Properly

Inside your Docker container, run:
```bash
docker run --rm -it --env-file .env filebase-nodejs /bin/bash
```

Then inside the container, check if Filebase is correctly added:
```bash
mc alias list
```

Expected Output:
```bash
filebase  https://s3.filebase.com  ACCESS_KEY  SECRET_KEY  s3v4
```

If filebase is missing, manually add it:
```bash
mc alias set filebase $FILEBASE_ENDPOINT $FILEBASE_ACCESS_KEY $FILEBASE_SECRET_KEY
```

## Verify Your Bucket Exists

Inside the container, run:
```bash
mc ls filebase/
```

If your bucket (cs497-test-db) is missing, create it manually:
```bash
mc mb filebase/cs497-test-db
```

## Manually Try Uploading a File
```bash
touch testfile.txt
mc cp testfile.txt filebase/cs497-test-db/
mc ls filebase/cs497-test-db/
```
Expected Output
If successful, `mc ls` should list `testfile.txt`.

If the file still doesn’t appear in Filebase, check logs with `--debug`:
```bash
mc cp testfile.txt filebase/cs497-test-db/ --debug
```

## Fix the Upload Script (filebase.sh)

Modify `filebase.sh` to include better debugging logs.
```bash
#!/bin/bash

# Load environment variables
export $(grep -v '^#' .env | xargs)

# Configure Filebase in MinIO Client
echo "Setting up MinIO Client for Filebase..."
mc alias set filebase $FILEBASE_ENDPOINT $FILEBASE_ACCESS_KEY $FILEBASE_SECRET_KEY

# Upload File
upload_file() {
    echo "Uploading file: $1 to bucket: $FILEBASE_BUCKET_NAME..."
    mc cp "$1" filebase/$FILEBASE_BUCKET_NAME/ --debug
    echo "Upload finished."
}

# List Files
list_files() {
    echo "Listing files in: $FILEBASE_BUCKET_NAME..."
    mc ls filebase/$FILEBASE_BUCKET_NAME/ --debug
}

# Download File
download_file() {
    echo "Downloading file: $1 from bucket: $FILEBASE_BUCKET_NAME..."
    mc cp filebase/$FILEBASE_BUCKET_NAME/"$1" ./ --debug
    echo "Download finished."
}

# Command Usage
usage() {
    echo "Usage: $0 {upload|list|download} [filename]"
    exit 1
}

# Execute Command
if [ "$#" -lt 1 ]; then
    usage
fi

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
```

Make it executable:
```bash
chmod +x filebase.sh
```

## Rebuild and Test Again

Rebuild the Docker image:
```bash
docker build -t filebase-nodejs .
```

Run the container:
```bash
docker run --rm --env-file .env filebase-nodejs
```

Manually test:
```bash
./filebase.sh upload example.txt
./filebase.sh list
```

# 📌 Final Steps

1.Verify Filebase is connected using `mc alias list`.
2.Manually check the bucket using `mc ls filebase/cs497-test-db/`.
3.Try uploading a file manually inside the container.
4.Check logs with `--debug` if the file is not uploading.

Try these steps and let me know what errors/logs you get. 🚀
