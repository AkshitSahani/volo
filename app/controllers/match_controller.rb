class MatchController < ApplicationController

  def new
    @match = Match.new
  end

  def create
    @match = Match.new(match_params)
    if @match.save
      redirect_to match_path(@match)
    else
      render :new
    end
  end

  def show
    @match = Match.find(params[:id])
  end

  def destroy
    @match = Match.find(params[:id])
    @match.delete
    redirect_to root_url
  end

  private
  def match_params
    params.require(:match).permit(:volunteer_id, :resident_id, :match_score)
  end
end
