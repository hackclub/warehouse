Sequel.migration do
  up do
    run %(
ALTER TABLE sheets.slack_check_ins
  ADD CONSTRAINT slack_check_ins_club_leader_key_fkey
    FOREIGN KEY (club_leader_key) REFERENCES streak.boxes (key)
)
  end

  down do
    run %(
ALTER TABLE sheets.slack_check_ins
  DROP CONSTRAINT slack_check_ins_club_leader_key_fkey
)
  end
end
