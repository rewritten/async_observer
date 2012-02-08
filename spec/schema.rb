ActiveRecord::Schema.define :version => 0 do
  create_table "async_models", :force => true do |t|
    t.string   "description"
    t.string   "name"
    t.string   "created_by_pid"
    t.string   "async_created_by_pid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
