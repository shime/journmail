Sequel.migration do
  up do
    alter_table(:users) do
      add_column :timezone, String, null: false, default: "Europe/London"
    end
  end

  down do
    alter_table(:users) do
      drop_column :timezone
    end
  end
end
