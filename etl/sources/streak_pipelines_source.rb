require_relative '../lib/common.rb'
require_relative './streak_source.rb'

class StreakPipelinesSource < StreakSource
  def each
    @client.pipelines.each do |pipeline|
      yield(pipeline)
    end
  end
end
