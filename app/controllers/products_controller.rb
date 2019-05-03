class ProductsController < ApplicationController
  def index
    if params[:category]
      @title = "#{params[:category].upcase}"
      @products = Product.where(:category => params[:category])
      @products = @products.order(:name)
    else
      @title = "All Products"
      @products = Product.all.order(:name)
    end
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
      flash.now[:error] = "Failed to add product, check product data."
      render :new, status: :bad_request
    end
  end

  def show
    @orderitem = OrderItem.new
  end

  def edit
    unless product_merchant?
      redirect_to products_path, :alert => "Must be product merchant."
    end
  end

  private

  def product_params
    return params.require(:product, :name).permit(:category, :price, :stock, :user_id)
  end

  def product_merchant?
    @user = User.find_by(id: session[:user_id])
    @user == @product.user
  end
end
