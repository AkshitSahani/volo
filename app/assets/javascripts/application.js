// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require cocoon
//= require turbolinks
//= require materialize-sprockets

$(document).ready(function() {

  $('select').change(function(){
    if($(this).attr('name') === 'location'){
      var branchName = $( "select option:selected" ).first().text();
      $.ajax({
        url: '/locations',
        method: "get",
        data:{
          branch_name: branchName
        },
        dataType: 'json'
      }).done(function(data){
        console.log(data);
        $('select#survey').empty();

        for(i = 0; i < data.length; i++){
          $("select#survey").append(
              $("<option></option>").attr("value", data[i].id).text(data[i].name)
          )
        }
        $('select').material_select();

      }).fail(function(){
        console.log('AJAX has failed');
      })
    }

    else if ($(this).attr('name') === 'match_type'){
      var branchName = $( "select option:selected" ).first().text();
      var matchType = $( "select option:selected" )[2]['value']
      var survey = $( "select option:selected" )[1]
      var surveyId = $(survey).attr('value');
      // console.log(matchType);
      // console.log(surveyId);
      $.ajax({
        url: '/locations',
        method: "get",
        data:{
          branch: branchName,
          survey_id: surveyId,
          match_type: matchType
        },
        dataType: 'json'
      }).done(function(data){
        // console.log(data);
        $('select#user').empty();

        for(i = 0; i < data.length; i++){
          var name = data[i].first_name + ' ' + data[i].last_name
          $("select#user").append(
              $("<option></option>").attr("value", data[i].id).text(name)
          )
        }
        $('select').material_select();
      })
    }
  })
  // ajax call for match show if needed. Not needed right now. id attr had to be changed to
  // value and now all params are being sent properly.

  // $('.match-submit').on('click', function(e){
  //   e.preventDefault();
  //   var matchType = $( "select option:selected" )[2]['value'];
  //   var survey = $( "select option:selected" )[1];
  //   var surveyId = parseInt($(survey).attr('value'));
  //   var user = $( "select option:selected" )[3];
  //   var userId = parseInt($(user).attr('value'));
  //   $.ajax({
  //     url:'/matches/1',
  //     method: 'get',
  //     data:{
  //       survey: surveyId,
  //       match_type: matchType,
  //       user: userId
  //     },
  //     dataType: 'json'
  //   }).done(function(data){
  //     console.log(data);
  //   })
  // })
});
