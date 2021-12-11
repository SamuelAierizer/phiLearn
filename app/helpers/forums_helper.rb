module ForumsHelper

  def getTopicsCount(forum)
    Topic.where(forum_id: forum.id).count
  end

  def getPostsCount(forum)
    Post.where(topic_id: Topic.where(forum_id: forum.id).pluck(:id)).count
  end

  def forumName(forum)
    if forum.forumable_type == 'School'
      'School Forum'
    else
      @forum.forumable.name + ' Forum'
    end
  end
end
