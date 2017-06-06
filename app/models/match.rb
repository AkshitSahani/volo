class Match < ApplicationRecord
  belongs_to :volunteer
  belongs_to :resident

  def self.participants(surv, target)
    participants = []
    surv.responses.each do |r|
      participants << r.target if r.target != nil
    end
    participants = participants.uniq
  end

  def self.match(r, surv, participants)
    scores = []
    surv.questions.each do |q|
      participants.each do |v|
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
              match_score = 0
              if v_answers == r_answers
                match_score = 1
              end
              #so long as the resident has responded, shovel info into scores array if we choose to allow them to skip questions
              scores << [v, q, match_score, match_potential]
            end
          end
        end
      end
      @scores = scores

      # match_rankings = []
      v_hash = {}
      participants.each do |v|
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
              den = (v_a[1].ranking).to_f
              den_1 = surv.questions.sum(:ranking).to_f
              v_points += (num * (den/den_1))
            end
          end
          v_score[key] = v_points
         # v_score = v_score.sum
         # match_rankings << [v, v_score]
        end
      @match_rankings = v_score
      # byebug
      # @match_rankings
  end
end
