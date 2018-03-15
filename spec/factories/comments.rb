FactoryBot.define do
  factory :comment do
    commentable { create(:movie) }
    commenter { create(:user) }
    text "MyText"
  end
end
