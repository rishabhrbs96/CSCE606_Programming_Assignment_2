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
      # Getting all possible valuse of ratings field from the model
      @all_ratings = Movie.ratings
      
      @movies = Movie.all
      
      if params[:sort] || params[:ratings] # Check any param is set
        # Update parameter to change the backgroung colour of selected column
        @sort_column_header = params[:sort]
        
        # Update parameter to filter on ratings
        if params[:ratings]
          # params[:ratings] will be a has so we will take its keys only
          @ratings = params[:ratings].keys
        else
          # To handle case when the ratings filter was unchanged but 
          # sort feature was used
          @ratings = @all_ratings
        end
        
        @movies = @movies.where("rating IN (?)", @ratings).order(params[:sort])
      end
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