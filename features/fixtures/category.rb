Category.transaction do
  Category.seed_many(:id, [
    {:name => "Money", :id => 1},
    {:name => "Family", :id => 2}
    ])
end