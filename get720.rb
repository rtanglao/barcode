#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'pp'
require 'json'

ARGF.each_line do |line|
  serializedJSON = line
  flickr_data_page =  JSON.parse(serializedJSON)
  total  = flickr_data_page["photos"]["total"].to_i
  page  = flickr_data_page["photos"]["page"].to_i
  total_pages = flickr_data_page["photos"]["pages"].to_i
  if page == total_pages
    limit = total % 250
  else
    limit = 250
  end
  0.upto limit-1 do |photo_index|
    if flickr_data_page["photos"]["photo"][photo_index].has_key?("url_l")
      if flickr_data_page["photos"]["photo"][photo_index]["height_l"].to_i >= 720
        printf( "height of l:%s\n", flickr_data_page["photos"]["photo"][photo_index]["height_l"])
      end
    end
  end
end
