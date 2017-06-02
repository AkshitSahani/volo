class ResponsesController < ApplicationController

  def create
    params.each do |q_id|
      if User.find(session[:user_id]).account_type == "Resident"
        Response.create(response: params["#{q_id}"], question_id: q_id, resident_id: session[:user_id]) if /^\d+$/.match(q_id)
      else
        Response.create(response: params["#{q_id}"], question_id: q_id, volunteer_id: session[:user_id]) if /^\d+$/.match(q_id)
      end
    end
  end

end
