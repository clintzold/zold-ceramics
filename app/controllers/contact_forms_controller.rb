class ContactFormsController < ApplicationController
  def new
    @contact_form = ContactForm.new
  end

  def create
    @contact_form = ContactForm.new(contact_form_params)

    if @contact_form.valid?
      NotifierMailer.contact_form_submission(@contact_form).deliver_now
      flash[:success] = "Message submitted successfully!"
      redirect_to home_path
    else
      flash.now[:danger] = "An error occurred during form submission."
      render :new, status: :unprocessable_content
    end
  end

  private

  def contact_form_params
    params.require(:contact_form).permit(:name, :email, :message)
  end
end
