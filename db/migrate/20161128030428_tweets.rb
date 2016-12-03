class Tweets < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets do |t|
      t.string :message
      t.integer :recipients, array:true, default: []
    end
  end
end
