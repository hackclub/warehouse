require_relative '../lib/common.rb'
require 'google_drive'

class SheetsSource
  def initialize(spreadsheet_key, worksheet_gid=nil)
    @session = GoogleDrive::Session.from_service_account_key($config[:google_service_account_key])
    @spreadsheet = @session.spreadsheet_by_key(spreadsheet_key)

    if worksheet_gid
      @worksheet = @spreadsheet.worksheet_by_gid(worksheet_gid)
    else
      @worksheet = @spreadsheet.worksheets.first
    end
  end

  def each
    headers = @worksheet.rows[0].map { |r| r.intern } # Extract first row and convert to symbols
    rows = @worksheet
           .rows.drop(1) # Remove first row
           .reject { |row| # Remove rows with only empty values
             row.reject(&:empty?) .empty?
           }

    rows.each do |row|
      row_hash = Hash[headers.zip(row)]

      yield(row_hash)
    end
  end
end
