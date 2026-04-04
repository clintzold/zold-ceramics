class NotifierMailer < ApplicationMailer

  def contact_form_submission(params)
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]
    mail(from: "contact_form@zoldceramics.com", to: "contact@zoldceramics.com", subject: "Zold Ceramics - Contact Form Submission", reply_to: @email, template_name: "simple_message")
  end
end
