require 'sqlite3'
require_relative 'assert'
require_relative 'db_manager'

class RubySQL::Drop
  def initialize(dbh, dbm, db_ast)
    @dbh = dbh
    @dbm = dbm
    @db_ast = db_ast
  end

  def drop_table(table_name)
    status = @dbm.table_exist?(table_name)
    RubySQL::Assert.table_not_exist(status, table_name, @dbh)

    @dbh.execute("DROP TABLE #{table_name}")
    # Update AST by removing the table.
    @dbm.update_AST("d", table_name)
    # TODO: Update memory loaded database.
    # @dbm.update_mem_database("drop", table_name)
  end
end
