  def find_item_by_name_in_collection(name, collection)
  i = 0 
  while i < collection.length do
    object_ele = collection[i]
    item_name = object_ele[:item]
    
    if name == item_name
     return object_ele
    end
    
   i+=1
  end
  nil 
end


def consolidate_cart(cart)
  new_array_result = []
  i = 0 
  while i < cart.length do
    objects_in_cart = cart[i]
    item_name_in_cart = objects_in_cart[:item]
    new_obj = find_item_by_name_in_collection(item_name_in_cart, new_array_result)
    
    if new_obj == nil 
      objects_in_cart[:count] = 1 
      new_array_result.push(objects_in_cart)
    else 
      new_obj[:count] += 1 
    end
    i+=1
  end 
 return new_array_result
end

def apply_coupons(cart, coupons)
  puts coupons
  i = 0 
  while i < coupons.length do
    coupon_obj = coupons[i]
    item_name_in_coupon = coupon_obj[:item]
    cart_item_obj = find_item_by_name_in_collection(item_name_in_coupon, cart)
    couponed_item_name = "#{item_name_in_coupon} W/COUPON"
    
    cart_item_with_coupon_obj = find_item_by_name_in_collection(couponed_item_name, cart)
    if cart_item_obj && cart_item_obj[:count] >= coupon_obj[:num]
      if cart_item_with_coupon_obj
        cart_item_with_coupon_obj[:count] += coupon_obj[:num]
        cart_item_obj -= coupon_obj[:num]
      else 
        cart_item_with_coupon_obj ={
          :item => couponed_item_name,
          :price => coupon_obj[:cost] / coupon_obj[:num],
          :count => coupon_obj[:num],
          :clearance => cart_item_obj[:clearance]
        }
        cart << cart_item_with_coupon_obj
        cart_item_obj[:count] -= coupon_obj[:num]
     end
    end
    i+= 1
  end 
cart 
end

def apply_clearance(cart)
  i = 0
  
  while i < cart.length do
    obj = cart[i]
    item_clearance = obj[:clearance]
    item_price = obj[:price]
    discount_price = item_price - (0.20 * item_price)

    if item_clearance == true
      obj[:price] = discount_price.round(2)
    end

    i+=1
  end
  return cart
end

def checkout(cart, coupons)
    consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  clearance_cart = apply_clearance(couponed_cart)
  total = 0
  i = 0
  while i < clearance_cart.length do
    item_in_cart = clearance_cart[i]
    price_of_item = item_in_cart[:price] * item_in_cart[:count]
    total += price_of_item
    i+=1
  end
  if total > 100
    total = total - (0.10 * total)
  end
return total
end
