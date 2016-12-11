
WEATHER_KEY = 'befdfe87af5677e6b00d6b3f493ee649'
class Api::TweetsController < ApplicationController
    def create
        client = Twitter::REST::Client.new do |config|
            config.consumer_key        = "ZU67a7iOA29euOUtdgmNykEc0"
            config.consumer_secret     = "ZON03RiZPHBgvFXFF3wmjkPeYcfF0gxXXBL4qYpgvmi9ycXIA5"
            config.access_token        = current_user.token
            config.access_token_secret = current_user.secret
        end
        # if tweets_params['weather']
        #     byebug
        #     leggies = Legislator.all
        #     options = { units: "imperial", APPID: WEATHER_KEY }
        #     conditions = OpenWeather.current("Juneau, AK", options)
        #     resp = conditions.parsed_response
        #     desc = resp['weather'][0]['description']
        #     temp = in_fahrenheit(resp['main']['temp'].to_i)
        #     tweet_weather(leggies, desc, temp, client)
            #.parsed_response
            #{
            #     "coord"=>{"lon"=>-134.42, "lat"=>58.3},
            #     "weather"=>[
            #         {"id"=>500,
            #         "main"=>"Rain",
            #         "description"=>"light rain",
            #         "icon"=>"10n"
            #         }
            #     ],
            #     "base"=>"stations",
            #     "main"=>{
            #         "temp"=>6,
            #         "pressure"=>989,
            #         "humidity"=>87,
            #         "temp_min"=>6,
            #         "temp_max"=>6
            #     },
            #     "visibility"=>12874,
            #     "wind"=>{
            #         "speed"=>8.2,
            #         "deg"=>120,
            #         "gust"=>10.8
            #     },
            #     "clouds"=>{
            #         "all"=>90
            #     },
            #     "dt"=>1480744560,
            #     "sys"=>{
            #         "type"=>1,
            #         "id"=>86,
            #         "message"=>0.2335,
            #         "country"=>"US",
            #         "sunrise"=>1480785896,
            #         "sunset"=>1480810234
            #     },
            #     "id"=>5554072,
            #     "name"=>"Juneau",
            #     "cod"=>200
            # }
        #     redirect_to root_path
        #     return
        # end
        if tweets_params['filter'] == 'all_house'
            leggies = Legislator.house
        elsif tweets_params['filter'] == 'all_senate'
            leggies = Legislator.senate
        elsif tweets_params['filter'] == 'house_minority'
            leggies = Legislator.house_minority
        elsif tweets_params['filter'] == 'house_majority'
            leggies = Legislator.house_majority
        elsif tweets_params['filter'] == 'senate_minority'
            leggies = Legislator.senate_minority
        elsif tweets_params['filter'] == 'senate_majority'
            leggies = Legislator.senate_majority
        elsif tweets_params['filter'] == 'all'
            leggies = Legislator.all
        end
        if tweets_params['message']
            tweets_params['messages'] = tweets_params['message'].gsub('@', '')
        end
        make_tweets(leggies, client) if tweets_params['message']
        redirect_to root_path
    end

    private
    def tweets_params
        params.require(:tweets)
        .permit(:filter, :message, :weather)
    end

    def make_tweets(leggies, client)
        leggies.each do |leg|
            client.update(".#{leg.handle} #{tweets_params['message']}")
            puts 'tweet created.'
        end
    end

    def tweet_weather(leggies, desc, temp, client)
        leggies.each do |leg|
            client.update("#{leg.handle} Current conditions in Juneau: #{desc}, #{temp} degrees")
            puts "weather tweeted to #{leg.handle}"
        end
    end

    def in_fahrenheit(c)
        (c * (9.0 / 5.0)) + 32
    end

end
