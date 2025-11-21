import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="previews"
export default class extends Controller {
  static targets = ["input", "preview"]	
  connect() {
  }
  preview() {
        this.previewTarget.innerHTML = "" // Clear previous previews
        Array.from(this.inputTarget.files).forEach(file => {
          const reader = new FileReader()
          reader.onload = (event) => {
            const img = document.createElement("img")
            img.src = event.target.result
            img.style.height = "150px" 
	    img.style.margin = "2px"
            this.previewTarget.appendChild(img)
          }
          reader.readAsDataURL(file)
        })
  }
}
