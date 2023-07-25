class EntriesController < ApplicationController
  def index
    render json: { entries: Entry.page(params[:page]) }, status: :ok
  end

  def create
    if entry.save
      render json: entry, status: :created
    else
      render json: { errors: entry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def entry
    @entry ||= Entry.new(permitted_params)
  end

  def permitted_params
    params.require(:entry).permit(:temperature, :humidity)
  end
end
