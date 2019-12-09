require "dbi"

begin
  # connect to the MySQL server
  dbh = DBI.connect("DBI:SQLite3:dbiTestDB", "temp", "tempPwd")

  rows = dbh.execute("SELECT ID, NAME, AGE FROM COMPANY_A")
  rows.fetch do |row|
    printf "ID: #{row[0]}, NAME: #{row[1]}, AGE: #{row[2]}\n"
  end
  rows.finish
rescue DBI::DatabaseError => e
  puts "An error occurred"
  puts "Error code:    #{e.err}"
  puts "Error message: #{e.errstr}"
ensure
  # disconnect from server
  dbh.disconnect if dbh
end
