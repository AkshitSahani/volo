$(document).ready(function() {

  if ( window.location.pathname.search('matches' ) === 1) {
    var survey = $('.match-filters').attr('survey-id');
    var matchType = $('.match-filters').attr('match-type');
    var userId = $('.match-filters').attr('user-id');
    var filters = [];
    $('input').change(function() {
      if ( $(this).is(':checked') ) {
        // console.log("option is checked");
        var questionId = $(this).attr('question-id');
        var responseId = $(this).attr('response-id');
        var response = $(this).attr('id');
        // console.log('questionid=' + questionId);
        // console.log('responseid=' + responseId);
        // console.log('response=' + response);
        filters.push([questionId, responseId, response]);
        console.log(filters);
        // console.log(survey);
        $.ajax({
          url: "/matches",
          method: "get",
          data:{
            filter: filters,
            survey: survey,
            match_type: matchType,
            user: userId
          },
          dataType: "json"
        }).done(function(data){
          console.log("AJAX successful");
          console.log(data);
          $('.match-rankings').empty();
          $('.match-rankings').append(data);

          var matchScoreKeys = Object.keys(data['matchRankings']);
          var matchScores = []
          for (i = 0; i < matchScoreKeys.length; i++ ) {
            var key = matchScoreKeys[i];
            var score = data['matchRankings'][key];
            matchScores.push(score);
          }
          var participants = data['filteredParticipants'];
          for (i = 0; i < participants.length; i++ ) {
            var firstName = participants[i]["first_name"];
            var lastName =  participants[i]["last_name"];
            // var phoneNumber = participants[i]["phonenumber"];
            // var birthDate = participants[i]["birthday"];
            // var email = participants[i]["email"];
            var participantId = participants[i]["id"];
            var participantType = participants[i]["user_type"];

            var matchContainer = $('<div>').addClass('ranking '+ participantId);
            var matchAvatar = $('<span>').addClass('match-avatar');
            var matchImg = $('<img>').attr('src', '/images/medium/heart.png').attr('alt','Heart');
            $(matchAvatar).append(matchImg);
            var matchUser = $('<span>').addClass('match-user-name');
            var matchLink = $('<a>').addClass('match-user-name-link').attr('href','/matches/match_detail/' + participantId + '/' + userId)
            $(matchLink).html(firstName + ' ' + lastName);
            $(matchUser).append(matchLink);
            var scoreContainer = $('<b>').addClass('match-score-container');
            var matchScore = $('<span>').addClass('match-score').html(Math.round((matchScores[i] * 100)) + '%');
            $(scoreContainer).append(matchScore).append($('<br>')).append('Match');

            $(matchContainer).append(matchAvatar).append(matchUser).append(scoreContainer);
            $('.match-rankings').append(matchContainer);
          }
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
        // console.log('questionid =' + questionId);
        // console.log('responseid =' + responseId);
        // console.log('response=' + response);
        var index = filters.indexOf([questionId, responseId, response]);
        filters.splice(index, 1);
        console.log(filters);
        // same AJAX request as above
        $.ajax({
          url: "/matches",
          method: "get",
          data:{
            filter: filters,
            survey: survey,
            match_type: matchType,
            user: userId
          },
          dataType: "json"
        }).done(function(data){
          console.log("AJAX successful");
          console.log(data);
          $('.match-rankings').empty();
          $('.match-rankings').append(data);

          var matchScoreKeys = Object.keys(data['matchRankings']);
          var matchScores = []
          for (i = 0; i < matchScoreKeys.length; i++ ) {
            var key = matchScoreKeys[i];
            var score = data['matchRankings'][key];
            matchScores.push(score);
          }
          var participants = data['filteredParticipants'];
          for (i = 0; i < participants.length; i++ ) {
              var firstName = participants[i]["first_name"];
              var lastName =  participants[i]["last_name"];
              // var phoneNumber = participants[i]["phonenumber"];
              // var birthDate = participants[i]["birthday"];
              // var email = participants[i]["email"];
              var participantId = participants[i]["id"];
              var participantType = participants[i]["user_type"];

              var matchContainer = $('<div>').addClass('ranking '+ participantId);
              var matchAvatar = $('<span>').addClass('match-avatar');
              var matchImg = $('<img>').attr('src', '/images/medium/heart.png').attr('alt','Heart');
              $(matchAvatar).append(matchImg);
              var matchUser = $('<span>').addClass('match-user-name');
              var matchLink = $('<a>').addClass('match-user-name-link').attr('href','/matches/match_detail/' + participantId + '/' + userId)
              $(matchLink).html(firstName + ' ' + lastName);
              $(matchUser).append(matchLink);
              var scoreContainer = $('<b>').addClass('match-score-container');
              var matchScore = $('<span>').addClass('match-score').html(Math.round((matchScores[i] * 100)) + '%');
              $(scoreContainer).append(matchScore).append($('<br>')).append('Match');

              $(matchContainer).append(matchAvatar).append(matchUser).append(scoreContainer);
              $('.match-rankings').append(matchContainer);
            }
        }).fail(function(data){
          console.log("AJAX unsuccessful");
          console.log(data);
          console.log(data.responseText);
        })
        }
    });
  }

})
