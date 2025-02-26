require('dotenv').config();
const { exec } = require('child_process');

// Function to run shell commands
function runCommand(command) {
  return new Promise((resolve, reject) => {
    exec(command, (error, stdout, stderr) => {
      if (error) {
        reject(stderr);
      } else {
        resolve(stdout);
      }
    });
  });
}

// Upload file
async function uploadFile(filePath) {
  try {
    console.log(`Uploading ${filePath}...`);
    await runCommand(`filebase.sh upload ${filePath}`);
    console.log('Upload complete.');
  } catch (error) {
    console.error('Upload failed:', error);
  }
}

// List files
async function listFiles() {
  try {
    console.log('Listing files in the bucket...');
    const files = await runCommand(`filebase.sh list`);
    console.log(files);
  } catch (error) {
    console.error('Error listing files:', error);
  }
}

// Download file
async function downloadFile(fileName) {
  try {
    console.log(`Downloading ${fileName}...`);
    await runCommand(`filebase.sh download ${fileName}`);
    console.log('Download complete.');
  } catch (error) {
    console.error('Download failed:', error);
  }
}

// Delete file
async function deleteFile(fileName) {
  try {
    console.log(`Deleting ${fileName}...`);
    await runCommand(`filebase.sh delete ${fileName}`);
    console.log('File deleted.');
  } catch (error) {
    console.error('Delete failed:', error);
  }
}

// Example usage
(async () => {
  await uploadFile('example.txt'); // Change this to your file
  await listFiles();
  await downloadFile('example.txt');
  await deleteFile('example.txt');
})();
