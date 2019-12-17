def consolidate_cart(cart)
  result = {}
  cart.each do | item_hash |
    item_name = item_hash.keys.shift
    item_total = cart.count { |cart_item| item_name == cart_item.keys.shift }
    item_hash[item_name][:count] = item_total
    result[item_hash.keys.shift] = item_hash[item_hash.keys.shift]
  end
  result
end

def apply_coupons(cart, coupons)
  duplicate_check = []
  coupons.each do | coupon_hash |
    coupon_item = coupon_hash[:item]
    if duplicate_check.include?(coupon_hash) && cart[coupon_item][:count] >= coupon_hash[:num]
      cart[coupon_item][:count] += coupon_hash[:num]
      coupon_hash[:num] = coupon_hash[:num] + coupon_hash[:num]
      coupon_hash[:cost] = coupon_hash[:cost] + coupon_hash[:cost]
    else
    duplicate_check.push(coupon_hash)
  end
    if cart.keys.include?(coupon_item) == true && cart[coupon_item][:count] >= coupon_hash[:num]
      cart["#{coupon_item} W/COUPON"] = {
      :price => coupon_hash[:cost] / coupon_hash[:num],
      :clearance => cart[coupon_item][:clearance],
      :count => coupon_hash[:num]}
      cart[coupon_item][:count] = cart[coupon_item][:count] - coupon_hash[:num]
    end
  end
cart
end

def apply_clearance(cart)
  cart.keys.each do | key |
    if cart[key][:clearance] == true
      cart[key][:price] = (cart[key][:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  grand_total = 0
  consolidated_cart = consolidate_cart(cart)
  coupons_applied = apply_coupons(consolidated_cart, coupons)
  clearance_applied = apply_clearance(coupons_applied)
  clearance_applied.keys.each do | item_name |
    item_total = clearance_applied[item_name][:price] * clearance_applied[item_name][:count]
    grand_total += item_total
  end
  if grand_total > 100
    final_total = grand_total * 0.9
  else
    final_total = grand_total
  end
  final_total
end