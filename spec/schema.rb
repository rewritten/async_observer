ActiveRecord::Schema.define :version => 0 do
  create_table "async_models", :force => true do |t|
    t.string   "description"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
