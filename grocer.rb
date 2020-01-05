# The cart starts as an array of individual items. 
# Translate it into a hash that includes the counts for each item with the consolidate_cart method.

def consolidate_cart(cart)
  new_cart = {}
  cart.each do |hash| #hash is the whole array
    hash.each do |name, describe| #name: avocado, cheese. describe: price, clearance
      #if new_cart has name and count already, increase the count
      if new_cart[name]
        new_cart[name][:count] += 1
      #new_cart is empty so set name as key and describe as value
      else
        new_cart[name] = describe
        new_cart[name][:count] = 1 #set count = 1 cuz we set name and describe for 1 item
      end
    end
  end
  new_cart
end

# apply coupon to the cart,
# adds a new key, value pair to the cart hash called 'ITEM NAME W/COUPON'
# adds the coupon price to the property hash of couponed item
# adds the count number to the property hash of couponed item
# removes the number of discounted items from the original item's count
# remembers if the item was on clearance
# accounts for when there are more items than the coupon allows
# doesn't break if the coupon doesn't apply to any items

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon[:item]      #avocado, cheese,...
    coupon_item="#{item} W/COUPON"
     if cart.has_key?(item)                                 
      if cart[item][:count] >= coupon[:num]
        if !cart[coupon_item] 
          cart[coupon_item] ={count: coupon[:num], price: coupon[:cost]/ coupon[:num], clearance: cart[item][:clearance] }
      else
        cart[coupon_item][:count] += coupon[:num]
         end
         cart[item][:count] -= coupon[:num] 
        end
      end
   end
   cart
end

# apply clearance:
# takes 20% off price if the item is on clearance
# does not discount the price for items not on clearance

def apply_clearance(cart)
  cart.each do |product_name, stats|
     stats[:price]-= stats[:price] * 0.2 if stats[:clearance]
  end
cart
end

# checkout:
# Apply coupon discounts if the proper number of items are present.# calls on #apply_clearance after calling on #apply_coupons when there is only one item in the cart and no coupon
# Apply 20% discount if items are on clearance.
# If, after applying the coupon discounts and the clearance discounts, the cart's total is over $100, then apply a 10% discount.hi

def checkout(cart, coupons)
        #call the consolidate to get the count item first
  hash_cart = consolidate_cart(cart)
        #apply coupon to the new cart
  applied_coupons= apply_coupons(hash_cart, coupons)
       #apply clearance after discount from coupon
  applied_discount= apply_clearance(applied_coupons)

total = applied_discount.reduce(0){ |acc,(key, value)| acc+= value[:price]*value[:count]}
  total >= 100 ? total * 0.9 : total
  end


=begin
def consolidate_cart(cart)
  hash = {}
  cart.each do |item_hash|
    item_hash.each do |name, price_hash|
      if hash[name].nil?
        hash[name] = price_hash.merge({:count => 1})
      else
        hash[name][:count] += 1
      end
    end
  end
  hash
end

def apply_coupons(cart, coupons)
  hash = cart
  coupons.each do |coupon_hash|
    # add coupon to cart
    item = coupon_hash[:item]

    if !hash[item].nil? && hash[item][:count] >= coupon_hash[:num]
      temp = {"#{item} W/COUPON" => {
        :price => coupon_hash[:cost],
        :clearance => hash[item][:clearance],
        :count => 1
        }
      }
      
      if hash["#{item} W/COUPON"].nil?
        hash.merge!(temp)
      else
        hash["#{item} W/COUPON"][:count] += 1
        #hash["#{item} W/COUPON"][:price] += coupon_hash[:cost]
      end
      
      hash[item][:count] -= coupon_hash[:num]
    end
  end
  hash
end

def apply_clearance(cart)
  cart.each do |item, price_hash|
    if price_hash[:clearance] == true
      price_hash[:price] = (price_hash[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(items, coupons)
  cart = consolidate_cart(items)
  cart1 = apply_coupons(cart, coupons)
  cart2 = apply_clearance(cart1)
  
  total = 0
  
  cart2.each do |name, price_hash|
    total += price_hash[:price] * price_hash[:count]
  end
  
  total > 100 ? total * 0.9 : total
  
end

items =   [
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"KALE" => {:price => 3.00, :clearance => false}},
      {"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
      {"ALMONDS" => {:price => 9.00, :clearance => false}},
      {"TEMPEH" => {:price => 3.00, :clearance => true}},
      {"CHEESE" => {:price => 6.50, :clearance => false}},
      {"BEER" => {:price => 13.00, :clearance => false}},
      {"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
      {"BEETS" => {:price => 2.50, :clearance => false}},
      {"SOY MILK" => {:price => 4.50, :clearance => true}}
    ]

coupons = [
      {:item => "AVOCADO", :num => 2, :cost => 5.00},
      {:item => "AVOCADO", :num => 2, :cost => 5.00},
      {:item => "BEER", :num => 2, :cost => 20.00},
      {:item => "CHEESE", :num => 2, :cost => 15.00}
    ]

checkout(items, coupons)
=end