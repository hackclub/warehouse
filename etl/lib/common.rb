require 'base64'

require 'sequel'
require 'logger'
require 'dotenv'

require 'byebug'

Dotenv.load

$config = {
  database_url: ENV.fetch('DATABASE_URL'),
  howdy_check_ins_spreadsheet_key: ENV.fetch('SLACK_CHECK_INS_SPREADSHEET_KEY'),
  google_service_account_key: StringIO.new(Base64.decode64(ENV.fetch('GOOGLE_SERVICE_ACCOUNT_KEY_BASE64')))
}

$logger = Logger.new(STDOUT)

Sequel.extension :migration
