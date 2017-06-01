class ResidentsController < ApplicationController

  def new
    @resident = Resident.new
  end
end
