#!/usr/bin/env ruby
require 'json'
require 'pp'
require 'curb'
# requires serialized flickr json file to be $stdin or specified on the command line and then
# downloads the flickr "l" with height > 720

$file_number = 1

def fetch_1_at_a_time(urls)

  easy = Curl::Easy.new
  easy.follow_location = true

  urls.each do|url|
    easy.url = url
    filename = sprintf("%04d", $file_number)+".jpg"
    $file_number += 1
    $stderr.print "filename:'#{filename}'"
    $stderr.print "url:'#{url}' :"
    File.open(filename, 'wb') do|f|
      easy.on_progress {|dl_total, dl_now, ul_total, ul_now| $stderr.print "="; true }
      easy.on_body {|data| f << data; data.size }   
      easy.perform
      $stderr.puts "=> '#{filename}'"
    end
  end
end

ARGF.each_line do |line|
  serializedJSON = line
  flickr_data_page =  JSON.parse(serializedJSON)
  total  = flickr_data_page["photos"]["total"].to_i
  total_pages = flickr_data_page["photos"]["pages"].to_i
  page = flickr_data_page["photos"]["page"].to_i
  $stderr.printf "Total photos to download:%d page:%d of:%d\n", total, page, total_pages
  
  total_to_download_for_this_page = 0
  if page == total_pages 
    total_to_download_for_this_page = total % 250 # 250 per page
  else
    total_to_download_for_this_page = 250
  end
  url_index = 0
  urls = []
  0.upto(total_to_download_for_this_page - 1) do |i|
    if flickr_data_page["photos"]["photo"][i].has_key?("url_l")
      if flickr_data_page["photos"]["photo"][i]["height_l"].to_i >= 720
        urls[url_index] = flickr_data_page["photos"]["photo"][i]["url_l"]    
        url_index += 1
      end
    end    
  end
  fetch_1_at_a_time(urls)
end
