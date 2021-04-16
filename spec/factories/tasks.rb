FactoryBot.define do
  factory :task do
    title { 'タイトル' }
    content { '本文' }
    status { 0 }
    deadline { DateTime.now }
    association :user
  end
end
