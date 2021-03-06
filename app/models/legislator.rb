class Legislator < ApplicationRecord
  def self.house_majority
    Legislator.where(chamber: 'house', caucus:'majority')
  end

  def self.house_minority
    Legislator.where(chamber: 'house', caucus:'minority')
  end

  def self.senate_minority
    Legislator.where(chamber: 'senate', caucus:'minority')
  end

  def self.house_majority
    Legislator.where(chamber: 'senate', caucus:'majority')
  end

  def self.house
    Legislator.where(chamber: 'house')
  end

  def self.senate
    Legislator.where(chamber: 'senate')
  end

  def self.tweet_weather
      key = 'befdfe87af5677e6b00d6b3f493ee649'
      client = Twitter::REST::Client.new do |config|
          config.consumer_key        = "fUEm2nro0bkgWUV77RqNRQCf8"
          config.consumer_secret     = "LB5ZgrHEox5qzGxZqHhh4THmxMWRIyiYaVrAqxEntZjYJqHJSL"
          config.access_token        = "803148309124640768-vkpeC5TpT3HtbapZpVPTBv6PRja9X5U"
          config.access_token_secret = "ivU7vkT2T3C5QTmM5uGqEyiJfqJFrBHmLgztRA7zNUvAT"
      end
      leggies = Legislator.all
      options = { units: "imperial", APPID: key }
      conditions = OpenWeather.current("Juneau, AK", options)
      resp = conditions.parsed_response
      desc = resp['weather'][0]['description']
      temp = resp['main']['temp']
      tweet_weather(leggies, desc, temp, client)
  end

  private
  def tweet_weather(leggies, desc, temp, client)
      leggies.each do |leg|
          client.update("Good morning, #{leg.handle} Current conditions in Juneau: #{desc}, #{temp} degrees")
          puts "weather tweeted to #{leg.handle}"
      end
  end
end
