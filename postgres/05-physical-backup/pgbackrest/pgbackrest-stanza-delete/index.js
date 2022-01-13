const yargs = require('yargs');

const s3 = require('./s3')

const argv = yargs
  .command('stanzaDelete', 'Delete stanza')
  .help()
  .alias('help', 'h')
  .argv;

console.log("argv", argv);

if (argv._.includes('stanzaDelete')) {
  s3.stanzaDelete()
}
