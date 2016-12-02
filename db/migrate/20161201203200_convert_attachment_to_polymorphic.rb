class ConvertAttachmentToPolymorphic < ActiveRecord::Migration[5.0]
  def change
    remove_reference :attachments, :question, foreign_key: true

    add_column :attachments, :attachable_id, :integer
    add_column :attachments, :attachable_type, :string
    add_index :attachments, [:attachable_id, :attachable_type]
  end
end
