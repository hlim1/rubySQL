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
  # - mem_db (hash) : Memory loaded database object.
  def sqlite3_insert(table_name, values, mem_db)
    RubySQL::Assert.check_table_name(table_name, @dbh)

    table_ast = Hash.new
    table_ast = @dbm.get_table_ast(table_name)
    # TODO: Each value element type. All types are acceptable.
    # If hash, {key:value} needs to be {column_name:value}.

    # This hash holds a map of column position in the table
    index_to_column = Hash.new
    # Since the position of column in a table is static on
    # creation, we can keep a track of each column position
    # simple by assigning an index to each (A.K.A. indexing).
    tb_index = 0
    table_ast.each {|col_name, col_info|
      index_to_column[tb_index] = [col_name, col_info]
      tb_index += 1
    }

    RubySQL::Assert.check_class(values.class, Array, @dbh)
    vl_index = 0
    column_to_value = Hash.new
    values.each {|value|
      if value.class == Hash
        status = value.size == 1
        error_msg = "Error: Size of hash for insert value cannot exeed 1.\n"
        error_msg += "#{value} has size #{value.size}"
        RubySQL::Assert.default_error_check(status, error_msg, @dbh)
        
        # Extract user input value
        col_name = value.keys[0]
        status = table_ast.has_key?(col_name.to_s)
        error_msg = "Column #{col_name.to_s} does not exist in table #{table_name}.\n"
        error_msg += @dbm.get_table_schema(table_name)
        RubySQL::Assert.default_error_check(status, error_msg, @dbh)
        column_to_value[col_name.to_s] = value[col_name]
      else
        # Compare input value type with table column type
        cur_column_in_table = index_to_column[vl_index]
        RubySQL::Assert.check_column_value(cur_column_in_table, value, mem_db[table_name], @dbh)
        col_name = cur_column_in_table[0]
        column_to_value[col_name] = value
      end

      vl_index += 1
    }

    insert_query = "INSERT INTO #{table_name} ("
    column_to_value.each_key {|col_name|
      insert_query += "#{col_name},"
    }
    insert_query.chomp!(',')
    insert_query += ") VALUES ("
    column_to_value.each_value {|value|
      if value.class == String
        insert_query += "'#{value}',"
      else
        insert_query += "#{value},"
      end
    }
    insert_query.chomp!(',')
    insert_query += ');'

    @dbh.execute(insert_query)
    return insert_query + "\n"
  end
end
