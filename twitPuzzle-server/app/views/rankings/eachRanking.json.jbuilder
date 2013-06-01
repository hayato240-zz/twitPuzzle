json.array!(@rankings) do |ranking|
  json.extract! ranking, :complete_time, :user_id, :puzzle_id, :user_name
end