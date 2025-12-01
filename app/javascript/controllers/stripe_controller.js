import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stripe"
export default class extends Controller {
	static values = { publicKey: String, clientSecret: String };
	async connect() {
		const stripe = Stripe(this.publicKeyValue);


		const checkout = await stripe.initEmbeddedCheckout({
			clientSecret: this.clientSecretValue
		});

		// Mount Checkout
		checkout.mount(this.element);

	}
}
