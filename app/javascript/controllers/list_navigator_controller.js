import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="list-navigator"
export default class extends Controller {

  connect() {
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
      Turbo.renderStreamMessage(html)
    }
  }

  performNormalRequest(event) {
    const selectedUrl = event.params.url;
    fetch(selectedUrl, {
      method: "GET",
      headers: {
        "Accept": "text/html"
      }
    }).then(response => {

    if (response.ok) {
      window.location.href = response.url
    }
      })
  }

  disconnect() {
    this.abortController.abort()
  }

}
