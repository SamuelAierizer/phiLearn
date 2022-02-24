class Student::LecturesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data

  def show
    @lecture = Lecture.find(params[:id])
    authorize @lecture
    @target = @lecture
  end
end
