json.array!(@cores) do |core|
  json.extract! core, :id
  json.url core_url(core, format: :json)
end
