class HomeController < ApplicationController
  def index
    @home = Home.new
  end

  def upload
    #
    # Here goes file saving
    #

    #name = params[:upload][:file].original_filename
    @home = Home.new
    @home.picture = params[:picture]
    @home.save!


    # do something to the file, for example:
    #    file.read(2) #=> "ab"
    #name = params['datafile']
    #directory = "images/upload"
    #path = File.join(directory, name)
    #File.open(path, "wb") do |f|
    #  f.write(params[:picture].read)
    #end
    #File.write(path, 'asd')
    #flash[:notice] = "File uploaded!"
    #
    # It should run smoothly
    #
  end
end
