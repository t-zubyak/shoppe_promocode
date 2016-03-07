module Shoppe
  class PromocodesController < Shoppe::ApplicationController

    before_filter { @active_nav = :promocodes }

    def index
      @promocodes = Shoppe::Promocode.all.order(:title)
    end

    def new
      @promocode = Shoppe::Promocode.new
    end

    def create
      @promocode = Shoppe::Promocode.new(promocode_params)
      if @promocode.save
        redirect_to :promocodes, flash: {notice: 'Promo code has been created successfully'}
      else
        render 'new'
      end
    end

    def destroy
      @promocode = Shoppe::Promocode.find params[:id]
      @promocode.destroy
      redirect_to @promocode, :notice => "Promo code has been removed successfully"
    end

    def edit
      @promocode = Shoppe::Promocode.find(params[:id])
    end

    def update
      @promocode = Shoppe::Promocode.find(params[:id])
      if @promocode.update(promocode_params)
        redirect_to [:edit, @promocode], :flash => {:notice => "Promo code has been updated successfully"}
      else
        render :action => "edit"
      end
    end

    def promocode_params
      params[:promocode].permit(:title, :code, :discount_type, :discount_value, :usage_limit, :active_start_date, :active_end_date)
    end
  end
end
