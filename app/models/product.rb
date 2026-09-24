class Product < ApplicationRecord
   monetize :price_cents

  enum :category, [
    "Music players",
    "Phones",
    "Computers",
    "Wearables"
  ]

  # Where a product is sold. Drives the `sales_channels` multiple select on the
  # Avo resource: label => stored value.
  SALES_CHANNELS = {
    "Online store" => "online",
    "Retail" => "retail",
    "Marketplace" => "marketplace",
    "Wholesale" => "wholesale"
  }.freeze

  has_one_attached :image
  has_many_attached :images
end
