ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  map.home '/', :controller => 'matrix', :action => 'show', :id => 1
  
  map.resources :matrix do |matrix|
    matrix.resources :frame
  end
  
end
