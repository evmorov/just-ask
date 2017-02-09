class AnswerMailer < ApplicationMailer
  def notify_watcher(user, answer)
    @answer = answer
    mail to: user.email, subject: 'New question'
  end
end
