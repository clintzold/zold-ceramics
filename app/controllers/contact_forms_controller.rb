class ContactFormsController < ApplicationController
  allow_unauthenticated_access
  def new
    @contact_form = ContactForm.new
  end

  def create
   @contact_form = ContactForm.new(contact_form_params)

    if @contact_form.valid?
      NotifierMailer.contact_form_submission(contact_form_params.to_h).deliver_later
      redirect_to home_path, data: { turbo_frame: "_top" }, success: "Message sent successfully"
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def contact_form_params
    params.require(:contact_form).permit(:name, :email, :message)
  end
end
