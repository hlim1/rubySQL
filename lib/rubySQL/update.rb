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
  def sqlite3_update(update_ast, mem_db)
    table_name = update_ast[:table_name]

    # Prepare update query string
    update_query = "UPDATE #{table_name} SET "

    table_ast = @dbm.get_table_ast(table_name)
    update_query += process_set(update_ast[:columns], table_name, table_ast, mem_db)
    update_query += process_condition(update_ast[:condition])

    # DEBUG
    puts update_query
  end

  def process_set(columns, table_name, table_ast, mem_db)
    update_query = String.new
    columns.each {|col, val|
      RubySQL::Assert.column_exist(table_name, col, table_ast, @dbh)
      cur_column_in_table = [col, table_ast[col]]
      RubySQL::Assert.check_column_value(cur_column_in_table, val, mem_db[table_name], @dbh)
      update_query += "#{col} = #{val},"
    }
    update_query.chomp!(',')
    return update_query
  end

  def process_condition(condition)
    update_query = " WHERE "
    status = RubySQL::Assert.check_operator(condition[:op])
    msg = "Error: Invalid operator #{condition[:op]} for condition.\n"
    RubySQL::Assert.default_error_check(status, msg, @dbh)
    return update_query
  end
end
