class CreateEmails < ActiveRecord::Migration[7.0]
  def change
    create_table :emails, id: :uuid do |t|
      t.string :message_id
      t.string :from
      t.string :to
      t.string :subject
      t.text :body
      t.datetime :date

      t.timestamps
    end
  end
end
