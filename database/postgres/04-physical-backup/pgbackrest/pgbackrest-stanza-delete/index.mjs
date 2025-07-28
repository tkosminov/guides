import yargs from 'yargs';
import { hideBin } from 'yargs/helpers'

import { stanzaDelete } from './s3.mjs';

const argv = yargs(hideBin(process.argv)).command('stanzaDelete', 'Delete stanza')
  .help()
  .alias('help', 'h')
  .argv;

console.log("argv", argv);

if (argv._.includes('stanzaDelete')) {
  console.log("stanzaDelete: start");

  await stanzaDelete(null, 0)

  console.log("stanzaDelete: complete");
}
