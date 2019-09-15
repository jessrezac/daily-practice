class User < ActiveRecord::Base
    has_many :journals
    has_many :gratitudes, through: :journals

    validates :email, uniqueness: true
    validates :username, uniqueness: true
    has_secure_password

    def random_gratitude
        self.gratitudes.sample
    end

end