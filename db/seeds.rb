# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Venuecategory.create(name: "Galleries", description: "Galleries with shows and permanent exhibits.")
Venuecategory.create(name: "Stores", description: "Physical locations such as boutiques, shops, salons, etc that are not galleries.")
Venuecategory.create(name: "Studios", description: "Studios work can be shown in or sold from.")
Venuecategory.create(name: "Booths", description: "Temporary venues such as white-tents or booths at conventions, fairs, or open air markets.")
Venuecategory.create(name: "Online", description: "Online venues such as Etsy or Ebay stores.")
Activitycategory.create(name: "Sale", status: "Sold", final:true, description: "Sale of a work.")
Activitycategory.create(name: "Commission", status: "Commissioned", final: false, description: "Commission of work started, sale to follow.")
Activitycategory.create(name: "Consignment", status: "Consigned", final: false, description: "Consignment of a work, hoping sale follows.")
Activitycategory.create(name: "Gift", status: "Gifted", final: true, description: "Gift a work.")
Activitycategory.create(name: "Donate", status: "Donated", final: true, description: "Donate a work.")
Activitycategory.create(name: "Recycle", status: "Recycled", final: true, description: "Recycle a work to create improved visions.")
