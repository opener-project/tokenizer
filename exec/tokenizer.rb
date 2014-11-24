#!/usr/bin/env ruby

require 'opener/daemons'

require_relative '../lib/opener/tokenizer'

daemon = Opener::Daemons::Daemon.new(Opener::Tokenizer)

daemon.start
