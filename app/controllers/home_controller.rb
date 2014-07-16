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

  def share
    #first, we need to separate the emails with the comma
    email_addresses = params[:email_addresses].split(",")

    email_addresses.each do |email_address|
      #save the details in the ShareFolder table
      @shared_folder = current_user.shared_folders.new
      @shared_folder.folder_id = params[:folder_id]
      @shared_folder.shared_email = email_address

      #getting the shared user id right the owner the email has already signed up with ShareBox
      #if not, the field "shared_user_id" will be left nil for now.
      shared_user = User.find_by_email(email_address)
      @shared_folder.shared_user_id = shared_user.id if shared_user

      @shared_folder.message = params[:message]
      @shared_folder.save

      #now we need to send email to the Shared User
      UserMailer.invitation_to_share(@shared_folder).deliver
    end

    #since this action is mainly for ajax (javascript request), we'll respond with js file back (refer to share.js.erb)
    respond_to do |format|
      format.js {
      }
    end
  end

end
