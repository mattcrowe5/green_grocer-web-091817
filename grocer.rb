def consolidate_cart(cart)
  hash = {}
  cart.each do |item|
    item.each do |name, info|
      hash[name] = info unless hash[name]
      if !hash[name][:count]
        hash[name][:count] = 1
      else
        hash[name][:count] += 1
      end
    end
  end
  hash
end

def apply_coupons(cart, coupons)
  coupons.each do |item|
    food = item[:item]
    if cart[food] && cart[food][:count] >= item[:num]
      if cart["#{food} W/COUPON"]
        cart["#{food} W/COUPON"][:count] += 1
      else
        cart["#{food} W/COUPON"] = {:count => 1, :price => item[:cost]}
        cart["#{food} W/COUPON"][:clearance] = cart[food][:clearance]
      end
      cart[food][:count] -= item[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    if cart[item][:clearance] == true
      cart[item][:price] = (cart[item][:price]*0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  first_step = consolidate_cart(cart)
  second_step = apply_coupons(first_step, coupons)
  checkout_cart = apply_clearance(second_step)
  cart_cost = 0

  checkout_cart.each do |item, attributes|
    cart_cost = cart_cost + (attributes[:price] * attributes[:count])
  end

  if cart_cost >=100
    cart_cost = cart_cost * 0.9
  else return cart_cost
  end
  cart_cost
end
