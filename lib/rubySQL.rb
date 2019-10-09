class RubySQL
  def connect(db_name)
    @db = Connection.new(db_name)
    @dbh = @db.connect_sqlite3
  end

  def version
    puts @db.sqlite3_version
  end
end

require 'rubySQL/connection'
require 'rubySQL/assert'
