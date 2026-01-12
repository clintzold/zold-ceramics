import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="active-nav"
//
// Responsible for highlighting navigation links based on
// current page path.
//
// Could be optimized to iterate through link targets to find match
// rather than multiple 'if else' conditions. This would make any
// links added in future automatically dynamic simply by adding 
// the data-target details.
//
export default class extends Controller {

	static targets = ["homeLink", "shopLink", "cartLink"];
	static classes = ["active"];

	connect() {
		this.highlightActive()
	}

	highlightActive() {

		const currentPath = window.location.pathname;

		if (currentPath == "/home") {
			this.homeLinkTarget.classList.add(this.activeClass);
		} else if (currentPath == "/shop") {
			this.shopLinkTarget.classList.add(this.activeClass);
		} else {
			this.cartLinkTarget.classList.add(this.activeClass);
		};
	}

}
