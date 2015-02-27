json.array!(@settings) do |setting|
  json.extract! setting, :id, :group, :key, :value, :note
  json.url setting_url(setting, format: :json)
end
