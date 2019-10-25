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
  def sqlite3_insert(table_name, values)
    RubySQL::Assert.check_table_name(table_name, @dbh)

    table_ast = Hash.new
    table_ast = @dbm.get_table_ast(table_name)
    # TODO: Each value element type. All types are acceptable.
    # If hash, {key:value} needs to be {column_name:value}.

    table_ast.each {|col_name, col_info|
      puts "#{col_name}: #{col_info}"
    }

    RubySQL::Assert.check_class(values.class, Array, @dbh)
    values.each {|value|
      if value.class == Hash
        status = value.size > 1
        error_msg = "Error: Size of hash for insert value cannot exeed 1."
        RubySQL::Assert.default_error_check(status, error_msg, @dbh)

        col_name = value.keys[0]
        col_value = value[col_name]
        status = table_ast.has_key?(col_name)
        error_msg = "Column #{col_name} does not exist in table #{table_name}."
        RubySQL::Assert.default_error_check(status, error_msg, @dbh)
      end
    }
  end
end
