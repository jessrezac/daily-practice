class Journal < ActiveRecord::Base
    belongs_to :user
    has_many :gratitudes
    has_many :forgivenesses
    has_many :commitments

    def next
        user.journals.where("id > ?", id).first
    end

    def prev
        user.journals.where("id < ?", id).last
    end

end