class RubySQL
  ##
  # Main class for RubySQL that includes all other classes to execute methods.
  # 
  # Actual implementations for each methods reside in the "rubySQL/*" files.
  #
  # @db:  RubySQL member instance variable stands for database.
  # @dbh: Database object handler.
  
  def connect(db_name)
    @db = Connection.new(db_name)
    @dbh = @db.connect_sqlite3
    @tb_creator = Create.new(@dbh)
  end

  def version
    puts @db.sqlite3_version
  end

  def close
    @db.sqlite3_close
  end

  def create_table(table_name)
    @table = {:table_name => table_name, :columns => [], :primary_key => ""}
    self
  end

  def with(columns)
    columns.each {|col| @table[:columns].push(col)}
    self
  end

  def primary(column)
    @table[:primary_key] = column
    @tb_creator.sqlite3_create_tb(@table[:table_name], @table[:columns], @table[:primary_key])
  end

  def schema_of(table_name)
    @tb_creator.sqlite3_schema(table_name)
  end

  def list_tables
    @tb_creator.sqlite3_list_tables
  end

  # This is just for debugging purpose.
  def print
    puts @table
  end
end

require 'rubySQL/connection'
require 'rubySQL/assert'
require 'rubySQL/create'
