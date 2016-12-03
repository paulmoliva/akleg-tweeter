class LegislatorsController < ApplicationController
  http_basic_authenticate_with name: "paul", password: "secret_code"
  def create
    @legislator = Legislator.new(legislator_params)
    @legislator.save
    redirect_to action: "index"
  end
end

def legislator_params
  params.require(:legislator)
    .permit(:name, :chamber, :party, :caucus, :handle)
end
