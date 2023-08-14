class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @boards = Board.order(:created_at)
  end
end
