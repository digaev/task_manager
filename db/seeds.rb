# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.find_by_admin(true) || User.create(email: Faker::Internet.email,
                                        password: '123456',
                                        admin: true)

User.find_by_admin(false) || User.create(email: Faker::Internet.email,
                                         password: '123456')
