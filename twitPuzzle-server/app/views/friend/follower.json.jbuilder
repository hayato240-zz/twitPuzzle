json.array!(@followers) do |follower|
  json.extract! follower, :id, :name, :friendState
end