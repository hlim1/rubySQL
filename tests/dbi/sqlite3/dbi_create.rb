require "dbi"

begin
   # connect to the MySQL server
   dbh = DBI.connect("DBI:SQLite3:dbiTestDB", "temp", "tempPwd")

   # create two tables
   dbh.do("CREATE TABLE IF NOT EXISTS COMPANY_A (
   ID INT PRIMARY KEY NOT NULL,
   NAME TEXT NOT NULL,
   AGE INT NOT NULL,  
   ADDRESS TEXT,
   SALARY REAL )" )

   dbh.do("CREATE TABLE IF NOT EXISTS COMPANY_B (
   ID INT PRIMARY KEY NOT NULL,
   NAME TEXT NOT NULL,
   AGE INT NOT NULL,  
   ADDRESS TEXT,
   SALARY REAL )" )
rescue DBI::DatabaseError => e
   puts "An error occurred"
   puts "Error code:    #{e.err}"
   puts "Error message: #{e.errstr}"
ensure
   # disconnect from server
   dbh.disconnect if dbh
end
