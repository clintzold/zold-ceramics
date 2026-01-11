class NotifierMailer < ApplicationMailer
  default from: "no-reply@zoldceramics.com"

  def contact_form_submission(contact_form)
    @name = contact_form.name
    @email = contact_form.email
    @message = contact_form.message
    mail(to: "clintzold@gmail.com", subject: "Zold Ceramics - Contact Form Submission", reply_to: contact_form.email)
  end
end
