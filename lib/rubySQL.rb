class RubySQL
  ##
  # Main class for RubySQL that includes all other classes to execute methods.
  # 
  # Actual implementations for each methods reside in the "rubySQL/*" files.
  #
  # @db:  RubySQL member instance variable stands for database.
  # @dbh: Database object handler.
  # @dbm: Database manager.

  # Declare instance variables
  # List of tables in the database will be loaded on memory.
  # Structure:
  #   {"__table_name__" => {
  #       :col_name => [__col_type__, __null?__, __pk?__],
  #       ...
  #     },
  #     ...
  #   }
  @tables = {} 

  def initialize
  end

  # Initializes @db, @dbh, and @tb_creator objects and calls connect_sqlite3
  # method from connect.rb to connect to the database.
  # Params:
  # - db_name (str): Database name
  # Returns:
  # - None
  def connect(db_name)
    @db = Connection.new(db_name)
    @dbh = @db.connect_sqlite3
    @dbm = DBManager.new(@dbh)
    @dbm.load_tables
    @tb_creator = Create.new(@dbh, @dbm, db_name)
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
  # - self (RubySQL obj): returns self. This is for method chaining
  def create_table(table_name, if_not_exist="N")
    @table = {
      :table_name => table_name, 
      :columns => [], 
      :primary_key => "",
      :if_not_exist => if_not_exist
    }
    self
  end

  # Populates @table[:columns] hash with the user input.
  # This must be used with create_table.
  # Params:
  # - columns (array): Array of hash holding table column info from the user
  # Returns: None
  def with(columns)
    columns.each {|col| @table[:columns].push(col)}
    self
  end

  # Populates @table[:primary_key] and calls sqlite3_create_tb from create.rb
  # to create a table with the completly filled @table hash.
  # This must be used with create_table and with methods as a method chaining.
  # Params:
  # - column (str): Column name that is for primary key
  # None:
  # - None
  def primary(column)
    @table[:primary_key] = column
    @tb_creator.sqlite3_create_tb(
      @table[:table_name], 
      @table[:columns], 
      @table[:primary_key],
      @table[:if_not_exist]
    )
  end

  # Call sqlite3_schema method from create.rb to print the table schema.
  # Params:
  # - table_name (str): Table name
  # Returns:
  # - None
  def schema_of(table_name)
    @tb_creator.sqlite3_schema(table_name)
  end

  # Calls sqlite3_list_tables to print the list of tables in the database.
  # Params:
  # - None
  # Returns:
  # - None
  def list_tables
    .sqlite3_list_tables
  end

  # This is just for debugging purpose.
  def print
    puts @table
  end
end

require 'rubySQL/connection'
require 'rubySQL/assert'
require 'rubySQL/create'
require 'rubySQL/db_manager'
