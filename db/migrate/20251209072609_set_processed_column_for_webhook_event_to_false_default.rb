class SetProcessedColumnForWebhookEventToFalseDefault < ActiveRecord::Migration[8.1]
  def change
    change_column_default :webhook_events, :processed, from: nil, to: false
  end
end
