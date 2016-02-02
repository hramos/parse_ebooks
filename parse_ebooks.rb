require "twitter"

use_markov = true

Twitter.configure do |config|
  config.consumer_key = "YOUR_CONSUMER_KEY"
  config.consumer_secret = "YOUR_CONSUMER_SECRET"
  config.oauth_token = "YOUR_OAUTH_TOKEN"
  config.oauth_token_secret = "YOUR_OAUTH_TOKEN_SECRET"
end

sources = ["sessions.txt", "hosting.txt", "relations.txt", "push.txt", "ios.txt", "android.txt", "windows.txt", "js.txt", "cloud.txt", "data.txt"]

file = File.open("sources/" + sources.sample, "rb")
string = file.read
file.close

if use_markov
  words = string.split(" ")

  words.map! do |w|
    w.gsub("]","").gsub("[","").gsub(/\(\)/, "").gsub(":","")
  end

  markov = {}
  (0...words.size).each do |index|
    markov[words[index]] ||= []
    markov[words[index]] << words[index + 1]
  end

  text = [words.sample]
  15.times do
    text << markov[text.last].sample
  end

  status = text.join(" ")

else
  words = string.split(" ")

  words.map! do |w|
    w.gsub("]","").gsub("[","").gsub(/\(\)/, "")
  end

  status = words.sample(15).join(" ")
end

if status.length > 140
  status = status[0..139]
end

tweet = Twitter.update(status)
if tweet.created_at
  puts "Tweeted: #{tweet.text}"
else
  puts "Failed."
end
