require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = '4NmeKykVdfufaJ7YfPqdA'
  config.consumer_secret = 'Bv7P25gC3A7ISo9wS71ITxYBHmZik419QQBeK0kn5u0'
  config.oauth_token = '37573930-4ANdjBDu0Y19CoGrZMvPBwjLyXiKAxbyUbsv93Moo'
  config.oauth_token_secret = 'ogun6qBtqiCRrYZMmFQ0Cqy8QnWKYxzR8jkZC2pPXBORi'
end

search_term = URI::encode('#todayilearned')

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end