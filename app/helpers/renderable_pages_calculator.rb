class RenderablePagesCalculator
  attr_accessor :total_pages, :current_page

  def initialize(total_pages, current_page)
    self.total_pages = total_pages
    self.current_page = current_page
  end

  def numbers
    result = []

    (1..total_pages).each do |page|
      if near_boundaries?(page) || near_current_page?(page)
        result << page
      elsif result[-1]
        result << nil
      end
    end

    result
  end

  private

  def near_boundaries?(page)
    page < 3 || page > total_pages - 2
  end

  def near_current_page?(page)
    page.between?(current_page - 1, current_page + 1)
  end
end