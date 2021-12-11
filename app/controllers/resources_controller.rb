class ResourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_resource, only: %i[ show edit update destroy ]
  before_action :set_school
  before_action :set_courses, only: %i[ new show ]

  def index
    authorize Resource
    @resources = Resource.all
  end

  def show
    authorize @resource
  end

  def new
    @resource = Resource.new

    authorize @resource

    @material_id = params[:material_id]
    @material_type = params[:material_type]
  end

  def edit
    authorize @resource
  end

  def create
    @resource = Resource.new(resource_params)

    authorize @resource

    respond_to do |format|
      if @resource.save
        format.html { redirect_to @resource.material, notice: "Resource was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @resource

    respond_to do |format|
      if @resource.update(resource_params)
        format.html { redirect_to @resource.material, notice: "Resource was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @resource
    @material = @resource.material

    @resource.destroy
    respond_to do |format|
      format.html { redirect_to @material, notice: "Resource was successfully destroyed." }
    end
  end

  private
    def set_resource
      @resource = Resource.find(params[:id])
    end

    def resource_params
      params.require(:resource).permit(:name, :path, :material_type, :material_id)
    end
end
