Rails.application.routes.draw do
  # 出席状況管理画面
  get '/month/:year/:month' => 'atts#atndsAllStudents'
  # 出席状況詳細画面
  get '/month/:year/:month/student/:student' => 'atts#atndsOneStudent'

  # TODO
  # 欠席理由変更画面 変更する行のatt_id,n限目,変更後の値
  put '/attendance/:attid/:period/:att' => 'atts#atndsAttUpdate'

  # ICカードがタッチされたとき
  get '/ic/:cid/:time/:iname' => 'atts#getTougekouRecord'

  #get '/ic/:cid' => 'atts#test'
  post '/ic' => 'atts#test'
  put '/ic' => 'atts#test'

end
