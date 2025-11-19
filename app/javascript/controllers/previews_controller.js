import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="previews"
export default class extends Controller {
  static targets = ["input", "preview"]	
  connect() {
		console.log("Howdy, man!");
  }
//	preview() {
//		let input = this.inputTarget;
//		let preview = this.previewTarget;
//		let file = input.files[0];
//		let reader = new FileReader;
//		let imgLocation = document.getElementById("imagesInput")
//
//		reader.onloadend = function () {
//			preview.style.height = "150px";
//			preview.src = reader.result;
//		};
//
//		if (file) {
//			reader.readAsDataURL(file);
//		} else {
//			preview.src = "";
//		}
//
//	}
//}
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
