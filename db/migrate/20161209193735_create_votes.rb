class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :score
      t.references :votable, polymorphic: true
      t.timestamps
    end
  end
end
