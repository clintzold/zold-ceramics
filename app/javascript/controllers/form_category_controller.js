import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-category"
export default class extends Controller {
  static targets = ["ounces", "dimensions"]
  connect() {
    console.log(this.ouncesTarget)
    console.log(this.dimensionsTarget)
  }

  changeOptions(event) {
    const selection = event.target.value

    if (selection != "drinkware") {
      this.ouncesTarget.classList.add("d-none")
      this.dimensionsTarget.classList.remove("d-none")
    } else {
      this.dimensionsTarget.classList.add("d-none")
      this.ouncesTarget.classList.remove("d-none")
    }
      
  }
}
