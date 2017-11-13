Sequel.migration do
  up do
    alter_table(:users) do
      add_index :email, unique: true
    end
  end

  down do
    alter_table(:users) do
      drop_index :email
    end
  end
end
