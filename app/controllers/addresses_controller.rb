class AddressesController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_user
  before_action :set_address, only: [:destroy]

  def destroy
    if @address.destroy
      render json: { message: true }, status: :ok
    else
      render json: @address.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_address
    @address = @user.addresses.find(params[:id])
  end
end
