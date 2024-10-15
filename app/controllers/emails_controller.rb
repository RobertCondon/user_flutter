class EmailsController < ApplicationController
  def index
    @emails = Email.order(date: :desc)
  end

  def show
    @email = Email.find(params[:id])
  end
end
