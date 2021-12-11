module TopicsHelper
  include ActionView::Helpers::DateHelper

  def lastPoster(topic)
    if topic.last_poster.present?
      # truncate(User.where(id: topic.last_poster).pluck(:username).first, length: 10) 
      truncate(User.find(topic.last_poster).username, length: 10) 
    else
      "user"
    end
  end

  def lastPostAt(topic)
    if topic.last_post_at.present?
      distance_of_time_in_words(Time.current, topic.last_post_at)
    else
      "0 yet"
    end
  end

  def blocking(topic)
    if topic.is_blocked
      link_to topic_block_path(id: topic.id), class:'text-yellow-600 hover:text-gray-600 dark:text-yellow-400 dark:hover:text-gray-400 mr-4', "data-turbo-method": "post" do
        content_tag(:i, '', class:"fas fa-ban")
      end
    else
      link_to topic_block_path(id: topic.id), class:'text-gray-600 hover:text-yellow-600 dark:text-gray-400 dark:hover:text-yellow-400 mr-4', "data-turbo-method": "post"  do
        content_tag(:i, '', class:"fas fa-ban")
      end
    end
  end

  def getBookmarkedIcon(topic)
    if topic.likes.exists?(user_id: session[:user_id])
      content_tag(:i, '', class:"fas fa-bookmark text-yellow-600 hover:text-gray-600 dark:text-yellow-400 dark:hover:text-gray-400")
    else
      content_tag(:i, '', class:"far fa-bookmark text-gray-600 hover:text-yellow-600 dark:text-gray-400 dark:hover:text-yellow-400")      
    end
  end

end
