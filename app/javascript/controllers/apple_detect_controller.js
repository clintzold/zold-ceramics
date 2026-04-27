import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="apple-detect"
export default class extends Controller {
  static targets = ["text"]
  connect() {
    const isAppleDevice = () => {
      return (
      /iPad|iPhone|iPod/.test(navigator.userAgent) ||
      (navigator.platform === 'MacIntel')
      )
    }
    if (isAppleDevice()) {
      this.textTargets.forEach(element => {
        element.classList.add("apple-shadow")
      })
    }
  }
}
