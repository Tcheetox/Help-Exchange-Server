class CreateFaqs < ActiveRecord::Migration[6.0]
  def change
    create_table :faqs do |t|

      t.timestamps
      t.string :question
      t.string :response
      t.string :keywords, :default => [].to_json

    end
  end
end
