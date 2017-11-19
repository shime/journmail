(function() {
  'use strict';

  // Constants
  var CLASS_LOADING = "button--loading";

  // Elements
  var $input = document.querySelector('.js-input');
  var $submit = document.querySelector('.js-submit');

  // Add events
  $submit.addEventListener('click', handleFormSubmit);

  // Events
  function handleFormSubmit() {
    // Get input data
    var inputData = $input.value;

    var formData = {
      email: inputData
    };

    $submit.classList.add(CLASS_LOADING);

    submitForm(formData);
  }

  // Ajax events
  function submitForm(formData) {
    // TODO
  }
})();
