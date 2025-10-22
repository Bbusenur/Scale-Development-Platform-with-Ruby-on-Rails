class Api::V1::UsersController < ApplicationController


  # Tüm kullanıcıları listeler
  def index
    @users = User.all 
    render json: @users.as_json(except: [:hashed_password, :salt])
  end
  
   # Kullanıcı Oluşturma
  def create
    # JSON'dan gelen user_params'a credit_balance'ı ekleriz (SDP Kuralı: Yeni kullanıcı 50 kredi ile başlar)
    @user = User.new(user_params.merge(credit_balance: 50)) 

    if @user.save
      render json: @user.as_json(except: [:hashed_password, :salt]), status: :created 
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

   # Profil Bilgilerini Okuma
  def show
    @user = User.find(params[:id])
    render json: @user.as_json(except: [:hashed_password, :salt])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Kullanıcı bulunamadı." }, status: :not_found
  end

  # Kullanıcı Bilgilerini Güncelleme
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: @user.as_json(except: [:hashed_password, :salt]), status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Güncellenecek kullanıcı bulunamadı." }, status: :not_found
  end
  
  # DELETE 
  def destroy
    @user = User.find(params[:id])
    @user.destroy!
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Silinecek kullanıcı bulunamadı." }, status: :not_found
  end

  private

  def user_params
    params.require(:user).permit(
      :forename, 
      :surname, 
      :language, 
      :role, 
      :hashed_password
    )
  end
end