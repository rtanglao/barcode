#!/usr/bin/env ruby
require 'json'
require 'net/http'
require 'pp'
require 'Time'
require 'uri'
require 'parseconfig'

flickr_config = ParseConfig.new('flickr.conf').params
api_key = flickr_config['api_key']
user_id = "95601478@N00"

content_type = "1" # photos only
sort = "date-taken-asc"
per_page = "250" # geo photos limited by flickr to only 250 per page
extras="original_format,date_taken,geo,tags,o_dims,views,url_sq,url_t,url_s,url_m,url_o,url_z,url_l" # get all the meta data!
page = 1



def getResponse(url)

  http = Net::HTTP.new("api.flickr.com",80)

  request = Net::HTTP::Get.new(url)
  resp = http.request(request)
  if resp.code != "200"
    $stderr.puts "Error: #{resp.code} from:#{url}"
    raise JSON::ParserError # This is a kludge. Should return a proper exception instead!
  end

  result = JSON.parse(resp.body)
  return result
end

photos_to_retrieve = 250
first_page = true
photos_per_page = 0
while photos_to_retrieve > 0
  search_url = "/services/rest/?method=flickr.photos.search&api_key="+api_key+
    "&format=json&nojsoncallback=1&content_type="+content_type+
    "&per_page="+per_page+"&user_id="+user_id+
    "&extras="+extras+"&sort="+sort+"&page="+page.to_s
  photos_on_this_page = getResponse(search_url)
  if first_page
    first_page = false
    photos_per_page = photos_on_this_page["photos"]["perpage"].to_i
    photos_to_retrieve = photos_on_this_page["photos"]["total"].to_i - photos_per_page
  else
    photos_to_retrieve -= photos_per_page
  end
  page += 1
  $stderr.puts photos_on_this_page
  print JSON.generate(photos_on_this_page), "\n"
end
