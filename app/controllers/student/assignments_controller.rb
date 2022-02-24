class Student::AssignmentsController < ApplicationController
  include ActionView::Helpers::DateHelper

  before_action :authenticate_user!
  before_action :set_data

  def show
    @assignment = Assignment.find(params[:id])
    authorize @assignment
    @target = @assignment
  end

end
