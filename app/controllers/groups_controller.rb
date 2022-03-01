class GroupsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_group, only: %i[ show edit update destroy ]
  before_action :set_data

  def index
    public_groups = Group.where(access_code: 0)
    member_groups = Group.where(id: Member.where(uid: current_user.id, memable_type: 'Group').pluck(:memable_id))
    @groups = member_groups | public_groups
  end

  def show
    authorize @group

    session[:user_id] = current_user.id
    @group_posts = @group.group_posts.where(deleted_at: nil).order(created_at: :desc)
    isAdmin = @group.members.where(uid: current_user.id, mem_type: 'admin').exists?
    @role = 'user'
    @role = 'admin' if isAdmin
  end

  def new
    @group = Group.new
  end

  def edit
    authorize @group
  end

  def create
    @group = Group.new(group_params)
    authorize @group

    @group.group_type = params[:group_type]
    @group.created_by = current_user.id
        
    @group.access_code = helpers.generateCode() unless params[:group][:access_code] == "0"

    if @group.save
      @group.members.create(uid: current_user.id, mem_type: 'admin')
      @group.members.create(uid: current_user.id, mem_type: 'member')
      redirect_to @group, notice: "Group was successfully created."
    else
      flash[:error] = "Group could not be created."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @group

    @group.group_type = params[:group_type]

    if @group.update(group_params)
      redirect_to @group, notice: "Group was successfully updated."
    else
      flash[:error] = "Group could not be updated"
      render :edit, status: :unprocessable_entity 
    end
  end

  def destroy
    authorize @group

    @group.destroy

    flash[:info] = "Group was successfully destroyed."
    redirect_to request.referer, status: 303
  end

  def members
    @group = Group.find(params[:group_id])
    authorize @group

    @type = params[:membership]
    @type ||= "member"

    admin_ids = @group.members.where(mem_type: 'admin').pluck(:uid)
    member_ids = @group.members.where(mem_type: 'member').pluck(:uid)

    if @type == 'admin'
      @members = User.where(id: admin_ids)
    else
      @members = User.where(id: member_ids)
    end

    @non_admins = User.where(id: member_ids - admin_ids)
    @isAdmin = admin_ids.include?(current_user.id)
  end

  def join
    if params[:id].present?
      @group = Group.find(params[:id])
      if @group.access_code != "0"
        flash[:alert] = "This group is not public"
        redirect_to schools_path and return
      end
    else 
      @group = Group.where(access_code: params[:access_code]).first
    end

    unless @group.members.exists?(uid: current_user.id, mem_type: 'member')
      @group.members.create(uid: current_user.id, mem_type: 'member')
      flash[:info] = "You joined a new group"
    else 
      flash[:alert] = "This group is already available"
    end

    redirect_to @group
  end

  def giveAdmin
    @group = Group.find(params[:group_id])
    authorize @group

    admin_requests = params[:user_ids]

    records = []

    admin_requests.each do |uid|
      records << {uid: uid, memable_id: @group.id, memable_type: 'Group', mem_type: 'admin'}
    end
    
    @group.members.insert_all!(records)

    flash[:info] = "Successfully added new admins"
    redirect_to @group, status: 303
  end

  def leave
    @group = Group.find(params[:group_id])

    Member.destroy(@group.members.where(uid: current_user.id).pluck(:id))

    if @group.members.empty?
      @group.destroy
      flash[:info] = "Group was destroyed."
    end

    redirect_to groups_path
  end

  def mass_delete
    @group = Group.find(params[:group_id])
    authorize @group
    
    @type = params[:type]
    @type ||= "member"

    Member.destroy(@group.members.where(uid: params[:user_ids], mem_type: @type).pluck(:id))

    flash[:info] = "Successfully kicked out members"

    redirect_to @group, status: 303
  end

  def reset_code
    @group = Group.find(params[:group_id])
    authorize @group

    code = helpers.generateCode()

    if Group.where(access_code: code).exists?
      code = helpers.generateCode()
    end

    @group.update(access_code: code)

    redirect_to group_widgets_path(group_id: @group.id)
  end

  def widgets
    @group = Group.find(params[:group_id])
    authorize @group

    @membership = @group.members.where(uid: current_user.id).pluck(:created_at).first
    @isAdmin = @group.members.where(uid: current_user.id, mem_type: 'admin').exists?
  end

  def activity
    @group = Group.find(params[:group_id])
    authorize @group

    @recent_posters = User.where(id: @group.group_posts.where("CREATED_AT > ?", Time.current - 10.minutes).pluck(:user_id)).limit(3).pluck(:username)
    @recent_commenters = User.where(id: Comment.where(target_type: 4, target_id: @group.group_posts.pluck(:id)).where("CREATED_AT > ?", Time.current - 10.minutes).pluck(:user_id)).limit(3).pluck(:username)

    @activity = [];

    @recent_posters.each do |poster|
      @activity << "#{poster} has posted"
    end

    @recent_commenters.each do |commenter|
      @activity << "#{commenter} has commented"
    end
  end

  private
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :description, :access_code, :group_type, :created_by, :image)
    end
end
