require 'sqlite3'
require_relative 'assert'
require_relative 'db_manager'

class RubySQL::Select

  def initialize(dbh, dbm, assert)
    @dbh = dbh
    @dbm = dbm
    @assert = assert
  end

  # Performs all checks on the select ast
  # that was generated with user input.
  # Generates SQL query string and executes it, if all checks passed.
  # Params:
  # - select_ast (hash): @select ast in hash that was formed in rubySQL.rb.
  # Returns:
  # - returned_rows (array of hash): Returned rows from DB.
  # - select_query (str): Constructed query that was successfully pushed to DB.
  def sqlite3_select(select_ast, mem_db)
    table_name = select_ast[:table_name]
    @assert.check_table_name(table_name, @dbh)

    table_ast = @dbm.get_table_ast(table_name)
    columns = select_ast[:columns]
    @assert.select_column_check(table_name, columns, table_ast, @dbh)

    condition = select_ast[:condition]
    condition_exist = false
    if condition
      condition_exist = true
      condition_query = "#{condition[:col]} #{condition[:op]} #{condition[:value]}"
    end

    columns_to_select = String.new
    columns.each {|col|
      if col == "*"
        return sqlite3_select_all(table_name, mem_db)
      end
      columns_to_select += "#{col},"
    }
    columns_to_select.chomp(',')
    if condition
      select_query = "SELECT #{columns_to_select} FROM #{table_name} WHERE #{condition_query};"
    else
      select_query = "SELECT #{columns_to_select} FROM #{table_name};"
    end

    if select_ast[:direction] == "row"
      returned_rows = Array.new
      mem_db[table_name].each {|rows|
        row = Hash.new
        columns.each {|col_n|
          if condition_exist then
            if col_n == condition[:col] then
              if condition[:op] == "==" and rows[col_n] == condition[:val].to_i then
                val = rows[col_n]
              elsif condition[:op] == ">=" and rows[col_n] >= condition[:val].to_f then
                val = rows[col_n]
              elsif condition[:op] == "<=" and rows[col_n] <= condition[:val].to_ithen
                val = rows[col_n]
              elsif condition[:op] == ">" and rows[col_n] > condition[:val].to_i then
                val = rows[col_n]
              elsif condition[:op] == "<" and rows[col_n] < condition[:val].to_ithen
                val = rows[col_n]
              elsif condition[:op] == "!=" and rows[col_n] != condition[:val].to_ithen
                val = rows[col_n]
              else
                status = @assert.check_operator(condition[:op])
                msg = "Error: Currently #{condition[:op]} is not handled.\n"
                @assert.default_error_check(status, msg, @dbh)
              end
            else
              val = nil
            end
          else
            val = rows[col_n]
          end
          if val
            row[col_n] = val
          end
        }
        returned_rows.push(row)
      }
      return returned_rows, select_query + "\n"
    else
      # TODO: Condition operations for column based select return.
      returned_cols = Hash.new
      columns.each {|col|
        returned_cols[col] = mem_db[table_name][col]
      }
      return returned_cols, select_query + "\n"
    end
  end

  # Simply query on database for all data in table and return the returned rows
  # from the database.
  # Params:
  # - table_name (str): Table name.
  # - direction (str): Row or Column that user can specify to retrieve data.
  # Returns:
  # - returned_rows (array of hash): Returned rows from DB.
  # - select_all_query (str): Constructed query that was successfully pushed to DB.
  def sqlite3_select_all(table_name, mem_db, direction)
    @assert.check_table_name(table_name, @dbh)
    # get_table_ast does the table existence check.
    table_ast = @dbm.get_table_ast(table_name)
    returned_data = mem_db[table_name]
    select_all_query = "SELECT * FROM #{table_name};"
    return returned_data, select_all_query + "\n"
  end

  # It will return the primary key column name of table.
  # Params:
  # - table_name (str): Table name.
  # Returns:
  # - column_name (str): Column name that is a primary key of table.
  def sqlite3_get_pk(table_name)
    @assert.check_table_name(table_name, @dbh)
    table_ast = @dbm.get_table_ast(table_name)
    table_ast.each {|column_name, column_info|
      if column_info[2] == 1
        return column_name
      end
    }
    msg = "Internal Error: Primary key was not set properly."
    @assert.deault_error_check(0, msg, @dbh)
  end

  def sqlite3_get_fk(table_name)

  end
end
