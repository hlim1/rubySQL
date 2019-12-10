require "dbi"
require "benchmark"

puts Benchmark.measure {
     # connect to the MySQL server
      dbh = DBI.connect("DBI:SQLite3:myTestDB", "temp", "tempPwd")
     # create table
     dbh.do("CREATE TABLE IF NOT EXISTS COMPANY_A (
     ID INT PRIMARY KEY NOT NULL,
     NAME TEXT NOT NULL,
     AGE INT NOT NULL,  
     ADDRESS TEXT,
     SALARY REAL );" )

     dbh.do("CREATE TABLE IF NOT EXISTS COMPANY_A (
     ID INT PRIMARY KEY NOT NULL,
     NAME TEXT NOT NULL,
     AGE INT NOT NULL,  
     ADDRESS TEXT,
     SALARY REAL );" )
}
