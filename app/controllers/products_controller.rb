class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]
  before_action :product_merchant?, only: [:edit, :update, :destroy]
  before_action :require_login, only: [:new, :create, :edit, :update]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user_id = session[:user_id]

    if @product.save
      flash[:success] = "Product added!"
      redirect_to product_path(@product.id)
    else
      @product.errors.messages.each do |field, message|
        flash.now[field] = message
      end

      render :new, status: :bad_request
    end
  end

  def show
    if @product.nil?
      flash[:error] = "Unknown product"
      redirect_to products_path
    end
  end

  def edit
    unless product_merchant?
      redirect_to products_path, :alert => "Must be product merchant."
    end
  end

  def update
    if @product.update(product_params)
      flash[:success] = "Update successful!"
      redirect_to product_path(@product.id)
    else
      flash[:error] = "Update failed, please check product data."
      render :edit, status: :bad_request
    end
  end

  def destroy
    if product_merchant?
      if @product.destroy
        flash[:status] = :success
        flash[:success] = "Succesfully deleted!"
        redirect_to products_path
      end
    else
      redirect_to products_path, :alert => "Must be product merchant."
    end
  end

  private

  def product_params
    return params.require(:product).permit(:name, :price, :stock, :user_id, category_ids: [], orderitem_ids: [])
  end

  def product_merchant?
    @user = User.find_by(id: session[:user_id])
    @user == @product.user
  end

  def find_product
    @product = Product.find_by(id: params[:id])
  end
end
