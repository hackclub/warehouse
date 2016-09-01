Sequel.migration do
  up do
    create_schema :views

    run %(
CREATE VIEW views.club_leaders AS
  SELECT ct.key,
      ct.name,
      ct.creation_timestamp,
      ct.last_updated_timestamp,
      ct.creator_key,
      ct.pipeline_key,
      ct.notes,
      ct.gender,
      ct.year,
      ct.slack,
      ct.email,
      ct.github,
      ct.twitter,
      ct.phone,
      ct.address,
      ct.do_howdy_check_in
     FROM crosstab('
  SELECT
    boxes.key,
    boxes.name,
    boxes.creation_timestamp,
    boxes.last_updated_timestamp,
    boxes.creator_key,
    boxes.pipeline_key,
    boxes.notes,
    fields.name,
    field_box_maps.value#>>''{}''
  FROM
    streak.boxes,
    streak.pipelines,
    streak.fields,
    streak.field_box_maps
  WHERE
    boxes.pipeline_key = pipelines.key AND
    fields.pipeline_key = pipelines.key AND
    field_box_maps.field_key = fields.key AND
    field_box_maps.pipeline_key = fields.pipeline_key AND
    field_box_maps.box_key = boxes.key AND
    pipelines.name = ''Club Leaders''
  ORDER BY 1,7
   ', '
   VALUES
    (''Gender''::text),
    (''Year''::text),
    (''Slack''::text),
    (''Email''::text),
    (''GitHub''::text),
    (''Twitter''::text),
    (''Phone''::text),
    (''Address''::text),
    (''Do Howdy check-in?''::text)
  ')
  AS ct(
    key text,
    name text,
    creation_timestamp timestamp,
    last_updated_timestamp timestamp,
    creator_key text,
    pipeline_key text,
    notes text,
    gender text,
    year text,
    slack text,
    email text,
    github text,
    twitter text,
    phone text,
    address text,
    do_howdy_check_in boolean
  );
)
  end

  down do
    run %(DROP VIEW views.club_leaders)
    drop_schema :views
  end
end
