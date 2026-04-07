import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="exit"
export default class extends Controller {
  connect() {
    console.log(this.element)
  }

  hide(event) {
    event.preventDefault()
    this.element.classList.add("fade-exit");
  }
}
