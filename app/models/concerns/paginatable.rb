module Paginatable
  extend ActiveSupport::Concern
  
  included do
    scope :paginate, -> (page:, per_page: 10) {
      page = (page || 1).to_i
      per_page = per_page.to_i
  
      current_scope = limit(per_page).offset(per_page * (page - 1))
  
      PaginationResult.new(current_scope).tap do |result|
        result.current_page = page
        result.total_pages = (count / per_page.to_f).ceil
      end
    }
  
    class PaginationResult < SimpleDelegator
      attr_accessor :current_page, :total_pages
    end
  end
end