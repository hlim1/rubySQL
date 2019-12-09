require "dbi"

begin
  dbh = DBI.connect("DBI:SQLite3:dbiTestDB", "temp", "tempPwd")
  dbh.do("INSERT INTO COMPANY_A (ID,NAME,AGE,ADDRESS,SALARY) VALUES (1,'ABC',29,'Tucson, Az',100000.0);")
  dbh.do("INSERT INTO COMPANY_A (ID,NAME,AGE,ADDRESS,SALARY) VALUES (2,'DEF',30,'Los Angeles, CA',200000.0);")
  dbh.do("INSERT INTO COMPANY_A (ID,NAME,AGE,ADDRESS,SALARY) VALUES (3,'GHI',40,'San Francisco',300000.0);")
  dbh.do("INSERT INTO COMPANY_A (ID,NAME,AGE,SALARY) VALUES (4,'JKL',50,400000.0);")
rescue DBI::DatabaseError => e
   puts "An error occurred"
   puts "Error code:    #{e.err}"
   puts "Error message: #{e.errstr}"
ensure
   # disconnect from server
   dbh.disconnect if dbh
end
