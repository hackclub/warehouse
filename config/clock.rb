require_relative '../lib/common.rb'

require 'clockwork'
require 'kiba'

module Clockwork
  handler do |job|
    relative_path = File.join('../jobs', job)
    path = File.expand_path(relative_path, __dir__)

    script_content = IO.read(path)
    job_definition = Kiba.parse(script_content, path)

    $logger.info "Running #{job}"
    Kiba.run(job_definition)
  end

  every(1.day, 'sheets/slack_check_ins.etl')
  every(30.minutes, 'sheets/slack_stats.etl')
  every(15.minutes, 'streak/full_sync.etl')
end
