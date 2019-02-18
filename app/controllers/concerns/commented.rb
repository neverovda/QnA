module Commented
  extend ActiveSupport::Concern

  included do
    expose :comment, ->{ Comment.new }
  end
  
end
