//Change highlighting and active status of list-items
const listGroup = document.querySelectorAll(".list-group-item")

listGroup.forEach(item => {
	item.addEventListener('click', function() {

	const currentActive = document.querySelector('.list-group-item.list-group-item-action.active');
	if (currentActive) {
		currentActive.classList.remove('active');
		}

		this.classList.add('active');
	});
});
