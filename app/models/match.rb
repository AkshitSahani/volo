class Match < ApplicationRecord
  belongs_to :volunteer
  belongs_to :resident

  def self.participating_volunteers(surv)
    participants = []
    surv.responses.each do |r|
      participants << r.volunteer if r.volunteer != nil
    end
    participants = participants.uniq
  end

  def self.participating_residents(surv)
    participants = []
    surv.responses.each do |r|
      participants << r.resident if r.resident != nil
    end
    participants = participants.uniq
  end

  def self.scores(participants, surv, subject)
    scores = []
    surv.questions.each do |q|
      participants.each do |v|
        if q.question_type == "Multiple Choice"
          if v.responses.where(question_id: q.id).first.response.split(", ").count > 1
            v_answers = v.responses.where(question_id: q.id).first.response.split(", ")
          else
            v_answers = v.responses.where(question_id: q.id).first.response
          end

          if !(subject.responses.where(question_id: q.id).empty?)
            if subject.responses.where(question_id: q.id).first.response.split(", ").count > 1
              subject_answers = subject.responses.where(question_id: q.id).first.response.split(", ")
              match_potential = subject_answers.count
            else
              subject_answers = subject.responses.where(question_id: q.id).first.response
              match_potential = subject_answers.count
            end
          end

          match_score = 0
          subject_answers.each do |s_a|
            i = 0
            while i < v_answers.count
              match_score += 1 if s_a == v_answers[i]
              i+=1
            end
          end

            scores << [v, q, match_score, match_potential]
        elsif q.question_type == "Drop-Down"
          if (!(v.responses.where(question_id: q.id).empty?)) && (!(subject.responses.where(question_id: q.id).empty?))
            v_answers = v.responses.where(question_id: q.id)[0]
            subject_answers = subject.responses.where(question_id: q.id)[0]
            match_potential = 1
            match_score = 0
            if v_answers == subject_answers
              match_score = 1
            end
            scores << [v, q, match_score, match_potential]
          end
        end
      end
    end
    scores
  end

  def self.match(participants, scores, surv)
    v_hash = {}
    participants.each do |v|
      v_hash[v] = []
      scores.each do |array|
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
    end
    v_score
  end

end
