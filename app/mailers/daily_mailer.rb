class DailyMailer < ApplicationMailer
  def digest(user, questions_ids)
    @questions = Question.find(questions_ids)
    mail to: user.email, subject: 'Daily digest'
  end
end
