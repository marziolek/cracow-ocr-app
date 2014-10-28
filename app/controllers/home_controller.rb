class HomeController < ApplicationController
  def index
  end

  def upload
    #
    # Here goes file saving
    #

    DataFile.save_file(params[:picture])
    @data = params[:picture]

    @img = @data.read
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
