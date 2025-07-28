import * as aws from "aws-sdk";

const S3_REGION = process.env.NODE_AWS_REGION || 'ru-central1'
const S3_BUCKET = process.env.NODE_AWS_BUCKET || ""

const s3Client = new aws.default.S3({
  accessKeyId: process.env.NODE_AWS_KEY || "",
  secretAccessKey: process.env.NODE_AWS_SECRET || "",
  region: S3_REGION,
  signatureVersion: process.env.NODE_AWS_SIGNATURE || 'v4',
  endpoint: process.env.NODE_AWS_ENDPOINT || 'https://storage.yandexcloud.net',
});

async function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function randomInteger(min, max) {
  const rand = min - 0.5 + Math.random() * (max - min + 1);

  return Math.round(rand);
}

export async function stanzaDelete(token, iteration) {
  console.log("stanzaDelete: iteration", iteration);

  await sleep(randomInteger(250, 750))

  const objects_list = await s3Client.listObjectsV2({
    Bucket: S3_BUCKET,
    ContinuationToken: token
  }).promise();

  const keys = (objects_list.Contents || []).reduce((acc, curr) => {
    if (curr.Key) {
      acc.push({ Key: curr.Key })
    }

    return acc;
  }, []);

  if (keys.length) {
    await sleep(randomInteger(250, 750))

    await s3Client.deleteObjects({
      Bucket: S3_BUCKET,
      Delete: {
        Objects: keys
      }
    }).promise()
  }

  if (objects_list.NextContinuationToken) {
    await stanzaDelete(objects_list.NextContinuationToken, iteration + 1)
  }
}
