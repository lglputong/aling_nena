require 'sinatra'
require './boot.rb'
require './money_calculator.rb'

# ROUTES FOR ADMIN SECTION

get '/admin' do
  @products = Item.all
  @products.each do |product|
  if product.quantity.to_i <= 0
    product.destroy!
    end
  end
  @products = Item.all
  erb :admin_index
end

get '/new_product' do
  @product = Item.new
  erb :product_form
end

post '/create_product' do
	@item = Item.new
	@item.name = params[:name]
	@item.price = params[:price]
	@item.quantity = params[:quantity]
	@item.sold = 0
	@item.save
 	redirect to '/admin'
end

get '/edit_product/:id' do
  @product = Item.find(params[:id])
  erb :product_form
end

post '/update_product/:id' do
  @product = Item.find(params[:id])
  @product.update_attributes!(
    name: params[:name],
    price: params[:price],
    quantity: params[:quantity],
  )
  redirect to '/admin'
end

get '/delete_product/:id' do
  @product = Item.find(params[:id])
  @product.destroy!
  redirect to '/admin'
end
# ROUTES FOR ADMIN SECTION

get '/' do
  @products = Item.all
  @products.each do |product|
  if product.quantity.to_i <= 0
    product.destroy!
    end
  end
  @products = Item.all
  #Source: Fritz Masiglat
  #Date: May 7, 2014
  #Name of Programmer: Fritz Masiglat
  @random_products = @products.sample(10)
  erb :banner
end

get '/products' do
  @products = Item.all
  @products.each do |product|
  if product.quantity.to_i <= 0
    products.destroy!
    end
  end
  @products = Item.all
  erb :products
end

get '/buy_product/:id' do
  @product = Item.find(params[:id])
  erb :buy_form
end

post '/buy_product/:id' do
  @product = Item.find(params[:id])
  @transact = MoneyCalculator.new(params[:ones], params[:fives], params[:tens], params[:twenties], params[:fifties], params[:hundreds], params[:five_hundreds], params[:thousands])
  @x = params[:quantity].to_i
  @y = @product.price.to_i
  @z = @x*@y
  @money_bills = @transact.change(@z)
  if @money_bills != {}
    @quantity_buy = params[:quantity].to_i
    @product.update_attributes!(
    quantity: @product.quantity.to_i - @quantity_buy,
    sold: @product.sold.to_i + @quantity_buy
    )
  end
  erb :checkout
end

get '/about' do
  erb :about
end

get '/pay' do
  erb :pay_form
end