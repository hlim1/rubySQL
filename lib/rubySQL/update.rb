require 'sqlite3'
require_relative 'assert'
require_relative 'db_manager'

class RubySQL::Update
  def initialize(dbh, dbm, assert)
    @dbh = dbh
    @dbm = dbm
    @assert = assert
  end

  # Checks on update_ast, forms sql query and excutes query,
  # and update in-memory DB AST and DB.
  # Params:
  # - update_ast (hash): Hash that holds data to update table.
  # - mem_db (hash): In memory database.
  # Returns:
  # - update_query (str): SQL query that will be pushed SQLite3
  # -
  def sqlite3_update(update_ast, mem_db)
    table_name = update_ast[:table_name]

    # Prepare update query string
    update_query = "UPDATE #{table_name} SET "

    status = @dbm.table_exist?(table_name)
    @assert.table_not_exist(status, table_name, @dbh)

    table_ast = @dbm.get_table_ast(table_name)

    update_query += process_set(update_ast[:columns], table_name, table_ast, mem_db)
    update_query += process_condition(update_ast[:condition])
    update_query += ";"

    @dbh.execute(update_query)
    @mem_db_col, @mem_db_row = @dbm.update_mem_database("u", table_name, update_ast)
    return @mem_db_col, @mem_db_row, update_query + "\n"
  end

  # Process set. Generates SQL query for set section.
  # Params:
  # - columns (hash): Column name to value map.
  # - table_name (str): Table name.
  # - mem_db (hash): In memory database.
  # Returns:
  # - updated_query (str); Formed SQL query for set.
  def process_set(columns, table_name, table_ast, mem_db)
    update_query = String.new
    columns.each {|col, val|
      @assert.column_exist(table_name, col, table_ast, @dbh)
      cur_column_in_table = [col, table_ast[col]]
      @assert.check_column_value(cur_column_in_table, val, mem_db[table_name], @dbh)
      update_query += "#{col} = #{val},"
    }
    update_query.chomp!(',')
    return update_query
  end

  # Process condition. Generate SQL query for where section.
  # Params:
  # - condition (hash): Condition holder
  # Returns
  # - updated_query (str); Formed SQL query for where.
  def process_condition(condition)
    update_query = " WHERE "
    status = @assert.check_operator(condition[:op])
    msg = "Error: Invalid operator #{condition[:op]} for condition.\n"
    @assert.default_error_check(status, msg, @dbh)

    update_query += "#{condition[:col]} #{condition[:op]} #{condition[:val].to_s}"

    return update_query
  end
end
