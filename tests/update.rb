require 'rubySQL'
require 'benchmark'

# Create a RubySQL object
rbsql = RubySQL.new

# Connect to specified SQLite3 database.
# Create if DB not exist or open the existing one.
rbsql.connect("DB_test")

puts "Table in COMPANY_A before update:"
table = rbsql.select_all("COMPANY_A")
puts table

puts Benchmark.measure {
  rbsql.update("COMPANY_A").where(">=", "SALARY", 400000).set({"SALARY" => 650000.00})
}

puts "Table in COMPANY_A after update:"
puts rbsql.select_all("COMPANY_A")

rbsql.close
