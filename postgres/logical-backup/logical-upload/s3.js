const aws = require("aws-sdk")
const fs = require('fs');
const path = require('path')

const s3Client = new aws.S3({
  accessKeyId: process.env.NODE_AWS_KEY || "",
  secretAccessKey: process.env.NODE_AWS_SECRET || "",
  region: process.env.NODE_AWS_REGION || 'ru-central1',
  signatureVersion: process.env.NODE_AWS_SIGNATURE || 'v4',
  endpoint: process.env.NODE_AWS_ENDPOINT || 'https://storage.yandexcloud.net',
});

const S3_PREFIX = 'logical'
const S3_BUCKET = process.env.NODE_AWS_BUCKET || "backups"
const S3_ACL = process.env.NODE_AWS_ACL || 'authenticated-read'

const putParams = {
  ACL: S3_ACL,
  ContentEncoding: 'utf-8',
  Bucket: S3_BUCKET,
}

async function uploadBackup(filePath) {
  console.log("Upload started");
  
  const key = `${S3_PREFIX}/${path.basename(filePath)}`
  const buff = fs.createReadStream(filePath)

  const opts = {
    queueSize: 4, 
    partSize: 1024 * 1024 * 10
  };

  const params = {
    ...putParams,
    Key: key,
    Body: buff,
  };

  s3Client.upload(params, opts)
    .on('httpUploadProgress', function(evt) {
      const uploaded = evt.loaded / 1024 / 1024;
      console.log(`Part ${evt.part}, uploaded: ${Math.round(uploaded)}mb`); 
    })
    .send(function(err, data) {
      if (err) {
        throw err;
      }

      console.log(data)
      console.log(`File uploaded successfully. ${data.Location}`);
    });
}

async function downloadBackup(fileKey, filePath) {
  console.log("Download started");

  const { Body: file } = await s3Client.getObject({ Bucket: S3_BUCKET, Key: fileKey }).promise();

  fs.writeFile(filePath, file, function(err) {
    if (err) {
      return console.log(err);
    }
  });

  console.log("Download complete");
}

module.exports = {
  uploadBackup,
  downloadBackup
};
