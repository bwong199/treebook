class AlbumsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new, :edit, :update, :destroy]

  before_filter :find_user
  before_action :find_album, only: [:edit, :update, :destroy, :show]
  before_action :ensure_proper_user, only: [:edit, :new, :create, :update, :destroy]

  before_action :add_breadcrumbs
  # GET /albums
  # GET /albums.json
  def index
    @albums = @user.albums.all

  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    redirect_to album_pictures_path(params[:id])
  end

  # GET /albums/new
  def new
    @album = current_user.albums.new
  end

  # GET /albums/1/edit
  def edit
    add_breadcrumb "Editing Album"
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = current_user.albums.new(album_params)

    respond_to do |format|
      if @album.save
        current_user.create_activity @album, 'created'
        format.html { redirect_to @album, notice: 'Album was successfully created.' }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1
  # PATCH/PUT /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        current_user.create_activity @album, 'updated'
        format.html { redirect_to album_pictures_path(@album), notice: 'Album was successfully updated.' }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album.destroy
    current_user.create_activity @album, 'deleted'
    respond_to do |format|
      format.html { redirect_to albums_url , notice: 'Album was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def url_options
    {profile_name: params[:profile_name] }.merge(super)
  end 


  private
    def add_breadcrumbs
      add_breadcrumb @user, profile_path(@user)
      add_breadcrumb "Albums", albums_path
    end

  def ensure_proper_user
    if current_user != @user
      flash[:error] = "You don't have permission to do that."
      redirect_to albums_path
    end
  end

    # Use callbacks to share common setup or constraints between actions.

    # Never trust parameters from the scary internet, only allow the white list through.
    def album_params
      params.require(:album).permit(:user_id, :title)
    end


    def find_user
      @user = User.find_by_profile_name(params[:profile_name])
    end

    def find_album
      @album = current_user.albums.find(params[:id])
    end
end
