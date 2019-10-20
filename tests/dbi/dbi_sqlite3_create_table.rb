require "dbi"
require "benchmark"

puts Benchmark.measure {
  begin
     # connect to the MySQL server
      dbh = DBI.connect("DBI:SQLite3:myTestDB", "temp", "tempPwd")
     # get server version string and display it
     version = dbh.select_one("SELECT SQLITE_VERSION()")
     puts version[0]
     # create table
     dbh.do("CREATE TABLE IF NOT EXISTS EMPLOYEES (
     ID INT PRIMARY KEY NOT NULL,
     FIRST_NAME  TEXT NOT NULL,
     LAST_NAME  TEXT,
     AGE INT,  
     SEX TEXT,
     INCOME REAL )" )
     sth = dbh.execute("select * from sqlite_master where type='table';")
     while row = sth.fetch do
       puts row[1], row[4]
     end
     sth.finish
  rescue DBI::DatabaseError => e
     puts "An error occurred"
     puts "Error code:    #{e.err}"
     puts "Error message: #{e.errstr}"
  ensure
     # disconnect from server
     dbh.disconnect if dbh
  end
}
