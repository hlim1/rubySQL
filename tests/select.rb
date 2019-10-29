require 'rubySQL'

# Create a RubySQL object
rbsql = RubySQL.new

# Connect to specified SQLite3 database.
# Create if DB not exist or open the existing one.
rbsql.connect("DB_test")

rows = rbsql.select_from("COMPANY_A").on_columns(["*"])
puts "ROWS in Table COMPANY_A:"
puts rows
# rbsql.select_from("COMPANY_A").with_condition("No Condition").on_columns(["*"])

rbsql.close
