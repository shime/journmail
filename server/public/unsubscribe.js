var id = window.location.href.split("/").slice(-1)[0];

var $errorMessage = document.querySelector(".error-message");
var $somethingWentWrong = document.querySelector(".something-went-wrong");
var $successMessage = document.querySelector(".success-message");
var $submit = document.querySelector(".button-submit");

var CLASS_LOADING = "button--loading";

$submit.onclick = function() { submitForm() }

function submitForm() {
  var xhr = new XMLHttpRequest();
  var url = "/unsubscribe/" + id;
  $submit.classList.add(CLASS_LOADING);
  xhr.open("POST", url, true);
  xhr.setRequestHeader("Content-type", "application/json");
  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4) {
      $submit.classList.remove(CLASS_LOADING);

      if (xhr.status === 200) {
        $successMessage.style.display = "block";
      } else if (xhr.status >= 400 && xhr.status < 500) {
        $errorMessage.style.display = "block";
        $errorMessage.innerHTML = JSON.parse(xhr.responseText).error;
      } else {
        $somethingWentWrong.style.display = "block";
      }
    }
  };
  var data = JSON.stringify({});
  xhr.send(data);
}
