import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="timed-navigation"
export default class extends Controller {
  connect() {
    console.log("Timed Navigation Connected")
    this.timeout = setTimeout(() => {
      this.navigate()
    }, 5000);
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  navigate() {
    window.location.href = "https://zoldceramics.com"
  }
}
