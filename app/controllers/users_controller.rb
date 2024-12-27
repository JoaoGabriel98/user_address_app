class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    users = User.where("name ILIKE ? OR cpf ILIKE ? OR date_of_birth = ?", 
                        "%#{params[:search]}%", 
                        "%#{params[:search]}%", 
                        params[:search]
                      )

    render json: users
  end
  
  def show
    @user = User.includes(:addresses).find(params[:id])

    render json: {
      id: @user.id,
      name: @user.name,
      email: @user.email,
      date_of_birth: @user.date_of_birth,
      cpf: @user.cpf,
      addresses_attributes: @user.addresses
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Usuário não encontrado.' }, status: :not_found
  end
  
  def create
    user = User.new(user_params)
    if user.save!
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :cpf, :date_of_birth, addresses_attributes: [:street, :city, :state, :zip])
  end
end
