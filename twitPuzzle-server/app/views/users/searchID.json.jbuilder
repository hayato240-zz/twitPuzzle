json.array!(@search_results) do |user|
  json.extract! user, :id, :name, :friendState, :created_at
end