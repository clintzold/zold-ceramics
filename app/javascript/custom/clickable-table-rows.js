document.addEventListener('DOMContentLoaded', () => {
  const clickableRows = document.querySelectorAll('.clickable-row');

  clickableRows.forEach(row => {
    row.addEventListener('click', () => {
      const url = row.dataset.href;
      if (url) {
	console.log("hey")
        window.location.href = url;
      }
    });
  });
});
