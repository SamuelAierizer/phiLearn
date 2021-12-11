class HomeController < ApplicationController
  after_action :skip_authorization
  after_action :skip_policy_scope

  def index
  end

  def about
  end
end
