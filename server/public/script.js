(function() {
  'use strict';

  function classSelector(position, selector) {
    return document.querySelector("." + position + " ." + selector);
  }

  function topSelector(selector){
    return classSelector("header", selector);
  }

  function bottomSelector(selector){
    return classSelector("footer", selector);
  }

  // Constants
  var CLASS_LOADING = "button--loading";

  // Elements
  var $input = {
    top: topSelector("js-input"),
    bottom: bottomSelector("js-input")
  };
  var $submit = {
    top: topSelector("js-submit"),
    bottom: bottomSelector("js-submit")
  };
  var $somethingWentWrong = {
    top: topSelector("something-went-wrong"),
    bottom: bottomSelector("something-went-wrong")
  };
  var $invalidEmail = {
    top: topSelector("invalid-email"),
    bottom: bottomSelector("invalid-email")
  };
  var $success = {
    top: topSelector("success"),
    bottom: bottomSelector("success")
  };
  var $errorMessage = {
    top: topSelector("error-message"),
    bottom: bottomSelector("error-message")
  };
  var $form = {
    top: topSelector("email-form"),
    bottom: bottomSelector("email-form")
  };

  // Add events
  $submit.top.addEventListener("click", function (event) { handleFormSubmit(event, "top") });
  $submit.bottom.addEventListener("click", function (event) { handleFormSubmit(event, "bottom") });
  $form.top.addEventListener("submit", function (event) { handleFormSubmit(event, "top") });
  $form.bottom.addEventListener("submit", function (event) { handleFormSubmit(event, "bottom") });

  // Determine timezone
  var tz = jstz.determine();
  var timezone = tz.name();

  function handleFormSubmit(event, position) {
    event.preventDefault();

    var email = $input[position].value;

    $success[position].style.display = "none";
    $somethingWentWrong[position].style.display = "none";
    $invalidEmail[position].style.display = "none";
    $errorMessage[position].style.display = "none";

    if (!email.match(/.*@.*\..*/)){
      $invalidEmail[position].style.display = 'block';
      return;
    }

    var formData = {
      email: email,
      timezone: timezone
    };

    $submit[position].classList.add(CLASS_LOADING);

    submitForm(formData, position);
  }

  function submitForm(formData, position) {
    var xhr = new XMLHttpRequest();
    var url = "/register";
    xhr.open("POST", url, true);
    xhr.setRequestHeader("Content-type", "application/json");
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4) {
        $submit[position].classList.remove(CLASS_LOADING);

        if (xhr.status === 200) {
          var json = JSON.parse(xhr.responseText);
          $success[position].style.display = "block";
        } else if (xhr.status >= 400 && xhr.status < 500) {
          $errorMessage[position].style.display = "block";
          $errorMessage[position].innerHTML = JSON.parse(xhr.responseText).error;
        } else {
          $somethingWentWrong[position].style.display = "block";
        }
      }
    };
    var data = JSON.stringify(formData);
    xhr.send(data);
  }
})();
