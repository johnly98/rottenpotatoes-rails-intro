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
    @all_ratings = Movie.get_ratings
    if params.key?(:ratings) && params.key?(:sort)
      session[:ratings] = params[:ratings]
      session[:sort] = params[:sort]
      ratings = params[:ratings].keys
      @checked = ratings
      @date = ""
      @title = ""
      if params[:sort] == "by_date"
        @movies = Movie.with_ratings(ratings).order("release_date")
        @date = "hilite"
      elsif params[:sort] == "by_title"
        @movies = Movie.with_ratings(ratings).order("title")
        @title = "hilite"
      else 
        @movies = Movie.with_ratings(ratings)
      end
    else
      if !params.key?(:ratings) && params.key?(:sort)
        sort = params[:sort]
        ratings = session[:ratings]
      elsif params.key?(:ratings) && !params.key?(:sort)
        sort = session[:sort]
        ratings = params[:ratings]  
      else
        ratings = session[:ratings] = Hash[Movie.get_ratings.collect { |v| [v, 1] }]
        sort = session[:sort] = "none"
      end
      flash.keep
      redirect_to movies_path(:sort => sort, :ratings => ratings), :method => :get
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
