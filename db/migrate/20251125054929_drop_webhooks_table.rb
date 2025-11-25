class DropWebhooksTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :webhooks
  end
end
