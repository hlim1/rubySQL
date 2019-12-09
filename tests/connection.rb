require 'rubySQL'

# Create a RubySQL object
rbsql = RubySQL.new
# Connect to specified SQLite3 database.
# Create if DB not exist or open the existing one.
rbsql.connect("DB_test.db")
# Check the current version of SQLite3
rbsql.version
rbsql.list_tables
# Close DB
rbsql.close
