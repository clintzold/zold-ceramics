import { Controller } from "@hotwired/stimulus"
// Connects to data-controller="previews"
export default class extends Controller {
  static targets = ["input", "preview"]	

  connect() {
  }

  preview() {
        this.previewTarget.innerHTML = ""
        Array.from(this.inputTarget.files).forEach(file => {
          const reader = new FileReader()
          reader.onload = (event) => {
            const img = document.createElement("img")
            img.src = event.target.result
            img.style.height = "100px" 
            img.dataset.filename = file.name

            const container = document.createElement("div")
            container.classList.add("image-container")
            container.innerHTML = `<a class='remove-image-button text-white fs-5 opacity-75' data-filename = '${file.name}' href='/admin/blobs/${file.name}' data-action='click->previews#removeFile'><i class='bi bi-x-square-fill'></i></a>`
            container.appendChild(img)

            this.previewTarget.insertAdjacentElement('afterbegin', container)
          }
          reader.readAsDataURL(file)
        })
  }

  removeFile(event) {
    const dt = new DataTransfer()
    const fileToRemove = event.currentTarget.dataset.filename

    Array.from(this.inputTarget.files).forEach(file => {
      if (file.name != fileToRemove) {
        dt.items.add(file)
      }

    })
    this.inputTarget.files = dt.files

    event.currentTarget.parentElement.remove()

  }

}
