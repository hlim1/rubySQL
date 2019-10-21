require 'sqlite3'

def connect(db_name)
    puts db_name
    if not db_name.empty?
      db = SQLite3::Database.new db_name
    else
      db = SQLite3::Database.new "testdb"
    end

    return db
end

begin
    puts "Enter db name:"
    db_name = gets.chomp

    db = connect(db_name)

    print "Server Version: "
    puts db.get_first_value 'SELECT SQLITE_VERSION()'
    db.execute("CREATE TABLE IF  NOT EXISTS COMPANY_A (ID INT PRIMARY KEY NOT NULL,NAME TEXT NOT NULL,AGE INT NOT NULL,ADDRESS TEXT,SALARY REAL)")
    db.execute("INSERT INTO COMPANY_A VALUES (1, 'MY NAME', 30, 'MY ADRESS', 3000)")
    db.execute("INSERT INTO COMPANY_A VALUES (2, 'MY NAME', 30, 'MY ADRESS', 3000)")
    db.execute("INSERT INTO COMPANY_A VALUES (3, 'MY NAME', 30, 'MY ADRESS', 3000)")
    row = db.execute("SELECT * FROM COMPANY_A")

    row.each {|t| puts t["ID"]}

rescue SQLite3::Exception => e 
    
    puts "Exception occurred"
    puts e
    
ensure
    db.close if db
end
