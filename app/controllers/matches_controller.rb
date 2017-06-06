class MatchesController < ApplicationController

  def new
    @match = Match.new
  end

  def show
    #depending on match type you either need the resident or the volunteer.
    r = Resident.find(params["user"])
    v = Volunteer.find(params["user"])
    surv = Survey.find(params["survey"]) # constant
    #also required here is match_type
    #if match_type = r2v, target == volunteer if match_type = v2r, target = resident
    @participants = Match.participants(surv, target)
    @match_rankings = Match.match_r2v(r, surv, @participants)
  end
end
