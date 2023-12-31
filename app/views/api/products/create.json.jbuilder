json.product do
    json.id @product.id
    json.name @product.name
    json.description @product.description
    json.quantity @product.quantity
    json.price @product.price

    json.category @product.category

    unless (@product.product_image.filename.nil?)
        json.product_image rails_blob_url(@product.product_image)
    end
end

json.message @message
json.success true