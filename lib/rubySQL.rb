class RubySQL
  ##
  # Main class for RubySQL that includes all other classes to execute methods.
  
  def connect(db_name)
    @db = Connection.new(db_name)
    @dbh = @db.connect_sqlite3
  end

  def version
    puts @db.sqlite3_version
  end

  def close
    @db.sqlite3_close
  end
end

require 'rubySQL/connection'
require 'rubySQL/assert'
