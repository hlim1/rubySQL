require 'rubySQL'

# Create a RubySQL object
rbsql = RubySQL.new

# Connect to specified SQLite3 database.
# Create if DB not exist or open the existing one.
rbsql.connect("DB_test")

# Insert values into table COMPANY_A
rbsql.insert([1, "Terrence Lim", 29, "Tucson, Az", {"SALARY":100000.00}]).into("COMPANY_A")
# Below code should be an error about table not exist
# rbsql.insert([1, "Terrence Lim", 29, "Tucson, Az", 100000.00]).into("COMPANY_C")

# Close DB
rbsql.close
