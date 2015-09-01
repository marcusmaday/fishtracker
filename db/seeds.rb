# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
FishType.create(:name => 'Walleye', :point_value => '2')
FishType.create(:name => 'Bonus Walleye', :point_value => '3')
FishType.create(:name => 'Bass', :point_value => '5')
FishType.create(:name => 'Northern', :point_value => '5')
FishType.create(:name => 'Perch', :point_value => '1')
FishType.create(:name => 'Rocky', :point_value => '-3')
FishType.create(:name => 'Crappie', :point_value => '3')

