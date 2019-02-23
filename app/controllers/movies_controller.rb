class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params.key?(:ratings)
      ratings = params[:ratings].keys
    else
      ratings = Movie.get_ratings
    end


    @all_ratings = Movie.get_ratings
    if params.key?(:sort)
      if params[:sort] == "by_date"
        @movies = Movie.with_ratings(ratings).order("release_date")
        @sort_by = "date"
      else
        @movies = Movie.with_ratings(ratings).order("title")
        @sort_by = "title"
      end
    else
      @sort_by = "none"
      @movies = Movie.with_ratings(ratings)

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




end
