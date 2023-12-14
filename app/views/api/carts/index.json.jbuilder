json.cart do
    json.cart_items @cart.cart_items, :id, :product
end

json.success true