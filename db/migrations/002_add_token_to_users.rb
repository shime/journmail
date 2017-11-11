Sequel.migration do
  up do
    Sequel::Model.db[:users].truncate

    alter_table(:users) do
      add_column :token, String, null: false
    end
  end

  down do
    alter_table(:users) do
      drop_column :token
    end
  end
end
