require 'sqlite3'
require_relative 'assert'

class RubySQL::Create
  # Initializes a new class member variable with the passed db handler.
  # Params:
  # - dbh (db obj): Database handler
  # Returns:
  # - None
  def initialize(dbh)
    @dbh = dbh
  end

  # Create a new table in the database.
  # Params:
  # - table_name (str): Table name.
  # - columns (list): A list of hashes that holds column info.
  # - primary_key (str): A column name that will be set to primary key.
  # - if_not_exist (str): It tells whether the user wants to execute create
  # operation even if the table exists or not.
  # Returns:
  # - None
  def sqlite3_create_tb(table_name, columns, primary_key, if_not_exist)
    if if_not_exist.downcase == "n"
      RubySQL::Assert.table_exist(table_name, @dbh)
    end 
    # Retrieve only the column names
    col_names = columns[0].keys
    table_spec_str = '('

    # columns[0][col][0]: Column type
    # columns[1][col][1]: Column nullable
    col_names.each {|col|
      # TODO: Assert function for type checking
      if col == primary_key
        # TODO: Assert function for checking nullable (MUST be NO)
        table_spec_str.concat("#{col} #{columns[0][col][0]} PRIMARY KEY NOT NULL,")
      else
        if columns[0][col][1].downcase == "no"
          table_spec_str.concat("#{col} #{columns[0][col][0]} NOT NULL,")
        else
          table_spec_str.concat("#{col} #{columns[0][col][0]},")
        end
      end
    }
    table_spec_str.chomp!(',')
    table_spec_str.concat(')')

    @dbh.execute("CREATE TABLE IF NOT EXISTS #{table_name} #{table_spec_str};")
  end

  # Prints out the schema of specified table.
  # Params:
  # - table_name (str): Table name
  # Returns:
  # - None 
  def sqlite3_schema(table_name)
    table_schema = @dbh.execute("PRAGMA table_info(#{table_name});")

    # First, find the max lengths of each column's title strings
    # for nice print out in a fixed length of table format
    max_column_name_length = 0
    max_type_name_col_length = 22
    max_nullable_col_length = 10
    max_pk_col_length = 5

    table_schema.each {|schema|
      if max_column_name_length < schema[1].length
          max_column_name_length = schema[1].length
      end
      
      # Check null status and convert the stored binary value
      # into string "YES" or "NO"
      if schema[3] == 1
        schema[3] = "YES"
      else
        schema[3] = "NO"
      end

      # Check primary key status and convert the stored
      # binary value into string "YES" or "NO"
      if schema[5] == 1
        schema[5] = "YES"
      else
        schema[5] = "NO"
      end
    }

    # Print out the schema in a table format
    puts table_name
    printf "%-5s | %-#{max_column_name_length}s | %-22s | %-5s | %-5s\n",\
           "CID", "NAME", "TYPE", "NULL?", "PK?"
    dash_line_splitter = '-' * (50 + max_column_name_length)
    puts dash_line_splitter
    table_schema.each {|schema|
      printf "%-5s | %-#{max_column_name_length}s | %-22s | %-5s | %-5s\n",\
           schema[0].to_s, schema[1], schema[2], schema[3], schema[5]
    }
  end

  # Prints out the list of all tables in the database with their schema.
  # Params:
  # - None
  # Returns:
  # - None
  def sqlite3_list_tables
    tables = @dbh.execute("select * from sqlite_master where type='table';")
    tables.each {|table|
      printf "#{table[1]} | #{table[4]}\n"
    }
  end
end
