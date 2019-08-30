require 'bundler'
Bundler.require(:default, :development)

ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database => "db/dailypractice.sqlite"
)

ActiveSupport::Inflector.inflections do |inflect|
    inflect.irregular 'forgiveness', 'forgivenesses'
end

require_all 'app'