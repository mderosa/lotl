class AdminMailer < ActionMailer::Base
  default :from => "lawoftheloop@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.activation_instructions.subject
  #
  def activation_instructions(user, host)
    @host = host
    @user = user
    mail :to => user.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.project_invitation.subject
  #
  def project_invitation
    @greeting = "Hi"

    mail :to => "to@example.org"
  end

  def feedback_note(params)
    @params = params
    mail :to => "lawoftheloop@gmail.com", :subject => "Feedback: #{params[:subject]}"
  end

end
