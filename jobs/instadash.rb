require 'instagram'
 
# Instagram Client ID from http://instagram.com/developer
Instagram.configure do |config|
  config.client_id = 'b7dc77e192ca46cda20993e8aae72573'
end
 
# Latitude, Longitude for location
instadash_location_lat = '40.744281'
instadash_location_long = '-73.978134'
 
SCHEDULER.every '1m', :first_in => 0 do |job|
  photos = Instagram.media_search(instadash_location_lat,instadash_location_long)
  if photos
    photos.map! do |photo|
      { photo: "#{photo.images.low_resolution.url}" }
    end    
  end
  send_event('instadash', photos: photos)
end
