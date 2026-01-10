class NotifierMailer < ApplicationMailer
  default from: "no-reply@zoldceramics.com"

  def simple_message(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(to: "clintzold@gmail.com", subject: "Contact Form - Zold Ceramics", reply_to: email)
  end
end
