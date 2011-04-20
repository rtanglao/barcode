#!/usr/bin/env ruby

require 'fileutils'

files = Dir.glob("*.jpg")

files.each do |f|
  /[a-z]*-([0-9]*)\.jpg/i =~ f # assuming no unicode or other non alphanumeric characters
  new_name = sprintf("%05d", Regexp.last_match(1).to_i)+".jpg" #kludge add error checking sometime
  printf("renaming:%s to %s\n",f,new_name)
  File.rename(f, new_name)
end 
