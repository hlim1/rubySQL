require 'rubySQL'

# Create a RubySQL object
rbsql = RubySQL.new

# Connect to specified SQLite3 database.
# Create if DB not exist or open the existing one.
rbsql.connect("DB_test")

# Insert values into table COMPANY_A
  rbsql.insert([1, "ABC", 29, "Tucson, Az", {"SALARY":100000.00}]).into("COMPANY_A")
  rbsql.insert([2, "DEF", 30, "Los Angeles, CA", {"SALARY":200000.00}]).into("COMPANY_A")
  rbsql.insert([3, "GHI", 40, "San Francisco", {"SALARY":300000.00}]).into("COMPANY_A")
  rbsql.insert([4, "JKL", 50, {"SALARY":400000.00}]).into("COMPANY_A")

#rbsql.insert([5, "MNO", 40, {"SALARY":400000.00}]).into("COMPANY_A")

# Below code is an error about table not exist
# rbsql.insert([1, "Terrence Lim", 29, "Tucson, Az", 100000.00]).into("COMPANY_C")
# Below code is an error about invalid type for age (integer) input string
# rbsql.insert([4, "GHI", "40", "San Francisco", {"SALARY":300000.00}]).into("COMPANY_A")

# Close DB
rbsql.close
