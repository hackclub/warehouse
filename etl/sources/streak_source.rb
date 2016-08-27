require_relative '../lib/common.rb'
require_relative '../lib/streak_client.rb'

class StreakSource
  def initialize(api_key)
    @client = StreakClient.new(api_key)
  end

  def each
    # Streak data model
    pipelines = {}
    users = {}
    pipeline_user_maps = []

    # Temporary data to construct data model
    user_keys_to_lookup = Set.new

    @client.pipelines.each do |pipeline|
      pipelines[pipeline['key']] = pipeline

      acl_entries = pipeline['aclEntries'].map do |e|
        e['pipelineKey'] = pipeline['key']
        e
      end

      pipeline_user_maps.concat acl_entries

      user_keys_to_lookup << pipeline['creatorKey']
      user_keys_to_lookup.merge acl_entries.map { |e| e['userKey'] }
    end

    user_keys_to_lookup.each do |key|
      user = @client.user(key)

      # Streak's API doesn't return with the key value inline, we need to add it
      # ourselves
      user[:key] = key

      # Store the newly retrieved user in our temporary database
      users[key] = user
    end

    # Finalized rows to yield
    rows = []
    order_to_insert = [ :user, :pipeline, :pipeline_user_map ]

    order_to_insert.each do |type|
      case type
      when :user
        users.each do |key, user|
          rows << { _type: :user }.merge(user)
        end
      when :pipeline
        pipelines.each do |key, pipeline|
          rows << { _type: :pipeline }.merge(pipeline)
        end
      when :pipeline_user_map
        pipeline_user_maps.each do |map|
          rows << { _type: :pipeline_user_map }.merge(map)
        end
      end
    end

    rows.each { |r| yield(r) }
  end
end

class StreakPipelinesSource < StreakSource
  def each
    @client.pipelines.each do |pipeline|
      yield(pipeline)
    end
  end
end
