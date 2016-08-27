Sequel.migration do
  change do
    create_join_table(
      {
        box_key: {
          table: :streak__boxes,
          type: 'text'
        },
        user_key: {
          table: :streak__users,
          type: 'text'
        }
      },
      name: :streak__box_user_maps
    )
  end
end
