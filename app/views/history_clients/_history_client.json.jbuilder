json.extract! history_client, :id, :email_history_id, :client_id, :count, :created_at, :updated_at
json.url history_client_url(history_client, format: :json)