#!/usr/bin/env ruby
#
require 'opener/daemons'
require 'opener/tokenizer'

options = Opener::Daemons::OptParser.parse!(ARGV)
daemon = Opener::Daemons::Daemon.new(Opener::Tokenizer, options)
daemon.start
