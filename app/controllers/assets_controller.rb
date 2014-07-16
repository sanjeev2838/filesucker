class AssetsController < ApplicationController
  before_action :set_asset, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!  #authenticate for users before any methods is called

  def index
    @assets = current_user.assets
  end

  def show
  end

  def new
    @asset = current_user.assets.build
    if params[:folder_id] #if we want to upload a file inside another folder
      @current_folder = current_user.folders.find(params[:folder_id])
      @asset.folder_id = @current_folder.id
    end
  end

  def create
    @asset = current_user.assets.build(asset_params)
    if @asset.save
      flash[:notice] = "Successfully uploaded the file."

      if @asset.folder #checking if we have a parent folder for this file
        redirect_to browse_path(@asset.folder)  #then we redirect to the parent folder
      else
        redirect_to root_url
      end
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @asset.update(asset_params)
        format.html { redirect_to @asset, notice: 'Asset was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @asset.destroy
    respond_to do |format|
      format.html { redirect_to assets_url }
      format.json { head :no_content }
    end
  end

  def get
    asset = current_user.assets.find_by_id(params[:id])
    asset ||= Asset.find(params[:id]) if current_user.has_share_access?(Asset.find_by_id(params[:id]).folder)

    if asset
      send_file asset.uploaded_file.path, :type => asset.content_type
    else
      flash[:notice] = "Don't be cheeky! Mind your own assets!"
      redirect_to assets_path
    end
  end

  private
    def set_asset
      @asset = current_user.assets.find(params[:id])
    end

    def asset_params
      params.require(:asset).permit(:uploaded_file,:folder_id)
    end
end
