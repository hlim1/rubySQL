require 'rubySQL'

# Create a RubySQL object
rbsql = RubySQL.new

# Connect to specified SQLite3 database.
# Create if DB not exist or open the existing one.
rbsql.connect("DB_test")

data = rbsql.select_all("COMPANY_A")
puts "Data returned by rowss:"
puts data

data = rbsql.select_all("COMPANY_A", "col")
puts "Data returned by columns:"
puts data


# rbsql.select_from("COMPANY_A").with_condition("No Condition").on_columns(["*"])

rbsql.close
