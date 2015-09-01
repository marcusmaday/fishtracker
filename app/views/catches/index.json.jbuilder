json.array!(@catches) do |catch|
  json.extract! catch, :id, :fish_type_id, :user_id, :lat, :lon, :date, :kept
  json.url catch_url(catch, format: :json)
end
