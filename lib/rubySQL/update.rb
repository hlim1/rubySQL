require 'sqlite3'
require_relative 'assert'
require_relative 'db_manager'

class RubySQL::Update
  def initialize(dbh, dbm)
    @dbh = dbh
    @dbm = dbm
  end

  # Checks on update_ast, forms sql query and excutes query,
  # and update in-memory DB AST and DB.
  # Params:
  # - update_ast (hash): Hash that holds data to update table.
  # Returns:
  # - update_query (str): SQL query that will be pushed SQLite3
  # -
  def sqlite3_update(update_ast)
    
  end
end
