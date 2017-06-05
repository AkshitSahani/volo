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
          if !(r.responses.where(question_id: q.id).empty?)
            if r.responses.where(question_id: q.id).first.response.split(", ").count > 1
              r_answers = r.responses.where(question_id: q.id).first.response.split(", ")
              match_potential = r_answers.count
            else
              r_answers = r.responses.where(question_id: q.id).first.response
              match_potential = r_answers.count
            end
          end
          match_score = 0
          r_answers.each do |r_a|
            i = 0
            while i < v_answers.count
              match_score += 1 if r_a == v_answers[i]
              i+=1
            end
          end

            scores << [v, q, match_score, match_potential]
          elsif q.question_type == "Drop-Down"
            if (!(v.responses.where(question_id: q.id).empty?)) && (!(r.responses.where(question_id: q.id).empty?))
              v_answers = v.responses.where(question_id: q.id)[0]
              r_answers = r.responses.where(question_id: q.id)[0]
              match_potential = 1
              if v_answers == r_answers
                match_score = 1
                scores << [v, q, match_score, match_potential]
              end
            end
          end
        end
      end
      @scores = scores

      # match_rankings = []
      v_hash = {}
      volunteers.each do |v|
        scores.each do |array|
          v_hash[v] = []
          if array.include?(v)
            v_hash[v] << array
          end
        end
      end

      v_score = {}
        v_hash.keys.each do |key|
          v_points = 0
          v_hash[key].each do |v_a|
            if v_a[3] != 0
              num = (v_a[2].to_f)/(v_a[3].to_f)
              den = ((v_a[1].ranking)/10.0)
              # den_1 = surv.questions.sum(:ranking).to_f
              v_points += (num * den)
              # byebug
            end
          end
          v_score[key] = v_points
         # v_score = v_score.sum
         # match_rankings << [v, v_score]
        end
      @match_rankings = v_score
  end
end
