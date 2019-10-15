require 'sqlite3'

class RubySQL::Assert
  # Checks validity of database name that was input from the user.
  # Database name must be a string type. Error and exist otherwise.
  # Params:
  # - db_name (str): Database name
  # Returns:
  # - None
  def self.check_db_name(db_name)
    if not db_name.is_a?(String)
      puts "Error: Invalid db_name type. db_name type must be String."
      printf "Error: User input <%s>, which is type <%s>.\n", db_name, db_name.class
      exit
    end
  end

  # Checks whether table exists or not.
  # If the user is trying to create a table that already exists,
  # this assert method will given an error and exit after closing the database safely.
  # Params:
  # - table_name (str): Table name
  # - dbh(db obj): Database handler for currently connected database
  # Returns:
  # - None
  def self.table_exist(table_name, dbh)
    tables = dbh.execute("select * from sqlite_master where type='table';")
    tables.each {|table|
      if table_name == table[1]
        printf "Error: Table #{table_name} already exist.\n"
        dbh.close if dbh
        exit
      end
    }
  end
end
