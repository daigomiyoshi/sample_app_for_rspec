require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  describe 'タスクの新規作成' do
    context 'フォームの入力値が正常' do
      it 'タスクの新規作成が成功する'
    end
    context 'ログインしていない状態' do
      it '新規作成ページへのアクセスが失敗する'
    end
  end

  describe 'タスクの編集' do
    context 'フォームの入力値が正常' do
      it 'タスクの編集が成功する'
    end
    context 'ログインしていない状態' do
      it '編集ページへのアクセスが失敗する'
    end
    context '他ユーザーの編集ページにアクセス' do
      it '編集ページへのアクセスが失敗する'
    end
  end

  describe 'タスクの削除' do
    context '削除ボタンをクリック' do
      it 'タスクの削除が成功する'
    end
  end
end
