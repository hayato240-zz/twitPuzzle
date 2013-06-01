json.array!(@follows) do |follow|
  json.extract! follow, :id, :name, :friendState
end