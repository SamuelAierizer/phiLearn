module GroupsHelper
  def generateCode
    return Array.new(3) { rand(256) }.pack('C*').unpack('H*').first
  end

  def displayActivity (activity)
    unless activity.empty?
      content_tag :div, class:"flex flex-col" do
        activity.each do |text|
          concat content_tag(:span, text)
        end
      end
    else
      content_tag :div, class:"flex items-center" do
        concat content_tag(:i, "", class:"fas fa-circle h-2 w-2 text-blue-800 animate-pulse mr-4")
        concat content_tag(:span, "No recent activity")
      end
    end
  end
end