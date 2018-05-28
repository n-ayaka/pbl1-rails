Rails.application.routes.draw do
  # [出欠状況管理]欲しい情報 -> 日付(その日付から登校日5日分取得)
  get 'atts/index/:date' => 'atts#index'
  # [出欠状況詳細]欲しい情報 -> ユーザーID,日付(その月のデータを取得)
  get 'atts/show/:id/:date' => 'atts#show'
  # [欠席理由変更]欲しい情報 => ユーザーID,変更する日付,n限目,変更後の値
  # もしくは、変更する行のatt_id,n限目,変更後の値
  get 'atts/change/:id/:date/:period/:att' => 'atts#change'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
