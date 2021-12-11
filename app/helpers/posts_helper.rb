module PostsHelper
  include ActionView::Helpers::DateHelper

  def posted_at(post)
    distance_of_time_in_words(Time.current, post.created_at) + ' ago'
  end

  def getHeart(post)
    if post.likes.exists?(user_id: session[:user_id])
      content_tag(:i, '', class:"fas fa-heart text-red-600")
    else
      content_tag(:i, '', class:"far fa-heart")      
    end
  end

  def mainReplyButton(topic)
    unless topic.is_blocked
      content_tag :button, "data-action": 'click->toggle#show touch->toggle#show click->reply#setParent', id: 0, class:"btn-sm btn-lime" do 
        "Reply"
      end
    end
  end

  def replyButton(post)
    unless post.topic.is_blocked
      content_tag :div, class:"ml-1 hover:bg-gray-200 px-1" do
        content_tag :button, "data-action": 'click->toggle#show touch->toggle#show click->reply#setParent', id: post.id,  class:"p-1" do           
          concat content_tag :i, '', class:"fas fa-reply mr-1", id: post.id
          concat content_tag :span, "Reply", id: post.id
        end
      end
    end
  end

end
