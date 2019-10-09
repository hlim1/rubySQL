module RubySQL
  def self.connect(db_name)
    connection = Connection.new(db_name)
    connection.connect
  end
end

require 'rubySQL/connection'
