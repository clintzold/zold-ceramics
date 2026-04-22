import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="email-loader"
export default class extends Controller {
  static targets = ["loadingOverlay", "loadingIcon", "message"]
  connect() {
    console.log(this.messageTarget)
  }

  show() {
    //Ensures animations start and end properly if form submitted again
    this.loadingIconTarget.classList.remove("fade-out");
    //Triggers the overlay and prevents re-submission during animation
    this.loadingOverlayTarget.classList.add("visible");
}

  handleLoadingEnd() {
    this.loadingIconTarget.classList.add("fade-out");
    this.messageTarget.classList.add("fading-message");
  }

  handleComplete() {
    this.loadingOverlayTarget.classList.remove("visible");
    //Ensures animations start and end properly if button clicked again
    this.messageTarget.classList.remove("fading-message");
  }
}
