Sequel.migration do
  up do
    Sequel::Model.db[:paypal_subscriptions].truncate

    alter_table(:paypal_subscriptions) do
      add_column :agreement_id, String, null: false
    end
  end

  down do
    alter_table(:paypal_subscriptions) do
      drop_column :agreement_id
    end
  end
end
