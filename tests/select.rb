require 'rubySQL'

# Create a RubySQL object
rbsql = RubySQL.new

# Connect to specified SQLite3 database.
# Create if DB not exist or open the existing one.
rbsql.connect("DB_test")

rows_b = rbsql.select_all("COMPANY_A")
puts "ROWS in Table COMPANY_A using select_all method:"
puts rows_b

rows_a = rbsql.select_from("COMPANY_A", "col").on_columns(["ID", "NAME", "AGE"])
puts "COLUMNS in Table COMPANY_A using select_from method:"
puts rows_a

# rbsql.select_from("COMPANY_A").with_condition("No Condition").on_columns(["*"])

rbsql.close
