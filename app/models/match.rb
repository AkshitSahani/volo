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

  def self.filters(surv, subject)
    filters = []
    surv.questions.each do |q|
      if q.question_type == "Multiple Choice"
        if !(subject.responses.where(question_id: q.id).empty?)
          subject_answers = subject.responses.where(question_id: q.id).first
        end
      filters << [q, subject_answers]
      elsif q.question_type == "Drop-Down"
        subject_answers = subject.responses.where(question_id: q.id)[0] if !(subject.responses.where(question_id: q.id).empty?)
        filters << [q, subject_answers]
      end
    end
    filters
  end

  def self.scores(participants, surv, subject)
    scores = []
    surv.questions.each do |q|
      participants.each do |par|
        if q.question_type == "Multiple Choice"
          if par.responses.where(question_id: q.id).first.response.split(", ").count > 1
            par_answers = par.responses.where(question_id: q.id).first.response.split(", ")
          else
            par_answers = par.responses.where(question_id: q.id).first.response
          end

          if !(subject.responses.where(question_id: q.id).empty?)
            if subject.responses.where(question_id: q.id).first.response.split(", ").count > 1
              subject_answers = subject.responses.where(question_id: q.id).first.response.split(", ")
              match_potential = subject_answers.count
            else
              subject_answers = [subject.responses.where(question_id: q.id).first.response]
              match_potential = 1
            end
          end

          match_score = 0
          subject_answers.each do |s_a|
            i = 0
            while i < par_answers.count
              match_score += 1 if s_a == par_answers[i]
              i+=1
            end
          end
          scores << [par, q, match_score, match_potential]
        elsif q.question_type == "Drop-Down"
          if (!(par.responses.where(question_id: q.id).empty?)) && (!(subject.responses.where(question_id: q.id).empty?))
            par_answers = par.responses.where(question_id: q.id)[0].response
            subject_answers = subject.responses.where(question_id: q.id)[0].response
            match_potential = 1
            match_score = 0
            if par_answers == subject_answers
              match_score = 1
            end
            scores << [par, q, match_score, match_potential]
          end
        end
      end
    end
    scores
  end

  def self.match(participants, scores, surv)
    par_hash = {}
    participants.each do |par|
      par_hash[par] = []
      scores.each do |array|
        if array.include?(par)
          par_hash[par] << array
        end
      end
    end

    par_score = {}
    par_hash.keys.each do |key|
      par_points = 0
      par_hash[key].each do |par_a|
        if par_a[3] != 0
          num = (par_a[2].to_f)/(par_a[3].to_f)
          den = (par_a[1].ranking).to_f
          den_1 = surv.questions.sum(:ranking).to_f
          par_points += (num * (den/den_1))
        end
      end
      par_score[key] = par_points
    end
    par_score
  end

end
