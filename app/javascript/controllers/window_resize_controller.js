import { Controller } from "@hotwired/stimulus"
//
// Changes navbar styles at 768 pixel breakpoint.
//
// This avoids visual confusion when the nav collapses
// by stopping it from floating over other elements.
//
// Connects to data-controller="window-resize"
export default class extends Controller {
	static targets = ["navbar", "navElementContainer"]
	connect() {
		this.checkSize();
	}

	checkSize() {
		const windowWidth = window.innerWidth;

		if (windowWidth < 768) {
			this.addClasses();
		} else {
			this.removeClasses();
		}

	}

	addClasses() {
		this.navElementContainerTarget.classList.remove("border-bottom");

		this.navbarTarget.classList.add("bg-primary");
		this.navbarTarget.classList.remove("fixed-top");
	}

	removeClasses() {
		this.navElementContainerTarget.classList.add("border-bottom");

		this.navbarTarget.classList.remove("bg-primary");
		this.navbarTarget.classList.add("fixed-top");
	}
}
