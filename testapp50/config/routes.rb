Rails.application.routes.draw do
  get "slave" => "postamt#slave"
  get "master" => "postamt#master"
end
