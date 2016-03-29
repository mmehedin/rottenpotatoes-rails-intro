class MoviesController < ApplicationController
  
  def index
    @movies = Movie.all
    #@movies.sort{ |a,b| a.title.downcase <=> b.title.downcase }
    #@movies = Movie.all.order(:title)
    #@all_ratings = ['G', 'PG', 'PG-13', 'NC-17', 'R']
   
    @all_ratings = Movie.all_ratings
    redirect = false
    
    
    
    #logger.debug(session.inspect)
    #if (params[:ratings_] != "[]" )
     #   @movies = Movie.order_title_ratings(params[:ratings_].keys.to_s)
    #end
    
    puts 'hello'
    puts params[:ratings].to_s
    puts Movie.all.where(:title => 'Aladdin')
    #byebug
    # Set empty params to the rating filter and sorting session 
    if (params[:filter] == nil and params[:ratings] == nil and params[:curr_sort] == nil and 
              (session[:filter] != nil or session[:ratings] != nil or session[:curr_sort] != nil))
      if (params[:filter] == nil and session[:filter] != nil)
        params[:filter] = session[:filter]
      end
      if (params[:curr_sort] == nil and session[:curr_sort] != nil)
        params[:curr_sort] = session[:curr_sort]
      end
      redirect_to movies_path(:filter => params[:filter], :curr_sort => params[:curr_sort], :ratings => params[:ratings]) 
    else

      if (params[:filter] != nil and params[:filter] != "[]")
        @filtered_ratings = params[:filter].scan(/[\w-]+/)
        session[:filter] = params[:filter]
      else
        @filtered_ratings = params[:ratings] ? params[:ratings].keys : []
        session[:filter] = params[:ratings] ? params[:ratings].keys.to_s : nil
      end
   
      session[:curr_sort] = params[:curr_sort]
      session[:ratings] = params[:ratings]

      #sorting by title
      if (params[:curr_sort] == "title") 
         # apply current ratings
        if (params[:ratings] or params[:filter])
          @movies = Movie.order_title.where(:rating => (@filtered_ratings==[] ? @all_ratings : @filtered_ratings))
          @title_header = 'hilite'
        else
          @movies=Movie.order_title
          @title_header = 'hilite'
        end
        
      ##sorting by release_date  
      elsif (params[:curr_sort] == "release_date")
       @release_date_header = 'hilite'
        # apply current ratings
        if (params[:ratings] or params[:filter]) 
          @movies = Movie.all.where(:rating => (@filtered_ratings==[] ? @all_ratings : @filtered_ratings), :order => "release_date")
           @release_date_header = 'hilite'
        else
          @movies = Movie.order_release
          @release_date_header = 'hilite'
        end
      elsif (params[:curr_sort] == nil)
      ##apply current ratings
        if (params[:ratings] or params[:filter])
          @movies = Movie.all.where(:rating => (@filtered_ratings==[] ? @all_ratings : @filtered_ratings))
        else
          @movies = Movie.all
        end
      end
      
    end
    

    
  end
  
  
  def sortTitle
    #@movies  = Movie.find params[]
    #@movies = Movie.all
    #@movies.sort{ |a,b| a.title.downcase <=> b.title.downcase }
    #@movies = Movie.all.order(:title)
    @all_ratings = ['G', 'PG', 'PG-13', 'NC-17', 'R']

    #id = params[:id] # retrieve movie ID from URI route
    #@movies = Movie.all.order(:title)
    @movies = Movie.order_title
    #redirect_to movies_path
  end
  
  
  def sortRelease
    #id = params[:id] # retrieve movie ID from URI route
    #@movies = Movie.all
    #@movies.sort{ |a,b| a.title.downcase <=> b.title.downcase }
    #@movies = Movie.all.order(:title)
    @all_ratings = ['G', 'PG', 'PG-13', 'NC-17', 'R']
    #@movies = Movie.all.order(:release_date)
    @movies = Movie.order_release
    #redirect_to movies_path
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

# replaces the 'create' method in controller:
def create
  @movie = Movie.new(movie_params)
  if @movie.save
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  else
    render 'new' # note, 'new' template can access @movie's field values!
  end
end
# replaces the 'update' method in controller:
def update
  @movie = Movie.find params[:id]
  if @movie.update_attributes(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  else
    render 'edit' # note, 'edit' template can access @movie's field values!
  end
end
# note, you will also have to update the 'new' method:
def new
  @movie = Movie.new
end

# def create
#    @movie = Movie.create!(movie_params)
#    flash[:notice] = "#{@movie.title} was successfully created."
#    redirect_to movies_path
##  end

  def edit
    @movie = Movie.find params[:id]
  end

#  def update
##    @movie = Movie.find params[:id]
#    @movie.update_attributes!(movie_params)
#    flash[:notice] = "#{@movie.title} was successfully updated."
#    redirect_to movie_path(@movie)
#  end

  def destroy
    
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
   #require 'ruby-debug'; debugger;
  private 

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end


end
