Rails.application.routes.draw do
  get 'atts/index'
  get 'atts/show/:id' => 'atts#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
