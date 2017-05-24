json.extract! route, :id, :state_id, :city_id, :area_id, :created_at, :updated_at
json.url route_url(route, format: :json)