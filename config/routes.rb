Rails.application.routes.draw do
  root 'links#index'
  get '/:slug' => 'links#redirect', as: 'shortened_link'
  post '/' => 'links#create'
end
