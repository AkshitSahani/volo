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
        console.log(data);
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

    else if ($(this).attr('name') === 'location[organization_id]'){
      var orgName = $( "select option:selected" ).first().text();
      $.ajax({
        url:'/volunteers',
        method: 'get',
        data:{
          org_name: orgName
        },
        dataType: 'JSON'
      }).done(function(data){
        $('select#location_branch_name').empty();
        for(i = 0; i < data.length; i++){
          $("select#location_branch_name").append(
              $("<option></option>").attr("value", data[i].id).text(data[i].branch_name)
          )
        }
        $('select').material_select();

      })
    }
  })

  // $(".add-org-location").click(function() {
  //   $('html, body').animate({
  //       scrollTop: $(".nested-fields").offset().top
  //   }, 2000);
  // });
  $('.alert, .notice').fadeOut(4000);

  $(".add-question-fields").click(function() {
    // $('html, body').animate({
    //     scrollTop: $("form .nested-fields:nth-last-child(3)").offset().top
    // }, 2000);
    // $('body').scrollTo('form .nested-fields:nth-last-child(3)');
  });
})
