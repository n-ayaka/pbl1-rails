class UsersController < ApplicationController
  protect_from_forgery :except => [:add]
  protect_from_forgery :except => [:backup]
  # CSVでユーザー追加(新年度登録)
  def add
    text = "仮テキスト"
    # csvファイルのみ受け付ける
    if params[:file].present? && params[:file].original_filename && File.extname(params[:file].original_filename) == ".csv"
      # ヘッダー
      keys = [:school_year, :attendance_number, :user_name, :password, :card_id]

      # 一行ずつ読み込む(任意の文字コード->UTF-8に書き換える)
      CSV.parse( NKF::nkf('-w',File.read(params[:file].path)) ) do |row|
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

  # バックアップ関連
  def backup
    require 'rake'
    Rails.application.load_tasks
    if params[:status] == "dump"
      Rake::Task['backup/dump_all'].execute
      Rake::Task['backup/dump_all'].clear
    elsif params[:status] == "restore"
      Rake::Task['backup/restore'].execute
      Rake::Task['backup/restore'].clear
    else
      #ERROR
    end
  end

end
