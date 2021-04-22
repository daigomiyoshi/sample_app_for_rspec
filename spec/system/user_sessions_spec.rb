require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  describe 'ログイン前' do
    let(:user) { create(:user) }
    before do
      visit login_path
    end
    context 'フォームの入力値が正常' do
      it 'ログイン処理が成功する' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Login'
        expect(current_path).to eq root_path
        expect(page).to have_content 'Login successful'
      end
    end
    context 'フォームが未入力' do
      it 'ログイン処理が失敗する'
      # expect(page).to have_content 'Login failed'
    end
  end

  describe 'ログイン後' do
    context 'ログアウトボタンをクリック' do
      it 'ログアウト処理が成功する'
    end
  end
end
