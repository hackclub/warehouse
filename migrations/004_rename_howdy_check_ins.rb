Sequel.migration do
  change do
    rename_table :sheets__howdy_check_ins, :sheets__slack_check_ins
  end
end
