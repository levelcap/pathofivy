# frozen_string_literal: true

Rails.application.routes.draw do
  resources :characters
  get 'characters/:name', to: 'characters#characterByName'
  root 'welcome#index'
end
