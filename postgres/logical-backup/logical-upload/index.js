const yargs = require('yargs');

const s3 = require('./s3')

const argv = yargs
  .command('uploadBackup', 'Upload backup', {
    filePath: {
      description: 'Path to backup file',
      alias: 'p',
      type: 'string',
    }
  })
  .command('downloadBackup', 'Download backup', {
    fileKey: {
      description: 'File path from cloud',
      alias: 'k',
      type: 'string',
    },
    filePath: {
      description: 'Path to backup file save',
      alias: 'p',
      type: 'string',
    }
  })
  .help()
  .alias('help', 'h')
  .argv;

console.log("argv", argv);

if (argv._.includes('uploadBackup')) {
  s3.uploadBackup(argv.p)
} else if (argv._.includes('downloadBackup')) {
  s3.downloadBackup(argv.fileKey, argv.filePath)
}
