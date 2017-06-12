$(document).ready(function() {

  if ( window.location.pathname.search('matches' ) === 1) {
    var survey = $('.match-filters').attr('survey-id');
    var filters = [];
    $('input').change(function() {
      if ( $(this).is(':checked') ) {
        console.log("option is checked");
        var questionId = $(this).attr('question-id');
        var responseId = $(this).attr('response-id');
        var response = $(this).attr('id');
        console.log('questionid=' + questionId);
        console.log('responseid=' + responseId);
        console.log('response=' + response);
        filters.push([questionId, responseId, response])
        console.log(filters);
        // make an ajax request to match controller to update the list of selected filters and provide back json with all relevant matches
        $.ajax({
          url: "/matches",
          method: "get",
          data:{
            filter: filters
          },
          dataType: "json"
        }).done(function(data){
          console.log("AJAX successful");
          console.log(data);
        }).fail(function(data){
          console.log("AJAX unsuccessful");
          console.log(data);
          console.log(data.responseText);
        })
      }
      else {
        console.log("option is unchecked");
        var questionId = $(this).attr('question-id');
        var responseId = $(this).attr('response-id');
        var response = $(this).attr('id');
        console.log('questionid =' + questionId);
        console.log('responseid =' + responseId);
        console.log('response=' + response);
        var index = filters.indexOf([questionId, responseId, response]);
        filters.splice(index, 1);
        console.log(filters);
        // same AJAX request as above
        $.ajax({
          url: "/matches",
          method: "get",
          data:{
            filter: filters
          },
          dataType: "json"
        }).done(function(data){
          console.log("AJAX successful");
          console.log(data);
        }).fail(function(data){
          console.log("AJAX unsuccessful");
          console.log(data);
          console.log(data.responseText);
        })
      }
    });
  }

})
