require 'rubySQL'

# Create a RubySQL object
rbsql = RubySQL.new
# Connect to specified SQLite3 database.
# Create if DB not exist or open the existing one.
rbsql.connect("DB_test")

rbsql.drop_table("COMPANY_A")

# Close DB
rbsql.close
