class User < ActiveRecord::Base
    has_many :journals

    validates :email, uniqueness: true
    validates :username, uniqueness: true
    has_secure_password

end