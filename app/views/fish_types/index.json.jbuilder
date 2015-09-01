json.array!(@fish_types) do |fish_type|
  json.extract! fish_type, :id, :name, :point_value
  json.url fish_type_url(fish_type, format: :json)
end
