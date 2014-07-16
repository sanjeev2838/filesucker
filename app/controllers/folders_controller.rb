class FoldersController < ApplicationController
  before_action :set_folder, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  def index
    @folders = current_user.folders.all
  end

  def show
  end

  def new
    @folder = current_user.folders.new
  end

  def edit
  end

  def create
    @folder = current_user.folders.new(folder_params)

    respond_to do |format|
      if @folder.save
        format.html { redirect_to @folder, notice: 'Folder was successfully created.' }
        format.json { render action: 'show', status: :created, location: @folder }
      else
        format.html { render action: 'new' }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @folder.update(folder_params)
        format.html { redirect_to @folder, notice: 'Folder was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @folder.destroy
    respond_to do |format|
      format.html { redirect_to folders_url }
      format.json { head :no_content }
    end
  end

  private
    def set_folder
      @folder = current_user.folders.find(params[:id])
    end

    def folder_params
      params.require(:folder).permit(:name, :parent_id, :user_id)
    end
end
