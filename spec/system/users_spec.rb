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
          expect(page).to have_content 'Email can\'t be blank'
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
    # let(:user) { create(:user) }
    # before do
    #   visit login_path
    #   fill_in 'email', with: user.email
    #   fill_in 'password', with: user.password
    #   click_button 'Login'
    # end
    describe 'ユーザー編集' do
      # before do
      #   visit edit_user_path(user.id)
      # end
      # context 'フォームの入力値が正常' do
      #   let(:user_changed) { build(:user, password: 'password_changed', password_confirmation: 'password_changed')}
      #   it 'ユーザーの編集が成功する' do
      #     fill_in 'user_email', with: user_changed.email
      #     fill_in 'user_password', with: user_changed.password
      #     fill_in 'user_password_confirmation', with: user_changed.password_confirmation
      #     expect(current_path).to to eq user_path(user_changed.id)
      #     expect(page).to have_content 'User was successfully updated.'
      #   end
      # end
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する'
      end
      context '登録済みのメールアドレスを使用' do
        it 'ユーザーの編集が失敗する'
      end
      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスに失敗する'
      end
    end

    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される'
      end
    end
  end
end
