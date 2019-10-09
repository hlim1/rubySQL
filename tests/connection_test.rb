require 'rubySQL'

def my_connection()
  rbsql = RubySQL.new
  rbsql.connect("DB_test.db")
  rbsql.version
end

my_connection()
