Rails.application.routes.draw do

  # 出席状況管理画面
  get '/month/:year/:month' => 'atts#atnds_all_students'
  # 出席状況詳細画面
  get '/month/:year/:month/student/:student' => 'atts#atnds_one_student'
  # 欠席理由変更画面
  put '/attendances/:student/:date' => 'atts#update_attendance'
  #
  post '/school-days' => 'school_days#add'

  # ICカードがタッチされたとき
  get '/ic/:cid' => 'atts#getTougekouRecord'
  post '/ic' => 'atts#getTougekouRecord'

  # CSVでユーザー登録
  post '/csv-read' => 'users#add'
  #resources 'users', only: :add do
  #  collection { post :add }
  #end

  # 任意バックアップ(dump)と復元(restore)
  post '/backup' => 'users#backup'

end
