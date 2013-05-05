class GigsController < ApplicationController

  def index
    @gigs = Gig.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @gig = Gig.find(params[:id])
    @venue = @gig.venue
    respond_to do |format|
      format.html
      format.json { render json: @gig }
    end
  end

  def new
    @gig = Gig.new
    @venue = Venue.new
    @schedule_post = SchedulePost.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    @gig = Gig.find(params[:id])
    @venue = @gig.venue
    @schedule_post = @gig.schedule_post
  end

  def create
   begin
      @gig = Gig.new(params[:gig])
      @gig.attr_venue = params[:venue] if params[:venue].present?
      @gig.attr_schedule_post = params[:schedule_post] if params[:schedule_post].present?
      respond_to do |format|
        if @gig.save
          format.html { redirect_to current_user, notice: 'Gig was successfully created.' }
        else
          format.html { render action: "new" }
        end
      end
    rescue Exception => ex
      @venue = Venue.new
      @schedule_post = SchedulePost.new
      flash[:error] = ex.message
      render :new
    end

  end

  def update
    begin
      @gig = Gig.find(params[:id])
      @gig.attr_venue = params[:venue] if params[:venue].present?
      @gig.attr_schedule_post = params[:schedule_post] if params[:schedule_post].present?

      @gig.update_attributes!(params[:gig])
      redirect_to edit_gig_path(@gig), notice: 'Gig was successfully updated.'
    rescue Exception => ex
      @venue = @gig.venue
      @schedule_post = @gig.schedule_post
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
