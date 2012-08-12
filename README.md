puppet-hubot
============
James Fryman <james@frymanet.com>

This module deploys Hubot

# Quick Start

Install and bootstrap a Hubot instance

Tested on Debian Squeeze

# Requirements

Puppet Labs Standard Library
- http://github.com/puppetlabs/puppetlabs-stdlib

Puppet Labs NodeJS
- http://github.com/puppetlabs/puppetlabs-nodejs

<pre>
  class { 'hubot':
    adapter => 'irc',
    irc_nickname => 'crunchy',
    irc_server   => 'irc.freenode.com',
    irc_rooms    => ['#soggies'],
  }
</pre>

# TODO
- Add Campfire support to Init Script/packages.js
- Validate Ubuntu Support
- Add Redhat Support?

