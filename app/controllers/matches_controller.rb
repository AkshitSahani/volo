class MatchesController < ApplicationController

  def index
    if request.xhr?

      surv = Survey.find(params['survey'])
      match_type = params['match_type']
      user_id = params['user']
      if match_type == "Resident"
        subject = Resident.where(user_id: user_id).take
        participants = Match.participating_volunteers(surv)
      elsif match_type == "Volunteer"
        subject = Volunteer.where(user_id: user_id).take
        participants = Match.participating_residents(surv)
      end

      @original_scores = Match.scores(participants, surv, subject)
      @original_match_rankings = Match.match(participants, @original_scores, surv)

      @original_participants = []
      participants.each do |part|
        @original_participants << part.user
      end

      filters = params['filter']

      if filters

        filtered_participants = []
        filter_counter = 0
        while filter_counter < filters.count
          question_id = filters[filter_counter.to_s][0].to_i
          @original_scores.each do |score| #scores stores the following: [AR participant, AR q, match score, match potential]
            if score[1].id == question_id
              filtered_participants << score[0] if score[0].responses.where(question_id: score[1].id)[0].response.include?(filters[filter_counter.to_s][2])
            end
          end
          filter_counter += 1
        end

        filtered_participants = filtered_participants.uniq
        @new_scores = Match.scores(filtered_participants, surv, subject)
        @match_rankings = Match.match(filtered_participants, @new_scores, surv)

        @displayed_participants = []
        filtered_participants.each do |part|
          @displayed_participants << part.user
        end

        respond_to do |format|
          format.json {
            render json: {
              'filteredParticipants': @displayed_participants,
              'newScores': @new_scores,
              'matchRankings': @match_rankings
              }
            }
        end
      else
        respond_to do |format|
          format.json {
            render json: {
              'filteredParticipants': @original_participants,
              'newScores': @original_scores,
              'matchRankings': @original_match_rankings
              }
            }
        end
      end
    else



    end
  end

  def new
    @match = Match.new
  end

  def show
    @surv = Survey.find(params["survey"]) #not affected by match_type
    @match_type = params["match_type"]
    @user_id = params["user"]
    #depending on match type you either need the resident or the volunteer as the subject and the opposite as the participants
    if @match_type == "Resident -> Volunteer"
      subject = Resident.where(user_id: @user_id).take
      @participants = Match.participating_volunteers(@surv)
    elsif @match_type == "Volunteer -> Resident"
      subject = Volunteer.where(user_id: @user_id).take
      @participants = Match.participating_residents(@surv)
    end
    @scores = Match.scores(@participants, @surv, subject)
    @match_rankings = ((Match.match(@participants, @scores, @surv)).sort_by { |name, score| score }).reverse
    @filters = Match.filters(@surv, subject)
  end

  def match_detail
    if User.find(params[:participant_id]).user_type == "Volunteer"
      @volunteer = User.find(params[:participant_id])
      @resident = User.find(params[:match_id])
    else
      @resident = User.find(params[:participant_id])
      @volunteer = User.find(params[:match_id])
    end
  end

end
