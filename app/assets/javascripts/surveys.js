// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function() {

// Create range field
// var rangeFieldDiv = $('<div>').addClass('range-field');
// var rangeFieldLabel = $('<label></label>').attr('for','survey_questions_attributes_1497144033554_ranking').text('How important is this for matching?');
// var rangeFieldInput = $('<input></input>').attr('min', 0).attr('max',100).attr('type','range').attr('name','survey[questions_attributes][1497144033554][ranking]').attr('id','survey_questions_attributes_1497144033554_ranking');
// var rangeField = $(rangeFieldDiv).append(rangeFieldLabel).append(rangeFieldInput);



  $('select').material_select();
  console.log('i am running');
  $('body').delegate('select.question_type_dropdown', 'change', function() {
    if ($(this).val() === "Multiple Choice Question") {
        $(this).parent().siblings('.field.question_description').children().first().text('Respondents can choose multiple answers to this question.')
        $(this).parent().siblings('.range-field').show();
        $(this).parent().siblings('.add-question-fields').show();
    }
    else if ($(this).val() === "Open Response Question") {
      $(this).parent().siblings('.field.question_description').children().first().text('Respondents can enter a text response to this question. This question will not be ranked in matches.')
      $(this).parent().siblings('.range-field').hide();
      $(this).parent().siblings('.add-question-fields').hide();
    }
    else if ($(this).val() === "Drop-Down Question") {
        $(this).parent().siblings('.field.question_description').children().first().text('Respondents can choose one answer to this question.')
        $(this).parent().siblings('.range-field').show();
        $(this).parent().siblings('.add-question-fields').show();
    }
    else if ($(this).val() === "Display Text") {
      $(this).parent().siblings('.field.question_description').children().first().text('The text inputted below will be displayed to the user. You can use this to provide context throughout your survey.')
      $(this).parent().siblings('.range-field').hide();
      $(this).parent().siblings('.add-question-fields').hide();
    }
  });
})
