#!/usr/bin/env ruby

#require 's3_website'

#c = Cli.new
#Cli.resolve_jar
# resolve_jar
# download_jar

version = ">= 0"

gem 's3_website', version
load Gem.bin_path('s3_website', 's3_website', version)

Cli.resolve_jar