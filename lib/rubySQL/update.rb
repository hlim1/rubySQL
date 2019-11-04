require 'sqlite3'
require_relative 'assert'
require_relative 'db_manager'

class RubySQL::Update
  def initialize(dbh, dbm)
    @dbh = dbh
    @dbm = dbm
  end

  def sqlite_update(update_ast)

  end
end
