import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sliding-text"
export default class extends Controller {
  static targets = ["text"]
  connect() {
  }
  slide() {
    this.textTarget.classList.remove("d-none")
  }
}
