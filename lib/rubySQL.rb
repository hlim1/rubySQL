class RubySQL
  ##
  # Main class for RubySQL that includes all other classes to execute methods.
  # 
  # Actual implementations for each methods reside in the "rubySQL/*" files.
  #
  # @db:  RubySQL member instance variable stands for database.
  # @dbh: Database object handler.
 
  # Initializes @db, @dbh, and @tb_creator objects and calls connect_sqlite3
  # method from connect.rb to connect to the database.
  # Params:
  # - db_name (str): Database name
  # Returns:
  # - None
  def connect(db_name)
    @db = Connection.new(db_name)
    @dbh = @db.connect_sqlite3
    @tb_creator = Create.new(@dbh)
  end

  # Calls sqlite2_version method that is declared in the connect.rb
  # Params:
  # - None
  # Returns:
  # - None
  def version
    @db.sqlite3_version
  end

  # Closes (disconnects) currently opened database
  # Params:
  # - None
  # Returns:
  # - None
  def close
    @db.sqlite3_close
  end

  # Creates an AST skeleton that will be populated with the user input
  # in other methods that will be chained with this method.
  # Params:
  # - table_name (str): Table name
  # - if_not_exist (str): Indicates whether the user wants to attempt to
  # create a table regardless of its existance in the database. Default
  # value is "N", which stands for "NO" that the assert method will give
  # and error and exit when the user is trying to create a table that is
  # already exist. However, the user can specify "Y" when calling create_table
  # method with "Y" in the 2nd argument. In SQLite3, if [IF NOT EXISTS] is specified,
  # it will ignore the operation and move on to next operation if the table
  # already exists without any warning. It is recommended to specify "Y" if the user
  # is using this create_table method in the static stored file program.
  # Retuns:
  # - None 
  def create_table(table_name, if_not_exist="N")
    @table = {
      :table_name => table_name, 
      :columns => [], 
      :primary_key => "",
      :if_not_exist => if_not_exist
    }
    self
  end

  def with(columns)
    columns.each {|col| @table[:columns].push(col)}
    self
  end

  def primary(column)
    @table[:primary_key] = column
    @tb_creator.sqlite3_create_tb(
      @table[:table_name], 
      @table[:columns], 
      @table[:primary_key],
      @table[:if_not_exist]
    )
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
