class MatchesController < ApplicationController

  def new
    @match = Match.new
  end

  def show
    r = Resident.find(params["user"])
    surv = Survey.find(params["survey"])

    volunteers = []
    surv.responses.each do |r|
      volunteers << r.volunteer if r.volunteer != nil
    end
    volunteers = volunteers.uniq
    scores = []

    surv.questions.each do |q|
      volunteers.each do |v|
        if q.question_type == "Multiple Choice"
          if v.responses.where(question_id: q.id).first.response.split(", ").count > 1
            v_answers = v.responses.where(question_id: q.id).first.response.split(", ")
          else
            v_answers = v.responses.where(question_id: q.id).first.response
          end
          if r.responses.where(question_id: q.id).first.response.split(", ").count > 1
            r_answers = r.responses.where(question_id: q.id).first.response.split(", ")
            match_potential = r_answers.count
          else
            r_answers = r.responses.where(question_id: q.id).first.response
            match_potential = r_answers.count
          end
            match_score = 0
              v_answers.each do |a_v|
                r_answers.each do |a_r|
                  match_score += 1 if a_v == a_r
                end
              end
            scores << [v, q, match_score, match_potential]
          elsif q.question_type == "Drop-Down"
            v_answers = v.responses.where(question_id: q.id)
            r_answers = r.responses.where(question_id: q.id)
            match_score = 0
            match_score = 1 if v_answers == r_answers
            scores << [v, q, match_score, match_potential]
          end
        end
      end
      @scores = scores

      match_rankings = []
      volunteers.each do |v|
        v_array = []
        scores.each do |array|
          v_array << array if array.include?(v)
        end
        v_score = []
        v_array.each do |v_a|
          if v_a[3] != 0
            num = (v_a[2]/v_a[3]).to_f
            den = v_a[1].ranking.to_f
            den_1 = surv.questions.sum(:ranking).to_f
            v_s = num * (den / den_1)
            v_score << v_s
            byebug
          end
        end
        v_score = v_score.sum
        match_rankings << [v, v_score]
      end
      @match_rankings = match_rankings
  end
end
