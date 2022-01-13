const aws = require("aws-sdk")

const S3_REGION = process.env.NODE_AWS_REGION || 'ru-central1'
const S3_BUCKET = process.env.NODE_AWS_BUCKET || ""

const s3Client = new aws.S3({
  accessKeyId: process.env.NODE_AWS_KEY || "",
  secretAccessKey: process.env.NODE_AWS_SECRET || "",
  region: S3_REGION,
  signatureVersion: process.env.NODE_AWS_SIGNATURE || 'v4',
  endpoint: process.env.NODE_AWS_ENDPOINT || 'https://storage.yandexcloud.net',
});

async function getBackupFiles(token) {
  const keys = []

  const objects_list = await s3Client.listObjectsV2({
    Bucket: S3_BUCKET,
    ContinuationToken: token
  }).promise();

  (objects_list.Contents || []).forEach((obj) => {
    if (obj.Key) {
      keys.push({ Key: obj.Key });
    }
  });

  if (objects_list.NextContinuationToken) {
    return keys.concat(await getBackupFiles(objects_list.NextContinuationToken))
  }

  return keys;
}

async function stanzaDelete() {
  console.log("Delete started");

  const keys = await getBackupFiles();

  if (keys.length) {
    const iteration_count = Math.ceil(keys.length / 1000);

    for (let i = 0; i < iteration_count; i++) {
      const iteration_keys = keys.slice(i * 1000, (i + 1) * 1000)

      await s3Client.deleteObjects({
        Bucket: S3_BUCKET,
        Delete: {
          Objects: iteration_keys
        }
      }).promise()
    }
  }

  console.log("Delete complete");
}

module.exports = {
  stanzaDelete
};
