# User stuff homie
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_only, only: [:index]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def settings
    @user = current_user
  end

  def update_settings
    @user = current_user
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to settings_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @settings }
      else
        format.html { render :settings }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        log_in @user
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def authorize_request_token
    request_token = YahooToken.request_token
    session[:request_token] = request_token
    current_user.update_columns(yahoo_secret: request_token.secret)
    redirect_to request_token.authorize_url
  end

  def token_callback
    token = OAuth::RequestToken.new(YahooToken.oauth_consumer, params[:oauth_token], current_user.yahoo_secret)
    access_token = token.get_access_token(oauth_verifier: params[:oauth_verifier])

    token_data = {
      token: access_token.params['oauth_token'],
      token_secret: access_token.params['oauth_token_secret'],
      session_handle: access_token.params['oauth_session_handle'],
      updated_at: DateTime.current
    }

    current_user.update_columns(yahoo_token: token_data.to_json)

    redirect_to settings_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user) || (current_user && current_user.admin)
  end

  def admin_only
    redirect_to(root_url) unless current_user && current_user.admin
  end
end
