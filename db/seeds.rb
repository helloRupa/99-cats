# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ActiveRecord::Base.transaction do
  # Clear all tables and reset id value
  [Cat, CatRentalRequest, User].each do |c|
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{c.table_name} RESTART IDENTITY;")
  end
  
  # Make cats (birth_date, color, name, sex, description)
  Cat.create([
    { name: 'Frodo', color: 'ginger', birth_date: '2016/01/01', sex: 'M', description: 'From the Shire.' },
    { name: 'Bilbo', color: 'black', birth_date: '2010/08/07', sex: 'F', description: 'Old but sweet' },
    { name: 'Xanadu', color: 'blue', birth_date: '2015/07/25', sex: 'F', description: 'Sassy and cute' }
  ])

  # Add rental requests (cat_id, start_date, end_date, status)
  CatRentalRequest.create([
    { cat_id: 1, start_date: '2019/10/01', end_date: '2019/10/30', status: 'PENDING' },
    { cat_id: 1, start_date: '2019/09/20', end_date: '2019/10/15', status: 'PENDING' },
    { cat_id: 2, start_date: '2019/08/01', end_date: '2019/09/15', status: 'PENDING' }
  ])
end