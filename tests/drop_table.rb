require 'rubySQL'

def main
  # Create a RubySQL object
  rbsql = RubySQL.new
  # Connect to specified SQLite3 database.
  # Create if DB not exist or open the existing one.
  rbsql.connect("DB_test")
  # Check the current version of SQLite3
  rbsql.version

  puts "List of tables in DB_test"  
  rbsql.list_tables

  puts "List of tables in DB_test after dropping COMPANY_B"
  rbsql.drop_table("COMPANY_B")

  rbsql.list_tables
  # Close DB
  rbsql.close
end

main
