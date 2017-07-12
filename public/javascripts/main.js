document.addEventListener("DOMContentLoaded", (event) => {
  toggleSecondary();
});

function toggleSecondary(){
  var button = document.getElementsByClassName("secondary-toggle")[0];
  var secondary = document.getElementsByClassName("secondary")[0];

  if (secondary && button) {
    button.addEventListener("click", () =>
      secondary.classList.toggle("toggled-on"));
  }
}
