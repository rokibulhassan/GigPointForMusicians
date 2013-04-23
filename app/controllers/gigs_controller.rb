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
    @schedule_post = @gig.schedule_post
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
    @gig = Gig.new(params[:gig])
    @gig.attr_venue = params[:venue] if params[:venue].present?
    @gig.attr_schedule_post = params[:schedule_post] if params[:schedule_post].present?
    respond_to do |format|
      if @gig.save
        format.html { redirect_to @gig, notice: 'Gig was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @gig = Gig.find(params[:id])
    @gig.attr_venue = params[:venue] if params[:venue].present?
    @gig.attr_schedule_post = params[:schedule_post] if params[:schedule_post].present?
    begin
      @gig.update_attributes!(params[:gig])

      flash[:notice] = "Gig updates successfully"
      redirect_to edit_gig_path(@gig), notice: 'Gig was successfully updated.'
    rescue => e
      flash[:error] = e.message
      render :edit
    end
  end

  def destroy
    @gig = Gig.find(params[:id])
    @gig.destroy

    respond_to do |format|
      format.html { redirect_to gigs_url }
      format.json { head :no_content }
    end
  end

  def post_to_facebook
    @gig = Gig.find(params[:id])
    feed = {:message => 'Gig for fans.',
            :name => 'GigPoint',
            :link => "#{gig_path(@gig)}",
            :description => 'Gig post from gig for musicians.'}

    current_user.publish_one_wall(feed)

    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Gig was successfully posted.' }
    end
  end

end
