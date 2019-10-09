require 'sqlite3'
require_relative 'assert'

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
  # - db_name (str): Database name.
  # Returns:
  #   None
  def initialize(db_name)
    RubySQL::Assert.check_db_name(db_name)
    @db_name = db_name
  end

  # Connects to SQLite3 database based on the user input or to the default DB.
  # Params:
  #   None
  # Returns:
  # - db (database obj): Connected SQLite3 database object.
  def connect_sqlite3
    begin
      if not @db_name.empty?
        @dbh = SQLite3::Database.open @db_name
      else
        @dbh = SQLite3::Database.open "DB_default.db"
      end
      return @dbh
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
    end
  end

  # Checks the SQLite3 version and does STDOUT print
  # Params:
  #   None
  # Returns:
  #   None
  def sqlite3_version
    version = @dbh.get_first_value 'SELECT SQLITE_VERSION()'
    printf "SQLite3 version %s", version
  end
  
  # Checks if the database is opened and closes it.
  # Params:
  #   None
  # Returns:
  #   None
  def sqlite3_close
    @dbh.close if @dbh
  end
end
