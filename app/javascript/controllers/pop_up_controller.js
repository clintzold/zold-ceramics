import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="pop-up"
export default class extends Controller {
  static values = { show: Boolean }

  connect() {
    if ( this.showValue == true ) {
     this.timeoutId = setTimeout(() => {
        this.showModal()
      }, 5000)
    }
  }

  showModal() {
    this.element.classList.remove("hidden")
  }

  disconnect() {
    clearTimeout(this.timeoutId)
  }
}
