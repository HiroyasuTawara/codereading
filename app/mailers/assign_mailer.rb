class AssignMailer < ApplicationMailer
  default from: 'from@example.com'

  def assign_mail(email, password)
    @email = email
    @password = password
    mail to: @email, subject: I18n.t('views.messages.complete_registration')
  end

  def owner_assign_mail(email, team)
    @team = team
    mail to: email, subject: I18n.t('views.messages.you_assigned_owner')
  end
end