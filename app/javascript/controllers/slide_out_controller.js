import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="slide-out"
export default class extends Controller {
  connect() {
    console.log(this.element)
  }
  slide(event) {
    event.preventDefault()
    this.element.classList.remove("forwards")
    void this.element.offsetWidth
    this.element.classList.add("reverse")
    console.log(this.element)
  }
}
