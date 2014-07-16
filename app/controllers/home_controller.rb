class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    #"We wish to display only the root folders which have no parents,
    # and only the files which are not under any folders.
    #@folders = current_user.folders.order("name desc")
    #@assets = current_user.assets.all
    @folders = current_user.folders.roots
    @assets = current_user.assets.where("folder_id is NULL")

  end

  def browse
    @current_folder = current_user.folders.find(params[:folder_id])
    if @current_folder
      @folders = @current_folder.children
      @assets = @current_folder.assets
      render :action => "index"
    else
      flash[:error] = "Don't be cheeky! Mind your own folders!"
      redirect_to root_url
    end
  end

  def destroy
    @asset = current_user.assets.find(params[:id])
    @parent_folder = @asset.folder #grabbing the parent folder before deleting the record
    @asset.destroy
    flash[:notice] = "Successfully deleted the file."

    #redirect to a relevant path depending on the parent folder
    if @parent_folder
      redirect_to browse_path(@parent_folder)
    else
      redirect_to root_url
    end
  end

end
