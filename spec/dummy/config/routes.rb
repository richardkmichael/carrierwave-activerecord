Rails.application.routes.draw do
  root :to => 'people#index'

  resources :people do
    # # Model has a directly mounted uploader.
    # member do
    #   get '/file/:filename' => 'article_files#show', :format => :false,
    #                                                  :filename => /[^\/]*/
    # end
  end

  # Model has_many uploaded files, each as a model with an uploader.
  # get '/articlefiles/:id/file/:filename' => 'article_files#show', :format => :false

end
