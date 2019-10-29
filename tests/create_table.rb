require 'rubySQL'

def main
  # Create a RubySQL object
  rbsql = RubySQL.new
  # Connect to specified SQLite3 database.
  # Create if DB not exist or open the existing one.
  rbsql.connect("DB_test")
  # Check the current version of SQLite3
  rbsql.version

  # rbsql.create_table("COMPANY",__if_not_exist__="N").with([["__type__", "__column_name__", "__nullable__"],...,]).primary_key(__column_name__)
  rbsql.create_table("COMPANY_A", "Y").with_columns([
    "ID" => ["INT", "NO"], "NAME" => ["TEXT", "NO"], 
    "AGE" => ["INT", "NO"], "ADDRESS" => ["TEXT", "YES"], 
    "SALARY" => ["REAL", "YES"]
  ]).primary("ID")

  rbsql.create_table("COMPANY_B", "Y").with_columns([
    "ID" => ["INT", "NO"], "NAME" => ["TEXT", "NO"], 
    "AGE" => ["INT", "NO"], "ADDRESS" => ["TEXT", "YES"], 
    "SALARY" => ["REAL", "YES"]
  ]).primary("ID")

  # Print table schema
  rbsql.schema_of("COMPANY_A")
  rbsql.schema_of("COMPANY_B")

  rbsql.list_tables
  # Close DB
  rbsql.close
end

main
