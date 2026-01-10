class NotifierMailer < ApplicationMailer
  default from: "no-reply@zoldceramics.com"

  def simple_message(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(to: "admin@zoldceramics.com", subject: "Contact Form - Zold Ceramics", message: message, reply_to: email)
  end
end
