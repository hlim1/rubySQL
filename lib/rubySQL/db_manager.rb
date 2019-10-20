require 'sqlite3'
require_relative 'assert'
# require_relative 'create'
# require_relative 'connection'

class RubySQL::DBManager

  # Declare instance variables
  # List of tables in the database will be loaded on memory.
  # Structure:
  #   {"__table_name__" => {
  #       :col_name => [__col_type__, __null?__, __pk?__],
  #       ...
  #     },
  #     ...
  #   }
  @tables = {}

  def initialize(dbh)
    @dbh = dbh
  end

  # Load tables in the database to on memory for faster lookup.
  # Params:
  # - None
  # Returns:
  # -
  def load_tables
    tables = sqlite3_all_tables
    if !tables.empty?
      tables.each {|table|
        tb_pragma = sqlite3_pragma(table[1])
        # tb_pragma[i]:
        # 0 := CID (int), 1 := table name (str), 2 := type (str),
        # 3 := null? (int, 1: Null. 0: Not-null)
        # 5 := PK? (int, 1: Null. 0: Not-null)
        @tables[tb_pragma[1]] = {tb_pragma[2], tb_pragma[3], tb_pragma[5]}
      }
    end

    puts @tables
  end

  # Get and return the list of tables in the database
  # Params:
  # - None
  # Returns:
  # - tables (array): An array of tables.
  def sqlite3_all_tables
    return @dbh.execute("select * from sqlite_master where type='table';")
  end

  # Get and return the table PRAGMA
  # Params:
  # - table_name (str): Table name
  # Returns:
  # - None
  def sqlite3_pragma(table_name)
    return  @dbh.execute("PRAGMA table_info(#{table_name});")
  end
end
