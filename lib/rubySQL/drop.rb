require 'sqlite3'
require_relative 'assert'
require_relative 'db_manager'

class RubySQL::Drop
  def initialize(dbh, dbm)
    @dbh = dbh
    @dbm = dbm
  end

  def drop_table(table_name)
    # TODO: Check the existence of table.
    @dbh.execute("DROP TABLE #{table_name}")
    # Update AST by removing the table.
    @dbm.update_AST("d", table_name)
    # TODO: Update memory loaded database.
    # @dbm.update_mem_database("drop", table_name)
  end
end
