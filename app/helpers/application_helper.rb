module ApplicationHelper

  def like_path(thing)
    return like_question_path(thing) if thing.class == Question
    return like_answer_path(thing) if thing.class == Answer
  end

  def dislike_path(thing)
    return dislike_question_path(thing) if thing.class == Question
    return dislike_answer_path(thing) if thing.class == Answer
  end

end
