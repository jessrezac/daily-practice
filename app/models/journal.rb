class Journal < ActiveRecord::Base
    belongs_to :user
    has_many :gratitudes
    has_many :forgivenesses
    has_many :commitments
end