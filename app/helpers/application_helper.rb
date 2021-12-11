module ApplicationHelper
  def paginate(entries)
    content_tag :ul, class: "flex mr-4 rounded font-semibold dark:font-bold text-lg" do
      concat render_pagination_link("<", entries.current_page - 1, entries.current_page <= 1)

      render_page_numbers(entries.total_pages, entries.current_page)

      concat render_pagination_link(">", entries.current_page + 1, entries.current_page == entries.total_pages)
    end
  end

  def render_page_numbers(total_pages, current_page)
    calculator = RenderablePagesCalculator.new(total_pages, current_page)
    calculator.numbers.each do |number|
      if number
        concat render_pagination_link(number, number, number == current_page)
      else
        concat content_tag(:span, "...", class:"w-full px-4 py-2 border dark:border-white text-base text-gray-600 dark:text-gray-100 bg-white dark:bg-gray-800 hover:bg-gray-100 dark:hover:bg-black")
      end
    end
  end

  def render_pagination_link(label, page, disabled)
    content_tag :li do
      if disabled
        content_tag(:span, label, class:"w-full px-4 py-2 border dark:border-white text-base text-blue-600 bg-white dark:bg-gray-800 hover:bg-gray-100 dark:hover:bg-black")
      else
        path = params
          .to_unsafe_h
          .merge(page: page, only_path: true)
          .except(:script_name, :original_script_name)
        link_to label, path, class:"w-full px-4 py-2 border dark:border-white text-base text-gray-600 dark:text-gray-100 bg-white dark:bg-gray-800 hover:bg-gray-100 dark:hover:bg-black"
      end
    end
  end

  def tailwind_classes_for(flash_type)
    {
      notice: "bg-green-400 border-l-4 border-green-700 text-white",
      info:   "bg-blue-400 border-l-4 border-blue-700 text-whit",
      error:  "bg-red-400 border-l-4 border-red-700 text-black",
      alert:  "bg-yellow-300 border-l-4 border-yellow-600 text-black",
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end


  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
