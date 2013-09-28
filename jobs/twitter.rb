require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
Twitter.configure do |config|
  config.consumer_key = 'DPbE2arP0RNAb4w8guB7w'
  config.consumer_secret = 'Y2CKaOJnx5NSoWKHiLHnJriVVZ9NIv7XaUAYgeB00k'
  config.oauth_token = '582823637-0uonFCBMTh43mV9hjW0gxPrGIGOu5ZIWem8dLJmR'
  config.oauth_token_secret = 'eWwHljnnaP53qNLmsrOInLG2XNVrpNEWgXaS2tEe8'
end

search_term = URI::encode('#todayilearned')

SCHEDULER.every '5m', :first_in => 0 do |job|
  begin
    tweets = Twitter.search("#{search_term}").results

    if tweets
      tweets.map! do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end
