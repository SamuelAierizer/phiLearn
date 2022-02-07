class Student::AssignmentsController < ApplicationController
  include ActionView::Helpers::DateHelper

  before_action :authenticate_user!
  before_action :set_assignment, only: %i[ show ]
  before_action :set_data

  def show
    authorize @assignment

    @target = @assignment
    @assets = Resource.get_for(@assignment.class.name, @assignment.id)
  end

  
  private
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

end
