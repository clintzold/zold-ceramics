class NotifierMailer < ApplicationMailer

  def contact_form_submission(contact_form)
    @name = contact_form.name
    @email = contact_form.email
    @message = contact_form.message
    mail(from: "contact_form@zoldceramics.com", to: "contact@zoldceramics.com", subject: "Zold Ceramics - Contact Form Submission", reply_to: contact_form.email, template_name: "simple_message")
  end
end
