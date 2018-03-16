class TopCommentersController < ApplicationController
  def index
    @commenters = User.joins(:comments).
      where(comments: { discarded_at: nil, created_at: 7.days.ago..DateTime.now } ).
      group(:id).
      order("count(comments.id) desc").
      limit(10).uniq
  end
end
