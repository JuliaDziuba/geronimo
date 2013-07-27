# config/initializers/configuration.rb
class Configuration
  class << self
    attr_accessor :DEV_AWS_BUCKET, :DEV_AWS_ACCESS_KEY, :DEV_AWS_SECRET
  end
end