require 'sqlite3'
require_relative 'assert'
# require_relative 'create'
# require_relative 'connection'

class RubySQL::DBManager

  def initialize(dbh)
    @dbh = dbh
    # List of tables in the database will be loaded on memory
    # in abstract syntax tree (AST).
    # Structure:
    #   {"__table_name__" = [
    #       "__col_name__" => {
    #             :type => "__col_type__",
    #             :null? => __null?__, 
    #             :pk? => __pk?__
    #       },
    #       ...
    #     ],
    #     ...
    #   }
    @table_ast = Hash.new
    # Hash that actually holds data
    # Structure:
    #   {"__table_name__" => {
    #       "__col_name__" => [],
    #       ...
    #   },
    @database = Hash.new
  end

  # Construct database abstract syntax tree.
  # Params:
  # - None
  # Returns:
  # -  @table_ast (Hash): Constructed database AST or
  # an empty hash if DB is empty.
  def create_ast
    tables = sqlite3_all_tables
    if !tables.empty?
      tables.each {|table|
        tb_schema = sqlite3_pragma(table[1])
        column_info = Hash.new
        tb_schema.each {|schema|
          # schema:
          # 0 := CID (int), 1 := table name (str), 2 := type (str),
          # 3 := null? (int, 1: Null. 0: Not-null)
          # 5 := PK? (int, 1: Null. 0: Not-null)
          column_info[schema[1]] = {:type => schema[2], :null? => schema[3], :pk? => schema[5]}
        }
        @table_ast[table[1]] = column_info
      }
    end
    return @table_ast
  end

  # TODO: Load tables in the database to on memory for faster lookup.
  # Params:
  # - None
  # Returns:
  # -
  def load_tables
    tables = @table_ast.keys
    tables.each {|table|
      rows = @dbh.execute("SELECT * FROM #{table}")
      puts rows
      @table_ast[table].each {|col|
      }
    }
  end

  # Update AST when UPDATE and DELETE.
  def update_AST

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

  def get_table_ast(table_name)
    status = @table_ast.has_key?(table_name)
    return table_ast
  end
end
