class GigsController < ApplicationController

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
      format.json { render json: @gig }
    end
  end

  def new
    @gig = Gig.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @gig = Gig.find(params[:id])
  end

  def create
    @gig = Gig.create(params[:gig])
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

end
