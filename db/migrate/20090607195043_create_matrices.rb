class CreateMatrices < ActiveRecord::Migration
  def self.up
    create_table :matrices do |t|
      t.string :name      
      t.integer :x
      t.integer :y
      t.text :frames 
      t.timestamps
    end
  end

  def self.down
    drop_table :matrices
  end
end
