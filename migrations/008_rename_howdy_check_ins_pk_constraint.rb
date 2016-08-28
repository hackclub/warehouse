Sequel.migration do
  up do
    run 'ALTER TABLE sheets.slack_check_ins RENAME CONSTRAINT howdy_check_ins_pkey TO slack_check_ins_pkey'
  end

  down do
    run 'ALTER TABLE sheets.slack_check_ins RENAME CONSTRAINT slack_check_ins_pkey TO howdy_check_ins_pkey'
  end
end
