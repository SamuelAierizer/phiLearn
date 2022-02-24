Rails.application.routes.draw do

  get 'notifications', to: 'notifications#index'
  post 'notifications', to: 'notifications#create'
  post 'notifications/read', to: 'notifications#read'
  get 'notifications/display', to: 'notifications#display'
  delete 'notifications/mass_delete', to: 'notifications#mass_delete'

  post 'group_post/like', to: 'group_posts#like'
  resources :group_posts do
    resources :comments, controller: 'group_comments' do
      post 'like', to: 'group_comments#like'
    end
  end

  post 'group/join', to: 'groups#join'
  post 'group/leave', to: 'groups#leave'
  resources :groups do
    post 'reset_code', to: 'groups#reset_code'
    get 'widgets', to: 'groups#widgets'
    post 'giveAdmin', to: 'groups#giveAdmin'
    get 'members', to: 'groups#members'
    delete 'members', to: 'groups#mass_delete'
  end

  post 'forum/school_toggle', to: 'forums#school_toggle'
  post 'forum/courses_toggle', to: 'forums#courses_toggle'
  get 'forum/school', to: 'forums#get_for_school'
  get 'forum', to: 'forums#show'

  post 'topic/block', to: 'topics#block'
  post 'topic/bookmark', to: 'topics#bookmark'
  resources :topics

  post 'post/like', to: 'posts#like'
  resources :posts

  resources :comments
  resources :resources

  resources :answers
  resources :questions

  delete 'solutions/mass_delete', to: 'solutions#mass_delete'
  resources :solutions
  
  delete 'assignments/mass_delete', to: 'assignments#mass_delete'
  resources :assignments do
    delete :delete_files_attachment
    resources :comments
  end

  delete 'lectures/mass_delete', to: 'lectures#mass_delete'
  resources :lectures do
    delete :delete_files_attachment
    resources :comments
  end

  delete 'courses/mass_delete', to: 'courses#mass_delete'
  resources :courses do
    get 'statistics', to: 'courses#stats'
    get 'add_users', to: 'courses#add_users'
    get 'new_users', to: 'courses#new_users'
    post 'populate', to: 'courses#populate'
    get 'grades', to: 'courses#grades'
    post 'toggle', to: 'courses#toggle_user'
    delete :delete_files_attachment
    resources :comments
  end

  namespace :student do
    resources :solutions

    resources :assignments do
      resources :comments
    end

    resources :lectures do
      resources :comments
    end

    resources :courses do
      get 'grades', to: 'courses#grades'
      get 'deadlines', to: 'courses#deadlines'
      resources :comments
    end
  end
  
  get 'schools/search', to: 'schools#search'
  get 'schools/overview', to: 'schools#overview'
  resources :schools

  get 'admin', to: 'admin#index'
  get 'admin/stats', to: 'admin#general_stats'
  get 'admin/forum', to: 'admin#forum_panel'
  get 'admin/accounts/import', to: 'admin#import'
  get 'admin/accounts/export', to: 'admin#export'
  get 'admin/trash', to: 'admin#trash'
  get 'admin/trash/users', to: 'admin#trash_users'
  get 'admin/trash/courses', to: 'admin#trash_courses'
  get 'admin/trash/lectures', to: 'admin#trash_lectures'
  get 'admin/trash/assignments', to: 'admin#trash_assignments'
  get 'admin/trash/solutions', to: 'admin#trash_solutions'
  get 'admin/trash/forums', to: 'admin#trash_forums'
  get 'admin/trash/topics', to: 'admin#trash_topics'
  get 'admin/trash/posts', to: 'admin#trash_posts'
  get 'admin/trash/restore', to: 'admin#restore'
  delete 'admin/trash/empty', to: 'admin#empty'


  get 'public/profiles/:username', to: 'profiles#public'
  put 'public/profiles/:username', to: 'profiles#cover_update'
  resources :profiles

  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  devise_scope :user do
    get 'users', to: 'users/general#index'
    delete 'users/clear', to: 'users/registrations#clear'
    post 'users/import', to: 'users/registrations#import'
    delete 'users/mass_delete', to: 'users/registrations#mass_delete'
  end

  get 'home/about'
  root 'home#index'
end
