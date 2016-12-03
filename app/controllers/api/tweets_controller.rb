class Api::TweetsController < ApplicationController
    def create
        client = Twitter::REST::Client.new do |config|
            config.consumer_key        = "JMeqji62XmcYvZLLhVGOrhlGD"
            config.consumer_secret     = "0LIqhXIJ5zb4MQm3OGGkmdbLoJp63mIlIULaYANtqqowaTUF39"
            config.access_token        = "803148309124640768-vkpeC5TpT3HtbapZpVPTBv6PRja9X5U"
            config.access_token_secret = "ivU7vkT2T3C5QTmM5uGqEyiJfqJFrBHmLgztRA7zNUvAT"
        end
        if tweets_params['filter'] == 'all_house'
            leggies = Legislator.house
        elsif tweets_params['filter'] == 'all_senate'
            leggies = Legislator.senate
        elsif tweets_params['filter'] == 'house_minority'
            leggies = Legislator.house_minority
        end
        make_tweets(leggies, client)
        redirect_to root_path
    end

    private
    def tweets_params
        params.require(:tweets)
        .permit(:filter, :message)
    end

    def make_tweets(leggies, client)
        leggies.each do |leg|
            client.update(".#{leg.handle} #{tweets_params['message']}")
            puts 'tweet created.'
        end
    end

end
