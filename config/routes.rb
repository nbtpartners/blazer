Blazer::Engine.routes.draw do
  resources :queries do
    post :run, on: :collection # err on the side of caution
    post :cancel, on: :collection
    post :refresh, on: :member
    get :tables, on: :collection
    get :schema, on: :collection
    post :export, on: :member
    get :summarize_table, on: :collection
    post :show_link, on: :collection
    post :upload_s3, on: :collection
    post :total_rows, on: :collection
  end
  resources :checks, except: [:show] do
    get :run, on: :member
  end
  resources :dashboards do
    post :refresh, on: :member
  end
  root to: "queries#home"
end
