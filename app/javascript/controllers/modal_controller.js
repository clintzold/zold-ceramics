import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["modal", "button"]
  connect() {
  }

  visible() {
    console.log(this.buttonTarget)
    this.modalTarget.classList.toggle("d-none")
  }

  hideButton() {
    console.log("clicked")
    this.buttonTarget.classList.add("opacity-0")
  }
}
