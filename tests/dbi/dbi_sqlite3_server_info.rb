require "dbi"

begin
   # connect to the MySQL server
    dbh = DBI.connect("DBI:SQLite3:myTestDB", "temp", "tempPwd")
   # get server version string and display it
   row = dbh.select_one("SELECT SQLITE_VERSION()")
   puts "Server Version: " + row[0]
rescue DBI::DatabaseError => e
   puts "An error occurred"
   puts "Error code:    #{e.err}"
   puts "Error message: #{e.errstr}"
ensure
   # disconnect from server
   dbh.disconnect if dbh
end
