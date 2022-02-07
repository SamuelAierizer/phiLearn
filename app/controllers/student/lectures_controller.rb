class Student::LecturesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lecture, only: %i[ show ]
  before_action :set_data

  def show
    authorize @lecture
    @assets = Resource.get_for(@lecture.class.name, @lecture.id)
    @target = @lecture
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lecture
      @lecture = Lecture.find(params[:id])
    end
end
