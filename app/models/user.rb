class User < ApplicationRecord
    def reset_session_token
        self.session_token = '12345'
        self.save!
    end
end
