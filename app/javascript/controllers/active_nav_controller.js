import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="active-nav"
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
