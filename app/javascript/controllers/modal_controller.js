import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["modal"]
  connect() {
    console.log("Connected to ", this.modalTarget)
  }

  visible() {
    this.modalTarget.classList.toggle("d-none")
  }
}
