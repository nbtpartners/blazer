Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  #TODO user.present? 를 user.admin? 으로 교체한다
  authenticate :user, -> (user) { user.present? } do
    mount Blazer::Engine, at: "blazer"
  end
end
