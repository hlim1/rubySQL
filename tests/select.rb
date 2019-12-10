require 'rubySQL'

# Create a RubySQL object
rbsql = RubySQL.new

# Connect to specified SQLite3 database.
# Create if DB not exist or open the existing one.
rbsql.connect("DB_test")

puts "ROWS in Table COMPANY_A using select_all method:"
rows_a = rbsql.select_all("COMPANY_A")
puts rows_a

puts "COLUMNS in Table COMPANY_A using select_from method:"
rows_b = rbsql.select_from("COMPANY_A", "col").on_columns(["ID", "NAME", "AGE", "SALARY"])
puts rows_b

puts "SELECT with condition in Table COMPANY_A using select_from method:"
rows_b = rbsql.select_from("COMPANY_A", "row").where(">=", "SALARY", 650000).on_columns(["ID", "NAME", "AGE", "SALARY"])
puts rows_b


# rbsql.select_from("COMPANY_A").with_condition("No Condition").on_columns(["*"])

rbsql.close
