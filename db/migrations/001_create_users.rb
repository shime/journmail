Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String :email, null: false
      String :status, null: false, default: 'pending'
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end

  down do
    drop_table(:users)
  end
end
