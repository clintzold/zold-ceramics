class NotifierMailer < ApplicationMailer

  def contact_form_submission(params)
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]
    mail(from: "contact_form@zoldceramics.com", to: "contact@zoldceramics.com", subject: "Zold Ceramics - Contact Form Submission", reply_to: @email, template_name: "simple_message")
  end

  def new_pickup_email
    @pickup = params[:pickup]
    @order = params[:order]
    @name = @order.name.split.first.capitalize
    mail(from: "contact@zoldceramics.com", to: @order.email, subject: "New Pickup Scheduled")
  end
end
