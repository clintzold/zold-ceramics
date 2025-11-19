import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="previews"
export default class extends Controller {
  static targets = ["input", "preview"]	
  connect() {
		console.log("Howdy, man!");
  }
	preview() {
		let input = this.inputTarget;
		let preview = this.previewTarget;
		let file = input.files[0];
		let reader = new FileReader;
		let imgLocation = document.getElementById("imagesInput")

		reader.onloadend = function () {
			preview.style.height = "150px";
			preview.src = reader.result;
		};

		if (file) {
			reader.readAsDataURL(file);
		} else {
			preview.src = "";
		}

	}
}
