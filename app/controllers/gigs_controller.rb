class GigsController < ApplicationController
  #load_and_authorize_resource
  #before_filter :authenticate_user!, :only => [:new, :create, :edit, :update]

  def index
    @gigs = Gig.all
    respond_to do |format|
      format.html
    end
  end

  def show
    @gig = Gig.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @gig = Gig.new
    @gig.build_venue
    @gig.build_schedule_post

    respond_to do |format|
      format.html
    end
  end

  def edit
    @gig = Gig.find(params[:id])
  end

  def create
    begin
      @gig = Gig.new(params[:gig])

      @gig.save!
      redirect_to current_user, notice: 'Gig was successfully created.'
    rescue Exception => ex
      flash[:error] = ex.message
      render :new
    end

  end

  def update
    begin
      @gig = Gig.find(params[:id])

      @gig.update_attributes!(params[:gig])
      redirect_to edit_gig_path(@gig), notice: 'Gig was successfully updated.'
    rescue Exception => ex
      flash[:error] = ex.message
      render :edit
    end
  end

  def destroy
    @gig = Gig.find(params[:id])
    @gig.destroy

    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Gig was successfully Deleted.' }
    end
  end

  def post_to_facebook
    @gig = Gig.find(params[:id])
    message = 'Gig for fans.'
    feed = {:name => @gig.name, :link => "#{gig_path(@gig)}", :description => 'Gig post from gig for musicians.'}
    status = "Tweeting as a gig user!"

    current_user.publish_one_wall(message, feed)
    current_user.update_twitter_status(@gig.id, status)

    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Gig was successfully posted.' }
    end
  end

end
