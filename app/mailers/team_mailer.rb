class TeamMailer < ApplicationMailer
  default from: 'from@example.com'

  def owner_change_mail(email)
    @email = email
    mail to: @email, subject: I18n.t('あなたがオーナーになりました')
  end

end
