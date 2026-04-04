import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loader"
export default class extends Controller {
  static targets = ["loadingOverlay", "loadingIcon", "button", "message", "form"]
  connect() {
  }

  show(event) {
    if (event.detail.success) {
      //Ensures animations start and end properly if form submitted again
      this.loadingIconTarget.classList.remove("fade-out");
      //Triggers the overlay and prevents re-submission during animation
      this.loadingOverlayTarget.classList.add("visible");
      this.buttonTarget.disable = true;
    } else {
      return;
    }
  }

  //Clear all form fields
  clearForm() {
    this.formTarget.reset();
  }

  //Triggers icon and message animations after overlay appears
  handleLoadingEnd(){
    this.loadingIconTarget.classList.add("fade-out");
    this.messageTarget.classList.add("fading-message");
  }

  handleComplete(){
    this.loadingOverlayTarget.classList.remove("visible");
    //Ensures animations start and end properly if form submitted again
    this.buttonTarget.disable = false;
    this.messageTarget.classList.remove("fading-message");

    this.clearForm();
  }

}
