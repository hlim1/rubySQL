require 'sqlite3'
require_relative 'assert'
require_relative 'db_manager'

class RubySQL::Select

  def initialize(dbh, dbm)
    @dbh = dbh
    @dbm = dbm
  end

  # Performs all checks on the select ast
  # that was generated with user input.
  # Generates SQL query string and executes it, if all checks passed.
  # Params:
  # - select_ast (hash): @select ast in hash that was formed in rubySQL.rb.
  # Returns:
  # - returned_rows (array of hash): Returned rows from DB.
  # - select_query (str): Constructed query that was successfully pushed to DB.
  def select(select_ast, mem_db)
    table_name = select_ast[:table_name]
    RubySQL::Assert.check_table_name(table_name, @dbh)

    table_ast = @dbm.get_table_ast(table_name)
    columns = select_ast[:columns]
    RubySQL::Assert.select_column_check(table_name, columns, table_ast, @dbh)

    columns_to_select = String.new

    columns.each {|col|
      if col == "*"
        columns_to_select = "*"
      end
    }

    select_query = "SELECT #{columns_to_select} FROM #{table_name};"
    returned_rows = @dbh.execute(select_query)

    return returned_rows, select_query + "\n"
  end

  def select_all(table_name)

  end

  def get_pk(table_name)

  end

  def get_fk(table_name)

  end
end
