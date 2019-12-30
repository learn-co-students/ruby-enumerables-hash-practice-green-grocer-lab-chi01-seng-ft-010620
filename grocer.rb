def consolidate_cart(cart)
  consolidated = {}
    cart.each do |contents|
      contents.each do |item, info|
      if consolidated.include?(item)
        consolidated[item][:count] += 1
      else
        consolidated[item] = {
          :price => info[:price],
          :clearance => info[:clearance],
          :count => 1
        }
      end
    end
  end
consolidated
end

def apply_coupons(cart, coupons)
  coupons.each do |discount|
  product = discount[:item]
      if cart.include?(product)
      if cart[product][:count] >= discount[:num]
      if cart["#{product} W/COUPON"]
        cart["#{product} W/COUPON"][:count] += discount[:num]
        else
        cart["#{product} W/COUPON"] = {
        :price => discount[:cost]/discount[:num],
        :count => discount[:num],
        :clearance => cart[product][:clearance]
      }
      end
      cart[product][:count] = cart[product][:count] -= discount[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, info|
  if info[:clearance] == true
    info[:price] = (info[:price]*0.8).round(2)
  else
    info[:price]
    end
  end
  cart
end

def checkout(cart, coupons)
  organized_cart = consolidate_cart(cart)
  cart_w_coupons = apply_coupons(organized_cart, coupons)
  cart_w_clearance = apply_clearance(cart_w_coupons)
  total = 0.0 
  
  cart_w_clearance.each do |item, info|
    total += cart_w_clearance[item][:price]*cart_w_clearance[item][:count]
    
  end
   if total > 100
    total = total*0.9
  else
    total
   end
end