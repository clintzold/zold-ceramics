import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="list-navigator"
export default class extends Controller {
  static targets = ["modal"]

  connect() {
    console.log(this.modalTarget)
    this.abortController = new AbortController()

  }

  async performRequest(event) {
    const selectedUrl = event.params.url;
    const response = await fetch(selectedUrl, {
      method: "GET",
      headers: {
        "Accept": "text/vnd.turbo-stream.html"
      }
    })

    if (response.ok) {
      const html = await response.text()
      this.modalTarget.classList.remove("d-none");
      console.log(this.modalTarget.classList)
      Turbo.renderStreamMessage(html)
    }
  }

  disconnect() {
    this.abortController.abort()
  }

}
