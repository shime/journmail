(function() {
  'use strict';

  // Constants
  var CLASS_LOADING = "button--loading";

  // Elements
  var $input = document.querySelector('.js-input');
  var $submit = document.querySelector('.js-submit');
  var $somethingWentWrong = document.querySelector(".something-went-wrong");
  var $invalidEmail = document.querySelector(".invalid-email");
  var $success = document.querySelector(".success");
  var $errorMessage = document.querySelector(".error-message");
  var $topForm = document.querySelector(".email-form-top");
  var $bottomForm = document.querySelector(".email-form-bottom");

  // Add events
  $submit.addEventListener('click', handleFormSubmit);
  $topForm.addEventListener("submit", handleFormSubmit);
  $bottomForm.addEventListener("submit", handleFormSubmit);

  // Determine timezone
  var tz = jstz.determine();
  var timezone = tz.name();

  // Events
  function handleFormSubmit(e) {
    e.preventDefault();
    // Get input data
    var email = $input.value;

    // Reset error messages
    $success.style.display = "none";
    $somethingWentWrong.style.display = "none";
    $invalidEmail.style.display = "none";
    $errorMessage.style.display = "none";


    if (!email.match(/.*@.*\..*/)){
      $invalidEmail.style.display = 'block';
      return;
    }

    var formData = {
      email: email,
      timezone: timezone
    };

    $submit.classList.add(CLASS_LOADING);

    submitForm(formData);
  }

  // Ajax events
  function submitForm(formData) {
    var xhr = new XMLHttpRequest();
    var url = "/register";
    xhr.open("POST", url, true);
    xhr.setRequestHeader("Content-type", "application/json");
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4) {
        $submit.classList.remove(CLASS_LOADING);

        if (xhr.status === 200) {
          var json = JSON.parse(xhr.responseText);
          $success.style.display = "block";
        } else if (xhr.status >= 400 && xhr.status < 500) {
          $errorMessage.style.display = "block";
          $errorMessage.innerHTML = JSON.parse(xhr.responseText).error;
        } else {
          $somethingWentWrong.style.display = "block";
        }
      }
    };
    var data = JSON.stringify(formData);
    xhr.send(data);
  }
})();
