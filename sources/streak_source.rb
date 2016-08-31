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
    boxes = {}
    box_user_maps = []
    stages = {}
    fields = {}
    field_box_maps = []
    tasks = {}
    task_user_maps = []
    files = {}

    # Temporary data to construct data model
    user_keys_to_lookup = Set.new

    # Get all pipelines
    @client.pipelines.each do |pipeline|
      pipelines[pipeline['key']] = pipeline

      acl_entries = pipeline['aclEntries'].map do |e|
        e['pipelineKey'] = pipeline['key']
        e
      end

      pipeline_user_maps.concat acl_entries

      user_keys_to_lookup << pipeline['creatorKey']
      user_keys_to_lookup.merge acl_entries.map { |e| e['userKey'] }

      # Get all stages in pipeline
      @client.stages_in(pipeline['key']).each do |key, stage|
        stage['pipelineKey'] = pipeline['key']
        stages[stage['key']+stage['pipelineKey']] = stage
      end

      # Get all fields in pipelines
      @client.fields_in(pipeline['key']).each do |field|
        field['pipelineKey'] = pipeline['key']
        fields[field['key']+field['pipelineKey']] = field
      end

      # Get all boxes in pipeline
      @client.boxes_in(pipeline['key']).each do |box|
        boxes[box['key']] = box

        # Record follower relationships
        follower_maps = box['followerKeys'].map do |k|
          {
            box_key: box['key'],
            user_key: k
          }
        end

        box_user_maps.concat follower_maps

        # Get the box's fields
        field_maps = box['fields'].map do |key, value|
          parsed_value = value

          # Parse the value and set parsed_value to the field's actual value
          # (like in the case of a dropdown)
          parent_field = fields[key+pipeline['key']]

          case parent_field['type']
          when 'DROPDOWN'
            dropdown_options = {}
            value_key = value

            parent_field['dropdownSettings']['items'].each do |item|
              dropdown_options[item['key']] = item['name']
            end

            parsed_value = dropdown_options[value_key]
          end

          # Set the field's value to nil if the value is defined, but empty
          # (like in the case of an empty string or array)
          serialized_value = parsed_value.to_json

          if value.respond_to? :empty? and value.empty?
            serialized_value = nil
          end

          # The field entry itself
          {
            field_key: key,
            pipeline_key: pipeline['key'],
            box_key: box['key'],
            value: serialized_value
          }
        end

        field_box_maps.concat field_maps

        # Get all tasks for box
        @client.tasks_for(box['key']).each do |task|
          tasks[task['key']] = task

          task['assignedToSharingEntries'].each do |assignee|
            task_user_maps << {
              task_key: task['key'],
              user_key: assignee['userKey']
            }
          end
        end

        # Get all files for box
        @client.files_in(box['key']).each do |file|
          # Rename 'fileOwner' to 'ownerKey'
          file['ownerKey'] = file['fileOwner']
          file.delete 'fileOwner'

          # Rename 'fileType' to 'type'
          file['type'] = file['fileType']
          file.delete 'fileType'

          files[file['key']] = file
        end

        # Make sure we look up the referenced users to get their data
        user_keys_to_lookup.merge box['followerKeys']
      end
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
    order_to_insert = [ :user, :pipeline, :pipeline_user_map, :stage, :field, :box, :box_user_map, :field_box_map, :task, :task_user_map, :file ]

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
      when :box
        boxes.each do |key, box|
          rows << { _type: :box }.merge(box)
        end
      when :box_user_map
        box_user_maps.each do |map|
          rows << { _type: :box_user_map }.merge(map)
        end
      when :stage
        stages.each do |key, stage|
          rows << { _type: :stage }.merge(stage)
        end
      when :field
        fields.each do |key, field|
          rows << { _type: :field }.merge(field)
        end
      when :field_box_map
        field_box_maps.each do |map|
          rows << { _type: :field_box_map }.merge(map)
        end
      when :task
        tasks.each do |key, task|
          rows << { _type: :task }.merge(task)
        end
      when :task_user_map
        task_user_maps.each do |map|
          rows << { _type: :task_user_map }.merge(map)
        end
      when :file
        files.each do |key, file|
          rows << { _type: :file }.merge(file)
        end
      end
    end

    rows.each { |r| yield(r) }
  end
end
