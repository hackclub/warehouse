Sequel.migration do
  up do
    run 'ALTER TABLE sheets.slack_check_ins ALTER COLUMN id DROP DEFAULT'
  end

  down do
    run "ALTER TABLE sheets.slack_check_ins ALTER COLUMN id SET DEFAULT nextval('sheets.howdy_check_ins_id_seq'::regclass)"
  end
end
