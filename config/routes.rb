# frozen_string_literal: true

Rails.application.routes.draw do
  resources :characters
  get 'characters/:name', to: 'characters#characterByName'
  get '/admin/timeout', to: 'admin#toggleTimeout'
  get '/admin/boss', to: 'admin#bossFight'
  root 'welcome#index'
end
