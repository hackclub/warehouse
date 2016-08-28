Sequel.migration do
  up do
    alter_table(:sheets__slack_check_ins) do
      drop_constraint(:howdy_check_ins_club_leader_key_key)
    end
  end

  down do
    alter_table(:sheets__slack_check_ins) do
      add_unique_constraint(:club_leader_key, name: :howdy_check_ins_club_leader_key_key)
    end
  end
end
