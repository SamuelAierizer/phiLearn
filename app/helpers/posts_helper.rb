module PostsHelper
  include ActionView::Helpers::DateHelper

  def getHeart(post)
    if post.likes.exists?(user_id: session[:user_id])
      content_tag(:i, '', class:"fas fa-heart text-red-600")
    else
      content_tag(:i, '', class:"far fa-heart")      
    end
  end

  def mainReplyButton(topic)
    unless topic.is_blocked
      content_tag :button, "data-action": 'click->toggle#show touch->toggle#show click->reply#setParent click->reply#setText', "data-reply-text-param": 'current topic', id: 0, class:"btn-sm btn-lime" do 
        "Reply"
      end
    end
  end

  def replyButton(post)
    unless post.topic.is_blocked
      content_tag :div, class:"ml-1 hover:bg-gray-200 px-1" do
        content_tag :button, "data-action": 'click->toggle#show touch->toggle#show click->reply#setParent click->reply#setText', "data-reply-text-param": "#{post.user.username}'s post - #{truncate(post.content)}", id: post.id,  class:"p-1" do           
          concat content_tag :i, '', class:"fas fa-reply mr-1", id: post.id
          concat content_tag :span, "Reply", id: post.id
        end
      end
    end
  end

  # these are for group posts only

  def likeCounter(group_post)
    counter = 0
    hide = ""
    if group_post.like_count > 0
      counter = group_post.like_count
    else 
      hide = "hidden"
    end

    content_tag :button, class:"flex flex-row items-center px-2 py-1 #{hide}" do
      concat content_tag :span, counter, class:"flex justify-center align-items-center w-4 h-4 bg-gray-200 rounded-full text-xs font-semibold text-gray-700", "data-bird-target": "counter"
      concat content_tag :span, "likes", class:"ml-1 text-sm dark:text-white"
    end      
  end

  def commentCounter(group_post)
    if group_post.comments.exists?
      content_tag :button, class:"flex flex-row items-center px-2 py-1" do
        concat content_tag :span, group_post.comments.count, class:"flex justify-center align-items-center w-4 h-4 bg-gray-200 rounded-full text-xs font-semibold text-gray-700"
        concat content_tag :span, "comments", class:"ml-1 text-sm dark:text-white"
      end
    end
  end  

end
