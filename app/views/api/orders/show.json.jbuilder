json.order do
    json.order_id @order.id
    json.username @order.user_name
    json.order_status @order.order_status
    json.order_items @order.order_items, :id, :product
end

json.success true