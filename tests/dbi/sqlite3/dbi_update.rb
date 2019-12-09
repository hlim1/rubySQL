require "dbi"
require "benchmark"

begin
  dbh = DBI.connect("DBI:SQLite3:dbiTestDB", "temp", "tempPwd")
  puts Benchmark.measure {
    dbh.do("UPDATE COMPANY_A SET SALARY = 650000 WHERE SALARY >= 400000")
  }
rescue DBI::DatabaseError => e
   puts "An error occurred"
   puts "Error code:    #{e.err}"
   puts "Error message: #{e.errstr}"
ensure
   # disconnect from server
   dbh.disconnect if dbh
end
