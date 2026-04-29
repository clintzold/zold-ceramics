class NotifierMailer < ApplicationMailer
  default from: email_address_with_name("pickups@zoldceramics.com", "Pickups - Zold Ceramics")

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
    mail(to: @order.email, subject: "New Pickup Scheduled")
  end

  def pickup_rescheduled_email
    @pickup = params[:pickup]
    @order = params[:order]
    @name = @order.name.split.first.capitalize
    mail(to: @order.email, subject: "Pickup Rescheduled")
  end

  def pickup_canceled_email
    @date = params[:date]
    @order = params[:order]
    @name = @order.name.split.first.capitalize
    mail(to: @order.email, subject: "Pickup Canceled")
  end

  def confirmation_email
    @order = params[:order]
    @name = @order.name.split.first.capitalize
    mail(from: email_address_with_name("contact@zoldceramics.com", "Jessie - Zold Ceramics"), to: @order.email, subject: "Purchase Confirmation")
  end
end
