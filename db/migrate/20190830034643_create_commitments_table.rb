class CreateCommitmentsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :commitments do |t|
      t.text :content
      t.integer :journal_id
      t.timestamps
    end
  end
end
