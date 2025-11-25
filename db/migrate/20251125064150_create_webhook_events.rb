class CreateWebhookEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :webhook_events do |t|
      t.jsonb :payload
      t.jsonb :headers
      t.boolean :processed

      t.timestamps
    end
  end
end
