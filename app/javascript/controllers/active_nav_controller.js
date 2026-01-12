import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="active-nav"
//
// Responsible for highlighting navigation links based on
// current page path.
//
export default class extends Controller {

	static targets = ["navLink"];
	static classes = ["active"];

	connect() {
		this.highlightActive()
	}

	highlightActive() {

		const currentPath = window.location.pathname;

		this.navLinkTargets.forEach(link => {
			if (link.pathname == currentPath) {
				link.classList.add(this.activeClass);
			};
		});
	}

}
