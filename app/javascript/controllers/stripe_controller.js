import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stripe"

// Calls backend to set shipping options
const onShippingDetailsChange = async (shippingDetailsChangeEvent) => {
	const { checkoutSessionId, shippingDetails } = shippingDetailsChangeEvent;
	const response = await fetch("shipping_options", {
		method: "POST",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify({
			checkout_session_id: checkoutSessionId,
			shipping_details: shippingDetails,
		})
	})

	if (response.type === 'error') {
		return Promise.resolve({ type: "reject", errorMessage: response.message });
	} else {
		return Promise.resolve({ type: "accept" });
	}
};

export default class extends Controller {
	static values = { publicKey: String, clientSecret: String };
	async connect() {
		const stripe = Stripe(this.publicKeyValue);

		this.checkout = await stripe.initEmbeddedCheckout({
			clientSecret: this.clientSecretValue,
			onShippingDetailsChange
		});

		// Mount Checkout to div element
		this.checkout.mount(this.element);
	}

	disconnect() {
		this.checkout.destroy()
	}
}
