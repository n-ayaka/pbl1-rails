class UsersController < ApplicationController
  protect_from_forgery :except => [:add]
  # CSVでユーザー追加(新年度登録)
  def add
    text = "仮テキスト"
    # csvファイルのみ受け付ける
    if params[:file].present? && params[:file].original_filename && File.extname(params[:file].original_filename) == ".csv"
      # ヘッダー
      keys = [:school_year, :attendance_number, :user_name, :password, :card_id]
      # 一行ずつ読み込む(Excelでの作成を想定してSJIS)
      CSV.foreach(params[:file].path, {skip_blanks: true, encoding: "SJIS"}).with_index(1) do |row, lineno|
        # insert
        begin
          hashkeys = Hash[*keys.zip(row).flatten]
          User.create!(hashkeys)
          text = "CSV読み込み完了"
        # error
        rescue
          text = "#{lineno}行目を処理中にエラーが発生しました。"
        end
      end
    else
      text = "csvファイルを読み込んでください。"
    end
    # 仮メッセージ
    render plain: text
  end

  # ログイン判定
  def login
  end

  # パスワード変更
  def update
  end
end