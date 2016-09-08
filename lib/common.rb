require 'base64'

require 'sequel'
require 'logger'
require 'dotenv'

require 'byebug'

Dotenv.load

$config = {
  database_url: ENV.fetch('DATABASE_URL'),
  slack_check_ins_spreadsheet_key: ENV.fetch('SLACK_CHECK_INS_SPREADSHEET_KEY'),
  slack_stats_spreadsheet_key: ENV.fetch('SLACK_STATS_SPREADSHEET_KEY'),
  google_service_account_key: StringIO.new(Base64.decode64(ENV.fetch('GOOGLE_SERVICE_ACCOUNT_KEY_BASE64'))),
  streak_api_key: ENV.fetch('STREAK_API_KEY')
}

$logger = Logger.new(STDOUT)

Sequel.extension :migration
Sequel::Database.extension :pg_enum
