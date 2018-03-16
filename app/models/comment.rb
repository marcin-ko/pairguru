class Comment < ApplicationRecord
  include Discard::Model
  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :commenter, polymorphic: true, counter_cache: true

  validates :commentable, presence: true
  validates :commenter, presence: true
  validates :commenter_id, uniqueness: {
    scope: :commentable,
    conditions: -> { where(discarded_at: nil) },
    message: ->(comment, data) { "one comment per #{comment.commentable_type}" }
  }
  validates :text, presence: true, length: { minimum: 3 }
end
