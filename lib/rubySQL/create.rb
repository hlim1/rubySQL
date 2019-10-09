require 'sqlite3'
require_relative 'assert'

class RubySQL::Create
  def initialize(dbh)
    @dbh = dbh
  end

  def sqlite3_create_tb(table_name)
    # Convert all strings to lower case as a default
    # before creating a new table.
    @table = table_name.downcase
  end
end
