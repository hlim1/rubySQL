require 'rubySQL'
require 'benchmark'

puts Benchmark.measure {
  # Create a RubySQL object
  rbsql = RubySQL.new
  # Connect to specified SQLite3 database.
  # Create if DB not exist or open the existing one.
  rbsql.connect("DB_test")
  # Check the current version of SQLite3
  rbsql.version

  # rbsql.create_table("COMPANY",__if_not_exist__="N").with([["__type__", "__column_name__", "__nullable__"],...,]).primary_key(__column_name__)
  rbsql.create_table("EMPLOYEES", "Y").with([
    "ID" => ["INT", "NO"], "FIRST_NAME" => ["TEXT", "NO"],
    "LAST_NAME" => ["TEXT", "NO"], "AGE" => ["INT", "NO"],
    "SEX" => ["TEXT", "YES"], "INCOME" => ["REAL", "YES"]
  ]).primary("ID")

  rbsql.list_tables

  # Close DB
  rbsql.close
}
