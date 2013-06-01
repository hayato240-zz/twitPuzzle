json.array!(@puzzle_results) do |puzzle|
  json.extract! puzzle,:id, :tweet, :image, :correct_order, :name
end