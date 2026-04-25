import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-reveal"
export default class extends Controller {
  static targets = ["section", "text"]
  connect() {
    this.observer = new IntersectionObserver(this.onIntersection.bind(this), {
      threshold: 0.1
    })
    this.sectionTargets.forEach(target => this.observer.observe(target))
  }

  onIntersection(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const text = entry.target.querySelector(".slide-up")
        entry.target.firstElementChild.classList.add("reveal-visible")
        text.classList.remove("d-none")
      }
    })
  }

  disconnect() {
    this.observer.disconnect()
  }
}

