require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  describe 'ログイン前' do
    context '新規作成ページへのアクセス' do
      it '新規作成ページへのアクセスが失敗する' do
        visit new_task_path
        expect(current_path).to eq login_path
        expect(page).to have_content 'Login required'
      end
    end
    context '編集ページへのアクセス' do
      it '編集ページへのアクセスが失敗する' do
        visit edit_task_path(1)
        expect(current_path).to eq login_path
        expect(page).to have_content 'Login required'
      end
    end
  end

  describe 'ログイン後' do
    let(:password) { 'password' }
    let(:user) { create(:user, password: password) }
    before do
      visit login_path
      login(user, password)
    end
    
    describe 'タスクの新規作成' do
      let(:task) { build(:task, user_id: user.id) }
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功' do
          visit new_task_path
          fill_in 'task_title', with: task.title
          fill_in 'task_content', with: task.content
          select task.status, from: 'task_status'
          fill_in 'task_deadline', with: task.deadline
          click_button 'Create Task'
          expect(current_path).to eq task_path(task.user_id)
          expect(page).to have_content 'Task was successfully created.'
        end
      end
    end

    describe 'タスクの編集' do
      let(:task) { create(:task, user_id: user.id) }
      context 'フォームの入力値が正常' do
        let(:title_changed) { 'title changed' }
        let(:content_changed) { 'content changed' }
        let(:status_changed) { 'doing' }
        it 'タスクの編集が成功' do
          visit edit_task_path(task.id)
          fill_in 'task_title', with: title_changed
          fill_in 'task_content', with: content_changed
          select status_changed, from: 'task_status'
          click_button 'Update Task'
          expect(current_path).to eq task_path(task.user_id)
          expect(page).to have_content 'Task was successfully updated.'
        end
      end
      context '他ユーザーの編集ページにアクセス' do
        let(:another_user) { create(:user) }
        let(:another_task) { create(:task, user_id:another_user.id) }
        it '編集ページへのアクセスが失敗する' do
          visit edit_task_path(another_task.id)
          expect(current_path).to eq root_path
          expect(page).to have_content 'Forbidden access.'
        end
      end
    end

    describe 'タスクの削除' do
      let!(:task) { create(:task, user_id: user.id) }
      context '削除ボタンをクリック' do
        it 'タスクの削除が成功' do
          visit root_path
          click_on 'Destroy'
          expect{
            expect(page.accept_confirm).to eq 'Are you sure?'
            expect(page).to have_content 'Task was successfully destroyed.'
            expect(current_path).to eq tasks_path
          }.to change(user.tasks, :count).by(-1)
        end
      end
    end
  end
end
