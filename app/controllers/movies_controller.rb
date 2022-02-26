class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      # Part 1
      # Apply sorting on column present in params[:sort] by using ActiveRecord::QueryMethods#order
      # Reference: https://www.rubydoc.info/docs/rails/ActiveRecord%2FQueryMethods:order
      # @movies = Movie.all.order(params[:sort])
      # # Update parameter to change the backgroung colour
      # @sort_column_header = params[:sort]
      
      
      # Part 2
      # # Getting all possible valuse of ratings field from the model
      # @all_ratings = Movie.ratings
      
      # @movies = Movie.all
      
      # if params[:sort] || params[:ratings] # Check any param is set
      #   # Update parameter to change the backgroung colour of selected column
      #   @sort_column_header = params[:sort]
        
      #   # Update parameter to filter on ratings
      #   if params[:ratings]
      #     # params[:ratings] will be a has so we will take its keys only
      #     @ratings = params[:ratings].keys
      #   else
      #     # To handle case when the ratings filter was unchanged but 
      #     # sort feature was used
      #     @ratings = @all_ratings
      #   end
        
      #   @movies = @movies.where("rating IN (?)", @ratings).order(params[:sort])
      # end
      
      # Part 3
      # Getting all possible valuse of ratings field from the model
      @all_ratings = Movie.ratings
      
      if params[:sort]
        session[:sort] = params[:sort]
      end
      
      # Update parameter to change the backgroung colour of selected column
      @sort_column_header = params[:sort]
        
      if params[:ratings]
        session[:ratings] = params[:ratings]
      end
      
      # Update parameter to filter on ratings
      if params[:ratings]
        # params[:ratings] will be a has so we will take its keys only
        session[:ratings] = params[:ratings]
      else
        # # To handle case when the ratings filter was unchanged but 
        # # sort feature was used
        # session[:ratings] = @all_ratings
      end
      
      # Check if ratings are defined and handle accordingly
      session[:ratings] ||= @all_ratings
      
      if session[:ratings].is_a?(Hash)
        @ratings = session[:ratings].keys
      else
        @ratings = session[:ratings]
      end
      
      if session[:sort] != params[:sort] || session[:ratings] != params[:ratings] # Not containing the right parameters
        # Reference
        # https://apidock.com/rails/v4.2.1/ActionDispatch/Flash/FlashHash/keep
        # https://stackoverflow.com/questions/1579857/getting-the-flash-hash-to-persist-through-redirects
        # http://tramaine.me/blog/preserving-data-stored-in-the-rails-flash
        flash.keep
        
        # Reference
        # https://stackoverflow.com/questions/5599698/rails-passing-parameters-in-a-redirect-to-is-session-the-only-way
        redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
      end
      
      @movies = Movie.where("rating IN (?)", @ratings).order(session[:sort])
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end