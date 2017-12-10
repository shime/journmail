var id = window.location.href.split("/").slice(-1)[0];

var $errorMessage = document.querySelector(".error-message");
var $somethingWentWrong = document.querySelector(".something-went-wrong");
var $submitMonth = document.querySelector(".month .button-submit");
var $submitYear = document.querySelector(".year .button-submit");

var CLASS_LOADING = "button--loading";

$submitMonth.onclick = function() { submitForm("month") }
$submitYear.onclick = function() { submitForm("year") }

function submitForm(period) {
  var xhr = new XMLHttpRequest();
  var url = "/pay/" + period + "/" + id;
  if (period === "month") {
    $submitMonth.classList.add(CLASS_LOADING);
  } else {
    $submitYear.classList.add(CLASS_LOADING);
  }
  xhr.open("POST", url, true);
  xhr.setRequestHeader("Content-type", "application/json");
  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4) {
      if (period === "month") {
        $submitMonth.classList.remove(CLASS_LOADING);
      } else {
        $submitYear.classList.remove(CLASS_LOADING);
      }

      if (xhr.status === 200) {
        var json = JSON.parse(xhr.responseText);
        window.location = json.url;
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
