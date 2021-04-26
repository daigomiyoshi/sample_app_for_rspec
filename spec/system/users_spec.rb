require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      before do
        visit sign_up_path
      end
      context 'フォームの入力値が正常' do
        let(:user) { build(:user) }
        it 'ユーザーの新規登録が成功する' do
          expect{
            fill_in 'user_email', with: user.email
            fill_in 'user_password', with: user.password
            fill_in 'user_password_confirmation', with: user.password_confirmation
            click_button 'SignUp'
          }.to change(User, :count).by(1)
          expect(current_path).to eq login_path
          expect(page).to have_content 'User was successfully created.'
        end
      end
      context 'メールアドレスが未入力' do
        let(:user_without_email) { build(:user, email: '') }
        it 'ユーザーの新規登録が失敗する' do
          expect{
            fill_in 'user_email', with: user_without_email.email
            fill_in 'user_password', with: user_without_email.password
            fill_in 'user_password_confirmation', with: user_without_email.password_confirmation
            click_button 'SignUp'
          }.not_to change(User, :count)
          expect(current_path).to eq users_path
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済みのメールアドレスを使用' do
        let!(:user) { create(:user, email: 'example@example.com') }
        let(:user_with_duplicated_email) { build(:user, email: 'example@example.com') }
        it 'ユーザーの新規登録が失敗する' do
          expect{
            fill_in 'user_email', with: user_with_duplicated_email.email
            fill_in 'user_password', with: user_with_duplicated_email.password
            fill_in 'user_password_confirmation', with: user_with_duplicated_email.password_confirmation
            click_button 'SignUp'
          }.not_to change(User, :count)
          expect(current_path).to eq users_path
          expect(page).to have_content 'Email has already been taken'
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit user_path(1)
          expect(current_path).to eq login_path
          expect(page).to have_content 'Login required'
        end
      end
    end
  end

  describe 'ログイン後' do
    let(:password) { 'password' }
    let(:password_changed) { 'password_changed' }
    let!(:user) { create(:user, password: password) }
    let!(:user_with_some_email) { create(:user, email: 'example@example.com') }
    let!(:another_user) { create(:user, password: password) }
    before do
      visit login_path
      login(user, password)
    end
    describe 'ユーザー編集' do
      before do
        visit edit_user_path(user.id)
      end
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          fill_in 'user_email', with: user.email
          fill_in 'user_password', with: password_changed
          fill_in 'user_password_confirmation', with: password_changed
          click_button 'Update'
          expect(current_path).to eq user_path(user.id)
          expect(page).to have_content 'User was successfully updated.'
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          fill_in 'user_email', with: ''
          fill_in 'user_password', with: password_changed
          fill_in 'user_password_confirmation', with: password_changed
          click_button 'Update'
          expect(current_path).to eq user_path(user.id)
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済みのメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          fill_in 'user_email', with: user_with_some_email.email
          fill_in 'user_password', with: password_changed
          fill_in 'user_password_confirmation', with: password_changed
          click_button 'Update'
          expect(current_path).to eq user_path(user.id)
          expect(page).to have_content 'Email has already been taken'
        end
      end
      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスに失敗する' do
          visit edit_user_path(another_user.id)
          expect(current_path).to eq user_path(user.id)
          expect(page).to have_content 'Forbidden access.'
        end
      end
    end

    describe 'マイページ' do
      before do
        visit user_path(user.id)
      end
      context 'タスクを作成' do
        let(:task_title) { 'task_title' }
        let(:task_content) { 'task_content' }
        let(:task_status) { 'doing' }
        let(:task_deadline) { 1.week.from_now }
        it '新規作成したタスクが表示される' do
          visit new_task_path
          fill_in 'task_title', with: task_title
          fill_in 'task_content', with: task_content
          select task_status, from: 'task_status'
          fill_in 'task_deadline', with: task_deadline
          click_button 'Create Task'
          expect(current_path).to eq task_path(Task.first.id)
          expect(page).to have_content 'Task was successfully created.'
        end
      end
    end
  end
end
