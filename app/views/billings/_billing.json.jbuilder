json.extract! billing, :id, :branch_id, :total, :paid, :balance, :created_at, :updated_at
json.url billing_url(billing, format: :json)