Sequel.migration do
  change do
    create_join_table(
      {
        pipeline_key: {
          table: :streak__pipelines,
          type: 'text'
        },
        user_key: {
          table: :streak__users,
          type: 'text'
        }
      },
      name: :streak__pipeline_user_maps
    )
  end
end
