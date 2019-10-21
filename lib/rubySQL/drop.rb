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
    if !tables.has_key?(table_name)
        printf "Error: Table #{table_name} does not exist.\n"
        dbh.close if dbh
        exit
    end
    @dbh.execute("DROP TABLE #{table_name}")
    # Update AST by removing the table.
    @dbm.update_AST("d", table_name)
    # TODO: Update memory loaded database.
    # @dbm.update_mem_database("drop", table_name)
  end
end
