class ContactFormsController < ApplicationController
  allow_unauthenticated_access
  def new
    @contact_form = ContactForm.new
  end

  def create
   @contact_form = ContactForm.new(contact_form_params)

   respond_to do |format|
    if @contact_form.valid?
      NotifierMailer.contact_form_submission(contact_form_params.to_h).deliver_later
      format.html { head :no_content}
    else
      format.html {render :new, status: :unprocessable_content}
    end
   end
  end

  private

  def contact_form_params
    params.require(:contact_form).permit(:name, :email, :message)
  end
end
