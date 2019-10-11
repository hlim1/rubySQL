require 'rubySQL'

def main
  # Create a RubySQL object
  rbsql = RubySQL.new
  # Connect to specified SQLite3 database.
  # Create if DB not exist or open the existing one.
  rbsql.connect("DB_test.db")
  # Check the current version of SQLite3
  rbsql.version

  # rbsql.create_table("COMPANY").with([["__type__", "__column_name__", "__nullable__"],...,]).primary_key(__column_name__)
  rbsql.create_table("COMPANY").with(["ID" => ["INT", "NO"], "NAME" => ["TEXT", "NO"], "AGE" => ["INT", "NO"], "ADDRESS" => ["TEXT", "YES"], "SALARY" => ["REAL", "YES"]]).primary("ID")

  # Close DB
  rbsql.close
end

main
