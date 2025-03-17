class TodolistsController < ApplicationController
  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    @list.score = Language.get_data(list_params[:body])
    tags = Vision.get_image_data(list_params[:image])
    if @list.save
      tags.each do |tag|
        @list.tags.create(name: tag)
      end
      redirect_to todolist_path(@list.id)
    else
      render :new
    end
  end

  def index
    @lists = List.all
  end

  def show
    @list = List.find(params[:id])
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    list = List.find(params[:id])
    list.update(list_params)
    redirect_to todolist_path(list.id)
  end

  def destroy
    # puts "あいうえお"
    # list = List.find(params[:id])
    # list.destroy
    # redirect_to todolists_path
    puts "*** DESTROY ACTION CALLED ***"
    puts "Params: #{params.inspect}"
    begin
      list = List.find(params[:id])
      puts "Found list: #{list.inspect}"
      list.destroy
      puts "List destroyed"
      redirect_to todolists_path
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace.join("\n")
      redirect_to todolists_path, alert: "削除に失敗しました: #{e.message}"
    end
  end

  private

  def list_params
    params.require(:list).permit(:title, :body, :image)
  end

end
