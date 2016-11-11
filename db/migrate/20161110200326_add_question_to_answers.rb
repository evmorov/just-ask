class AddQuestionToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :answers, :question, foreign_key: true
  end
end
