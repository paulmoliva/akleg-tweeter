CONSUMER_KEY = "ZU67a7iOA29euOUtdgmNykEc0"
CONSUMER_SECRET = "ZON03RiZPHBgvFXFF3wmjkPeYcfF0gxXXBL4qYpgvmi9ycXIA5"
class LoginsController < ApplicationController
    def create
        consumer = OAuth::Consumer.new(
            CONSUMER_KEY,
            CONSUMER_SECRET,
            {
                :site => "https://api.twitter.com",
                :scheme => :header
            }
        )
        # token = consumer.get_request_token(oauth_callback: 'https://akleg-tweeter.herokuapp.com/logins')
        token = consumer.get_request_token(oauth_callback: 'http://localhost:3000/logins')
        # Exchange our oauth_token and oauth_token secret for the AccessToken instance.
        access_token = prepare_access_token(token.token, token.secret)

        # use the access token as an agent to get the home timeline
        #response = access_token.request(:get, "https://api.twitter.com/1.1/statuses/home_timeline.json")
        redirect_to "https://api.twitter.com/oauth/authorize?oauth_token=#{token.token}"
    end

    def index
        params
        hash = { oauth_token: params[:oauth_token], oauth_token_secret: params[:oauth_verifier]}
        consumer = OAuth::Consumer.new(
            CONSUMER_KEY,
            CONSUMER_SECRET,
            {
                :site => "https://api.twitter.com",
                access_token_url: "https://api.twitter.com/oauth/access_token?oauth_verifier=#{params[:oauth_verifier]}"
            }
        )
        request_token  = OAuth::RequestToken.from_hash(consumer, hash)
        access_token = request_token.get_access_token
        client = Twitter::REST::Client.new do |config|
            config.consumer_key        = CONSUMER_KEY
            config.consumer_secret     = CONSUMER_SECRET
            config.access_token        = access_token.token
            config.access_token_secret = access_token.secret
        end
        screen_name = access_token.params[:screen_name]
        token = access_token.token
        secret = access_token.secret
        @user = User.where(screen_name: screen_name).first
        if @user
            sign_in(@user)
        else
            @user = User.new
            @user.screen_name = screen_name
            @user.token = token
            @user.secret = secret
            @user.save
            sign_in(@user)
        end
        redirect_to root_path
    end

    def delete
        current_user.session_token = nil
        current_user.save
        redirect_to root_path
    end

    private
    def sign_in(user)
      user.session_token = SecureRandom.urlsafe_base64(16)
      user.save
      session[:session_token] = user.session_token
    end

    def sign_out
      session[:session_token] = nil
    end

end
# Exchange your oauth_token and oauth_token_secret for an AccessToken instance.
def prepare_access_token(oauth_token, oauth_token_secret)
    consumer = OAuth::Consumer.new(
        CONSUMER_KEY,
        CONSUMER_SECRET,
        {
            :site => "https://api.twitter.com",
            :scheme => :header
        }
    )

    # now create the access token object from passed values
    token_hash = { :oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )

    return access_token
end
