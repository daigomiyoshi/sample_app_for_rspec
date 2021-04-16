require 'rails_helper'

RSpec.describe Task, type: :model do
  it "is valid with all attributes" do
    task = FactoryBot.build(:task)
    expect(task).to be_valid
  end

  it "is invalid without title" do
    task = FactoryBot.build(:task, title: nil)
    task.valid?
    expect(task.errors[:title]).to include("can't be blank")
  end

  it "is invalid without status" do
    task = FactoryBot.build(:task, status: nil)
    task.valid?
    expect(task.errors[:status]).to include("can't be blank")
  end

  it "is invalid with a duplicated title" do
    FactoryBot.create(:task, title: 'タイトル')
    task = FactoryBot.build(:task, title: 'タイトル')
    task.valid?
    expect(task.errors[:title]).to include("has already been taken")
  end

  it "is valid with another title" do
    FactoryBot.create(:task, title: 'タイトルその1')
    task = FactoryBot.build(:task, title: 'タイトルその2')
    expect(task).to be_valid
  end
end
