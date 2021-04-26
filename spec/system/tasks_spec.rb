require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }
  let(:task) { create(:task) }

  describe 'ログイン前' do
    context 'タスクの新規作成ページへのアクセス' do
      it '新規作成ページへのアクセスが失敗する' do
        visit new_task_path
        expect(current_path).to eq login_path
        expect(page).to have_content 'Login required'
      end
    end

    context 'タスクの編集ページへのアクセス' do
      it '編集ページへのアクセスが失敗する' do
        visit edit_task_path(task)
        expect(current_path).to eq login_path
        expect(page).to have_content 'Login required'
      end
    end

    context 'タスクの詳細ページにアクセス' do
      it 'タスクの詳細情報が表示される' do
        visit task_path(task)
        expect(current_path).to eq task_path(task)
        expect(page).to have_content task.title
      end
    end

    context 'タスクの一覧ページにアクセス' do
      it 'すべてのユーザーのタスクが表示される' do
        task_list = create_list(:task, 3)
        visit tasks_path
        expect(page).to have_content task_list[0].title
        expect(page).to have_content task_list[1].title
        expect(page).to have_content task_list[2].title
        expect(current_path).to eq tasks_path
      end
    end
  end

  describe 'ログイン後' do
    before do
      visit login_path
      login(user, password)
    end
    
    describe 'タスクの新規作成' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功' do
          visit new_task_path
          fill_in 'task_title', with: 'title test'
          fill_in 'task_content', with: 'content test'
          select 'doing', from: 'task_status'
          fill_in 'task_deadline', with: DateTime.new(2021, 6, 1, 0, 0)
          click_button 'Create Task'
          expect(current_path).to eq task_path(1)
          expect(page).to have_content 'Task was successfully created.'
          expect(page).to have_content 'Title: title test'
          expect(page).to have_content 'Content: content test'
          expect(page).to have_content 'Status: doing'
          expect(page).to have_content 'Deadline: 2021/6/1 0:0'
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          fill_in 'task_title', with: ''
          fill_in 'task_content', with: 'content test'
          click_button 'Create Task'
          expect(current_path).to eq tasks_path
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title can't be blank"
        end
      end

      context '登録済のタイトルを入力' do
        it 'タスクの新規作成が失敗する' do
          other_task = create(:task)
          visit new_task_path
          fill_in 'task_title', with: other_task.title
          fill_in 'task_content', with: 'content test'
          click_button 'Create Task'
          expect(current_path).to eq tasks_path
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content 'Title has already been taken'
        end
      end
    end

    describe 'タスクの編集' do
      let!(:task) { create(:task, user: user) }
      let(:other_task) { create(:task, user: user) }
      before { visit edit_task_path(task) }

      context 'フォームの入力値が正常' do
        it 'タスクの編集が成功' do
          fill_in 'task_title', with: 'title changed'
          fill_in 'task_content', with: 'content changed'
          select 'done', from: 'task_status'
          click_button 'Update Task'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content 'Title: title changed'
          expect(page).to have_content 'Content: content changed'
          expect(page).to have_content 'Status: done'
          expect(page).to have_content 'Task was successfully updated.'
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの編集が失敗する' do
          fill_in 'task_title', with: nil
          select 'done', from: 'task_status'
          click_button 'Update Task'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title can't be blank"
        end
      end

      context '登録済のタイトルを入力' do
        it 'タスクの編集が失敗する' do
          fill_in 'task_title', with: other_task.title
          fill_in 'task_content', with: 'content test'
          click_button 'Update Task'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content 'Title has already been taken'
        end
      end
    end

    describe 'タスクの削除' do
      let!(:task) { create(:task, user: user) }

      context '削除ボタンをクリック' do
        it 'タスクの削除が成功' do
          visit root_path
          click_on 'Destroy'
          expect{
            expect(page.accept_confirm).to eq 'Are you sure?'
            expect(page).to have_content 'Task was successfully destroyed.'
            expect(page).not_to have_content task.title
            expect(current_path).to eq tasks_path
          }.to change(user.tasks, :count).by(-1)
        end
      end
    end
  end
end
