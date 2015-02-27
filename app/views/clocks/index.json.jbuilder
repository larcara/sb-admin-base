json.array!(@clocks) do |clock|
  json.extract! clock, :id, :date, :time, :user, :ip, :action, :message
  json.url clock_url(clock, format: :json)
end
