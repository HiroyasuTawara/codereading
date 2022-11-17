class AgendaMailer < ApplicationMailer
  default from: 'from@example.com'

  def deleat_mail(emails, title, user)
    @title = title
    @user = user
    mail to: emails, subject: I18n.t('views.messages.delete_agenda')
  end
end
