class ContactFormsController < ApplicationController
  allow_unauthenticated_access
  def new
    @contact_form = ContactForm.new
    respond_to do |format|
      format.turbo_stream { 
        render turbo_stream: turbo_stream.replace(
          "contact_us", partial: "new", locals: {contact_form: @contact_form}
        )}
      format.html { redirect_to home_path( anchor: "contact" )}
    end
  end

  def create
   @contact_form = ContactForm.new(contact_form_params)

   respond_to do |format|
    if @contact_form.valid?
      NotifierMailer.contact_form_submission(contact_form_params.to_h).deliver_later
      format.html { head :no_content}
    else
      format.turbo_stream {
        render turbo_stream: turbo_stream.update(
          "contact_form_errors", partial: "shared/form_errors", locals: { errors: @contact_form.errors }
        ), status: :unprocessable_content
      }
    end
   end
  end

  private

  def contact_form_params
    params.require(:contact_form).permit(:name, :email, :message)
  end
end
