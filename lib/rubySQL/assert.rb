require 'sqlite3'

class RubySQL::Assert
  # An array of SQLite3 types
  @sqlite3_types = [
    "TEXT", "CHAR",
    "CHARACTER", "VARCHAR",
    "INT", "INTEGER",
    "NULL", "REAL",
    "BLOB", "BOOL"
  ]

  # Checks validity of database name that was input from the user.
  # Database name must be a string type. Error and exit otherwise.
  # Params:
  # - db_name (str): Database name.
  # Returns:
  # - None
  def self.check_db_name(db_name)
    if not db_name.is_a?(String)
      puts "Error: Invalid db_name type. db_name type must be String."
      printf "Error: User input <#{db_name}>, which is type <#{db_name.class}>.\n"
      exit
    end
  end

  # Check validity of table name that was input from the user.
  # Table name must be given in a string type. Error and exit otherwise.
  # Params:
  # - table_name (str): Table name.
  # - dbh (DB obj): Database handler.
  # Returns:
  # - None.
  def self.check_table_name(table_name, dbh)
    if not table_name.is_a?(String)
      puts "Error: Invalid table_name type. Table name type must be String."
      printf "Error: User input <#{table_name}>, which is type <#{table_name.class}>.\n"
      dbh.close if dbh
      exit
    end
  end

  # Checks whether table exists or not.
  # If the user is trying to create a table that already exists,
  # this assert method will given an error and exit after closing the database safely.
  # Params:
  # - status (bool): true if table exists, false, if table does not exists.
  # - table_name (str): Table name.
  # Returns:
  # - None
  def self.table_already_exist(status, table_name, dbh)
    if status == true
      printf "Error: Table #{table_name} already exist.\n"
      dbh.close if dbh
      exit
    end

    #tables = dbh.execute("select * from sqlite_master where type='table';")
    #tables.each {|table|
      #if table_name == table[1]
        #printf "Error: Table #{table_name} already exist.\n"
        #dbh.close if dbh
        #exit
      #end
    #}
  end

  # Assert for user trying to access none existing table in the database.
  # Check and status will be done in the method that calls this assert method.
  # This method simply prints error message and exit on check failure.
  # Params:
  # - status (int): 1 (or true) for success or 0 (or false) for fail.
  # - table_name (str): Table name.
  # - dbh (DB obj): Database handlerfor closing the DB.
  # Returns:
  # - None.
  def self.table_not_exist(status, table_name, dbh)
    if status == false or status == nil
      printf "Error: Table #{table_name} does not exist in the database.\n"
      dbh.close if dbh
      exit
    end
  end

  # Checks for the type that the user input. If the input type is not
  # in the @sqlite3_types array, give an error and exit after safely closing
  # the database.
  # Params:
  # - type (str): User input type.
  # Returns:
  # - None
  def self.check_type(type)
    if !@sqlite3_types.include?(type.upcase)
      printf "Error: Type #{type} is not a valid SQLite3 type.\n"
      dbh.close if dbh
      exit
    end
  end

  # Compare the user input value class with the required value class.
  # If fail, prints error and exit.
  # Params:
  # - input_class (class): User input value class.
  # - compare_class (class): Require value class.
  # - dbh (DB obj): Database handlerfor closing the DB.
  # Returns:
  # - None.
  def self.check_class(input_class, compare_class, dbh)
    if input_class != compare_class
      puts "Error: Invalid value class (#{input_clas})."
      puts "The value class must be #{compare_class}."
      dbh.close if dbh
      exit
    end
  end

  def self.column_not_exist(status, dbh)

  end

  # Check for the passed status and print out error message
  # and  terminate the program or do nothing.
  # Params:
  # - status (int): 1 (or true) for success or 0 (or false) for fail.
  # - msg (str): Error message to be printed out in case of fail.
  # - dbh (DB obj): Database handlerfor closing the DB.
  # Returns:
  # - None.
  def self.error_message(status, msg, dbh)
    if status == 0 or status == false
      puts msg
      dbh.close if dbh
      exit
    end
  end
end
