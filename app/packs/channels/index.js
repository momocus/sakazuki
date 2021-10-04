// Load all the channels within this directory and all subdirectories.
// Channel files must be named *_channel.js.

/* eslint-disable
   @typescript-eslint/no-unsafe-assignment,
   @typescript-eslint/no-unsafe-member-access,
   @typescript-eslint/no-unsafe-call */
const channels = require.context(".", true, /_channel\.js$/)
channels.keys().forEach(channels)
