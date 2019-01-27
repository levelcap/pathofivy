# frozen_string_literal: true

Rails.application.routes.draw do
  resources :characters
  get '/characters/:name/faction', to: 'characters#faction'
  get '/characters/:channel/:name/sheet', to: 'characters#sheet'
  get '/characters/:channel/:name/report', to: 'characters#report'
  get '/admin/timeout', to: 'admin#toggleTimeout'
  get '/admin/boss', to: 'admin#bossFight'
  get '/admin/addboss', to: 'admin#addBoss'
  get '/admin/factions', to: 'admin#factionScore'
  get '/nothing', to: 'characters#nothing'
  root 'welcome#index'
end
