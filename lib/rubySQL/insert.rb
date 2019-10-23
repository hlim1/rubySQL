require 'sqlite3'
require_relative 'assert'
require_relative 'db_manager'

class RubySQL::Insert
  def initialize(dbh, dbm)
    @dbh = dbh
    @dbm = dbm
  end

  # Insert values into table on disk and update on memory AST and database.
  # Params:
  # - table_name (str): Table name
  # - values (array): An array that holds values.
  def sqlite3_insert(table_name, values)
    RubySQL::Assert.self.check_table_name(table_name, @dbh)
    table_ast = @dbm.get_table_ast(table_name)
    # TODO: Each value element type. All types are acceptable.
    # If hash, {key:value} needs to be {column_name:value}.

  end
end
