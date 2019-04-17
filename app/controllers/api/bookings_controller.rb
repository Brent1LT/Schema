class Api::BookingsController < ApplicationController

  def index
    @bookings = Booking.all
  end 

  def create
    # will probably need to fix once react/ajax is sending down info
    debugger
    start_dates = booking_params[:start_date].split(',')
    end_dates = booking_params[:end_date].split(',')
    start_dates = start_dates.map {|el| el.to_i}
    end_dates = end_dates.map {|el| el.to_i}
    start_date = DateTime.new(*start_dates)
    end_date = DateTime.new(*end_dates)
    @booking = Booking.new(start_time: start_date, end_time: end_date)
    if(!@booking.is_valid?(params[:listing_id]))
      render json: "Overlap in booking schedule"
    else
      @booking.user_id = 1
      @booking.listing_id = params[:listing_id].to_i
      if(@booking.save)
        # might need to change in jbuilder to have user id on outside of booking state
        render :create
      else 
        render json: @booking.errors.full_messages, status: 422
      end 
    end 
  end 

  def destroy
    @booking = Booking.find_by(id: params[:id])
    if @booking.destroy
      render json: {bookingId: @booking.id}
    else 
      render json: @booking.errors.full_messages, status: 422
    end 
  end 

  private

  def booking_params
    # params[:booking][:start_date] ||= []
    # params[:booking][:end_date] ||= []

    params.require(:booking).permit(:start_date, :end_date)
  end 
end