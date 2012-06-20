class ArticleFilesController < ApplicationController

  # WARNING: Exposes all your files, without any security checks.
  def show

    # A file mounted directly on the model.
    # article = Article.find(params[:id])

    # The model has_many files.
    article_file = ArticleFile.find(params[:id])
    send_data(article_file.file.read)
  end

end
