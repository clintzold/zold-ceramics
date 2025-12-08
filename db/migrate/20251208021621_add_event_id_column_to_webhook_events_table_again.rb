class AddEventIdColumnToWebhookEventsTableAgain < ActiveRecord::Migration[8.1]
  def change
    add_column :webhook_events, :event_id, :string
    add_index :webhook_events, :event_id, unique: true
  end
end
