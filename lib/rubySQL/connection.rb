require 'sqlite3'

class RubySQL::Connection
  ##
  # Makes a connection to localhost sqlite.
  #
  # If the user hasn't specified the database name, connect method
  # will create and connect to the default database "defaultDB".
  # Else, it wil create and connect to the database that user
  # has specified.
  # It then will return the database handler object.

  # Initialize the instance variable @db_name with the user specified DB name.
  # Params:
  # - db_name (str): Dabase name 
  def initialize(db_name)
    @db_name = db_name
  end

  def connect
    begin
      if not @db_name.empty?
        db = SQLite3::Database.new @db_name
        printf "Connected to DB: %s\n", @db_name
      else
        db = SQLite3::Database.new "defaultDB"
        printf "Connected to default DB: defaultDB"
      end
      return db
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
    end
  end
end
