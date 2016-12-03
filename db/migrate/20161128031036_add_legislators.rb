class AddLegislators < ActiveRecord::Migration[5.0]
  def change
    create_table :legislators do |t|
      t.string :name
      t.string :handle
      t.string :chamber
      t.string :party
      t.string :caucus
      t.integer :total_recieved
    end
  end
end
