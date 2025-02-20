require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }
  before do
    visit login_path
  end

  describe 'ログイン前' do
    context 'フォームの入力値が正常' do
      it 'ログイン処理が成功する' do
        login(user, password)
        expect(current_path).to eq root_path
        expect(page).to have_content 'Login successful'
      end
    end
    context 'フォームが未入力' do
      it 'ログイン処理が失敗する' do
        login(user, '')
        expect(current_path).to eq login_path
        expect(page).to have_content 'Login failed'
      end
    end
  end

  describe 'ログイン後' do
    context 'ログアウトボタンをクリック' do
      it 'ログアウト処理が成功する' do
        login(user, password)
        click_on 'Logout'
        expect(current_path).to eq root_path
        expect(page).to have_content('Logged out')
      end
    end
  end
end
