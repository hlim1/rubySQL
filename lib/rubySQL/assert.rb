require 'sqlite3'

class RubySQL::Assert
  # An array of SQLite3 types
  @sqlite3_types = [
    "TEXT", "CHAR",
    "CHARACTER", "VARCHAR",
    "INT", "INTEGER",
    "NULL", "REAL",
    "DOUBLE", "DOUBLE PRECISION",
    "FLOAT",
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

  # Check for the passed status and print out error message
  # and  terminate the program or do nothing.
  # Params:
  # - status (int): 1 (or true) for success or 0 (or false) for fail.
  # - msg (str): Error message to be printed out in case of fail.
  # - dbh (DB obj): Database handlerfor closing the DB.
  # Returns:
  # - None.
  def self.default_error_check(status, msg, dbh)
    if status == 0 or status == false
      puts msg
      dbh.close if dbh
      exit
    end
  end

  def self.check_column_value(cur_column_in_table, value, mem_db, dbh)
    col_name = cur_column_in_table[0]
    col_type = cur_column_in_table[1][:type]
    if cur_column_in_table[1][:pk?] == 1
      uniqueness = 1
    else
      uniqueness = 0
    end

    status = check_column_type(col_type, value)
    msg = "Error: Column <#{col_name}> type is #{col_type}.\n"
    msg += "User input value type is <#{value.class}>."
    default_error_check(status, msg, dbh)

    status = check_column_uniqueness(col_name, mem_db, uniqueness, value)
    msg = "Error: All values in column <#{col_name}>must be unique.\n"
    msg += "User input value <#{value}> already exist."
    default_error_check(status, msg, dbh)
  end

  def self.check_column_type(col_type, value)
    # TODO: Type check for BLOB
    if (
        (col_type.upcase == "INT"\
         or col_type.upcase == "INTEGER")\
        and value.class != Integer\
    )
      return 0
    elsif (
        (col_type.upcase == "TEXT" \
         or col_type.upcase.include? "CHAR"\
         or col_type.upcase.include? "CHARACTER"\
         or col_type.upcase.include? "VARCHAR")\
        and value.class != String\
    )
      return 0
    elsif (
        (col_type.upcase == "REAL"\
         or col_type.upcase == "DOUBLE"\
         or col_type.upcase == "DOUBLE PRECISION"\
         or col_type.upcase  == "FLOAT")\
        and value.class != Float\
    )
      return 0
    elsif (
        col_type.upcase == "BOOL"\
        and (value.class != TrueClass\
             or value.class != FalseClass)\
    )
      return 0
    end

    return 1
  end

  def self.check_column_uniqueness(col_name, mem_db, uniqueness, value)
    if uniqueness == 1
      values_in_columns = mem_db[col_name]
      if values_in_columns.include? value
        return 0
      end
    end

    return 1
  end
end
