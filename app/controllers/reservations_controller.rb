class ReservationsController < ApplicationController
  before_action :set_location
  before_action :set_space
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]

  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = @space.reservations.all
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    @reservation = @space.reservations.build(user: authed_user)
    if authed_user
      @reservation.name = authed_user.full_name
      @reservation.email = authed_user.email
      @reservation.phone = authed_user.phone
      @reservation.zipcode = authed_user.zipcode
      @reservation.save_details_for_next_time = true
    end
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @reservation = @space.reservations.build(reservation_params.merge(user: authed_user))

    respond_to do |format|
      if @reservation.save
        format.html { redirect_to [@reservation.space.location, @reservation.space, @reservation], notice: 'Reservation was successfully created.' }
        format.json { render :show, status: :created, location: [@reservation.space.location, @reservation.space, @reservation] }
      else
        format.html { render :new }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to [@reservation.space.location, @reservation.space, @reservation], notice: 'Reservation was successfully updated.' }
        format.json { render :show, status: :ok, location: [@reservation.space.location, @reservation.space, @reservation] }
      else
        format.html { render :edit }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to location_space_reservations_url(@reservation.space.location, @reservation.space), notice: 'Reservation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find_by_permalink(params[:location_id])
      raise ActiveRecord::RecordNotFound unless @location
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_space
      @space = @location.spaces.find_by_permalink(params[:space_id])
      raise ActiveRecord::RecordNotFound unless @space
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = @space.reservations.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:space_id, :name, :email, :phone, :zipcode, :starts_at, :ends_at, :chargeid, :save_details_for_next_time)
    end
end