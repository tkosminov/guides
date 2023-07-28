const aws = require("aws-sdk")
const fs = require('fs');
const path = require('path')

const S3_PREFIX = 'assets'
const S3_BUCKET = process.env.NODE_AWS_BUCKET || ""
const S3_ACL = process.env.NODE_AWS_ACL || 'authenticated-read'

const s3Client = new aws.S3({
  accessKeyId: process.env.NODE_AWS_KEY || "",
  secretAccessKey: process.env.NODE_AWS_SECRET || "",
  region: process.env.NODE_AWS_REGION || 'ru-central1',
  signatureVersion: process.env.NODE_AWS_SIGNATURE || 'v4',
  endpoint: process.env.NODE_AWS_ENDPOINT || 'https://storage.yandexcloud.net',
});

const putParams = {
  ACL: S3_ACL,
  ContentEncoding: 'utf-8',
  Bucket: S3_BUCKET,
}

async function getBackupFiles(token) {
  const keys = []

  const objects_list = await s3Client.listObjectsV2({
    Bucket: S3_BUCKET,
    Prefix: S3_PREFIX,
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

async function deleteOldBackups() {
  console.log("Delete started");

  const keys = await getBackupFiles();

  if (!keys.length) {
    console.log("Backup folder is empty");

    return;
  }

  /**
   * По идее этот скрипт вызывается 1-го числа каждого месяца
   * Т.е. за текущий месяц бэкапов еще нету, т.к. месяц только началася
   */

  const current_month = new Date().getMonth() + 1;
  const current_year = new Date().getFullYear();

  console.log('current_year', current_year, 'current_month', current_month);

  /**
   * За предыдущий месяц надо оставить все бэкапы, которые создавались
   * А создаваться они должны раз в неделю по воскресеньям
   */

  let prev_month = current_month - 1;
  let prev_year = current_year;

  if (prev_month === 0) {
    prev_month = 12;
    prev_year = current_year - 1;
  }

  console.log('prev_year', prev_year, 'prev_month', prev_month);

  /**
   * А вот в месяце, который был до предыдущего необходимо удалить
   * все бэкапы, кроме последнего
   */

  let work_month = prev_month - 1;
  let work_year = prev_year;

  if (work_month === 0) {
    work_month = 12;
    work_year = work_year - 1;
  }

  console.log('work_year', work_year, 'work_month', work_month);

  const work_backups = keys.filter((key) => {
    /**
     * Пример названия ключа:
     * 'logical/2022-01-12T17:16:54.tar.xz.gpg'
     */
    const str_date = key.Key.split('/')[1].split('.')[0];

    const date = new Date(str_date);

    if (date.getFullYear() === work_year && (date.getMonth() + 1) === work_month) {
      return true;
    }

    return false;
  })

  /**
   * По идее списки присылаются в порядке создания, а фильтр на порядок влиять не должен,
   * а значит можно просто взять из получившегося массива все элементы, кроме последнего и удалить их.
   */

  const work_backups_to_delete = work_backups.slice(0, -1)

  if (!work_backups_to_delete.length) {
    console.log("Backups to delete not found");

    return;
  }

  console.log('work_backups_to_delete', work_backups_to_delete)

  /**
   * За раз можно удалять не больше 1000 элементов.
   * У нас их, конечно, не 1000, но а вдруг?!
   */

  const iteration_count = Math.ceil(work_backups_to_delete.length / 1000);

  for (let i = 0; i < iteration_count; i++) {
    const iteration_keys = work_backups_to_delete.slice(i * 1000, (i + 1) * 1000)

    await s3Client.deleteObjects({
      Bucket: S3_BUCKET,
      Delete: {
        Objects: iteration_keys
      }
    }).promise()
  }

  console.log("Delete complete");
}

module.exports = {
  uploadBackup,
  downloadBackup,
  deleteOldBackups
};
