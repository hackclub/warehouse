require_relative '../lib/common.rb'
require_relative '../lib/streak_client.rb'

class StreakSource
  def initialize(api_key)
    @client = StreakClient.new(api_key)
  end
end
