class ArticlesController < ApplicationController
  
  #includes 'set_article' method in the following routes
  before_action :set_article, only: [:edit, :update, :show, :destroy]
  
  #includes 'require_user' method in the following routes
  before_action :require_user, except: [:index, :show]
  
  before_action :require_same_user, only: [:edit, :update, :destroy]
  
  #index page (/articles)
  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end
  
  #Form to create new article (articles/new)
  def new
    @article = Article.new
  end
  
  #Posts an article from (articles/new)
  def create
    #render plain: params[:article].inspect 
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save 
        flash[:success] = "Article was successfully created" 
        redirect_to article_path(@article)
    else
      render :new 
    end
  end
  
  #Show page (/articles/:id)
  def show  
#      @article = Article.find(params[:id])
  end
  
  #Page to edit (/articles/:id/edit)
  def edit
#     @article = Article.find(params[:id])
  end
  
  #Posts the updated article (articles/:id)
  def update
#     @article = Article.find(params[:id])
    if @article.update(article_params)
      flash[:success] = "Article was successfully updated"
      redirect_to article_path(@article)
    else
      render :edit
    end
  end
  
  #Delete route (/articles/:id)
  def destroy
#     @article = Article.find(params[:id])
    @article.destroy
    flash[:danger] = "Article was successfully deleted"
    redirect_to articles_path         
  end

 
   private
     def set_article
       @article = Article.find(params[:id])
     end
  
    #method to add data to the database
    def article_params
      params.require(:article).permit(:title, :description) 
    end
  
     def require_same_user
      if current_user != @article.user and !current_user.admin? 
      flash[:danger] = "You can only edit or delete your own articles"
      redirect_to root_path
      end
    end
 
end