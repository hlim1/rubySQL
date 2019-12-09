require 'sqlite3'
require_relative 'assert'
require_relative 'db_manager'

class RubySQL::Drop
  def initialize(dbh, dbm, db_ast, assert)
    @dbh = dbh
    @dbm = dbm
    @db_ast = db_ast
    @assert
  end

  def drop_table(table_name)
    status = @dbm.table_exist?(table_name)
    @assert.table_not_exist(status, table_name, @dbh)

    @dbh.execute("DROP TABLE #{table_name}")
    # Update AST by removing the table.
    @dbm.update_AST("d", table_name)
    # Update memory loaded database.
    @dbm.update_mem_database("drop", table_name)
  end
end
