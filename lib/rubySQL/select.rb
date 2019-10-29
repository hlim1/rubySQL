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
  # - select_ast (hash): @select ast in hash that was formed in rubySQL.rb
  def select(select_ast)
    table_name = select_ast[:table_name]
    RubySQL::Assert.check_table_name(table_name, @dbh)

    table_ast = @dbm.get_table_ast(table_name)

    puts "PRINT IN SELECT"
    puts select_ast[:table_name]
    puts select_ast[:columns]
    puts select_ast[:condition]
  end

  def get_pk

  end

  def get_fk

  end
end
