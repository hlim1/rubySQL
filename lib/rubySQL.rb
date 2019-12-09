class RubySQL
  ##
  # Main class for RubySQL that includes all other classes to execute methods.
  # 
  # Actual implementations for each methods reside in the "rubySQL/*" files.
  #
  # @db:  RubySQL member instance variable stands for database.
  # @dbh: Database object handler.
  # @dbm: Database manager.

  def initialize
    @select_in_progress = false
    @update_in_progress = false
  end

  # Initializes @db, @dbh, @tb_creator, insert_hd objects.
  # It connects to user specified database by calling connect_sqlite3
  # method from connect.rb to connect to the database.
  # Params:
  # - db_name (str): Database name
  # Returns:
  # - None
  def connect(db_name)
    @db                       = Connection.new(db_name)         # Connect to <db_name> database
    @dbh                      = @db.connect_sqlite3             # Database handler
    @dbm                      = DBManager.new(@dbh)             # Initialize database manageer
    @db_ast                   = @dbm.create_ast                 # Create DB AST
    @mem_db_col, @mem_db_row  = @dbm.load_tables                # Load data on to memory from the DB
    @tb_creator               = Create.new(@dbh, @dbm, db_name) # Initialize table creator 
    @insert_hd                = Insert.new(@dbh, @dbm)          # Initialize insert handler
    @selector                 = Select.new(@dbh, @dbm)          # Initialize select handler
    @updator                  = Update.new(@dbh, @dbm)          # Initialize update handler
    @queries                  = String.new                      # On memory query holder
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
    # At close, flush all the executed SQL queries into a file.
    query_file = File.new("Queries.txt", "w")
    query_file.write(@queries)
  end

  ###################################################################
  #                                                                 #
  #                           CREATE                                #
  #                                                                 #
  ###################################################################


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
  def with_columns(columns)
    status = columns.class == Array
    msg = "Error: 'with(__columns__)' must receive <array> of hashes.\n"
    msg += "Syntax: with (['column_name' => ['type', 'null?'])"
    RubySQL::Assert.default_error_check(status, msg, @dbh)

    columns.each {|col| 
      status = col.class == Hash  
      msg = "Error: 'with(__columns__)' must receive array of <hashes>.\n"
      msg += "Syntax: with (['column_name' => ['type', 'null?'])"
      RubySQL::Assert.default_error_check(status, msg, @dbh)
      @table[:columns].push(col)
    }
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
    @queries += @tb_creator.sqlite3_create_tb(
                  @table[:table_name], 
                  @table[:columns], 
                  @table[:primary_key],
                  @table[:if_not_exist],
                )
  end

  ###################################################################
  #                                                                 #
  #                           INSERT                                #
  #                                                                 #
  ###################################################################
  
  # Creates a new hash that has AST structure for insert.
  # Params:
  # - values (array): An array that holds values.
  def insert(values)
    status = columns.class == Array
    msg = "Error: insert() must receive a string(s) of array as argument.\n"
    msg += "User provided #{columns.class}"
    RubySQL::Assert.default_error_check(status, msg, @dbh)
    @insert = {
      :table_name => "",
      :values => values
    }
    self
  end

  # Fully construct the insert AST with values and table name.
  # It calls sqlite3_insert method from insert.rb.
  # Params:
  # - table_name (str): Table name
  # Returns:
  # - None
  def into(table_name)
    @insert[:table_name] = table_name
    @queries += @insert_hd.sqlite3_insert(@insert[:table_name], @insert[:values], @mem_db)
  end

  # Drops specified table from the database.
  # Params:
  # - table_name (str): Table name
  # Returns:
  # - None
  def drop_table(table_name)
    @dropper = Drop.new(@dbh, @dbm, @db_ast)
    @dropper.drop_table(table_name)
  end

  ###################################################################
  #                                                                 #
  #                           SELECT                                #
  #                                                                 #
  ###################################################################

  # Create select AST structure with a user provided table_name.
  # Params:
  # - table_name (str): Table name
  # - directions (str): Direction that user wants to retrieve by.
  def select_from(table_name, direction="row")
    @select_in_progress = true
    RubySQL::Assert.check_table_name(table_name, @dbh)
    status = (direction.class == String and (direction == "row" or direction == "col"))
    msg = "Error: direction must be either 'row' or 'col'.\n"
    msg += "User input #{direction}."
    RubySQL::Assert.default_error_check(status, msg, @dbh)

    @select = {
      :columns => [],
      :table_name => table_name,
      :condition => {},
      :direction => direction
    }
    self
  end

  # Updates @select hash's columns field.
  # Params:
  # - columns (array): Array of strings that hold column names
  # Returns:
  # - None
  def on_columns(columns)
    status = columns.class == Array
    msg = "Error: select() must receive a string(s) of array as argument.\n"
    msg += "User provided #{columns.class}"
    RubySQL::Assert.default_error_check(status, msg, @dbh)
    @select[:columns] = columns
    if @select[:direction] == "row"
      mem_db = @mem_db_row
    else
      mem_db = @mem_db_col
    end
    returned_rows, select_query = @selector.sqlite3_select(@select, mem_db)
    @queries += select_query
    @select_in_progress = false
    return returned_rows
  end

  # Get all data in the user specified table and return the rows.
  # Params:
  # - table_name (str): Table name.
  # - direction (str): Row or Column that user can specify to retrieve data. (Default: Row)
  # Returns:
  # - returned_data (array): Array of hashes that holds each row data or column data.
  def select_all(table_name, direction="row")
    if direction == "row"
      returned_data, select_all_query =  @selector.sqlite3_select_all(table_name, @mem_db_row, direction)
    elsif direction == "col"
      returned_data, select_all_query =  @selector.sqlite3_select_all(table_name, @mem_db_col, direction)
    else
      msg = "Error: Invalid direction input: #{direction}."
      msg += "Direction must be a string either 'row' or 'col'."
      RubySQL::Assert.default_error_check(0, msg, @dbh)
    end
    @queries += select_all_query
    return returned_data
  end

  # Get a primary key of a table and return the column name.
  # Params:
  # - table_name (str): Table name.
  # Returns:
  # - column_name (str): Primary key column name.
  def get_pk(table_name)
    return @select.sqlite3_get_pk(table_name)
  end

  ###################################################################
  #                                                                 #
  #                           UPDATE                                #
  #                                                                 #
  ###################################################################
   
  # Create update AST structure with a user provided table_name.
  # Params:
  # - table_name (str): Table name
  def update(table_name)
    RubySQL::Assert.check_table_name(table_name, @dbh)
    @update_in_progrss = true
    @update = {
      :columns => {},
      :table_name => table_name,
      :condition => {},
    }
    self
  end

  # Fill @update[:columns] field with column_to_value.
  # Params:
  # - column_to_value (array): Array of hashes. {"column" => value,..., "column" => value} 
  def set(column_to_value)
    status = column_to_value != nil 
    msg = "Error: Set argument must be given."
    RubySQL::Assert.default_error_check(status, msg, @dbh)

    RubySQL::Assert.check_class(column_to_value.class, Hash, @dbh)
    @update[:columns] = column_to_value

    status = !@update[:condition].empty?
    msg = "Error: Condition must be provided to update a table."
    RubySQL::Assert.default_error_check(status, msg, @dbh)

    @mem_db_col, @mem_db_row, query = @updator.sqlite3_update(@update, @mem_db_col)
    @queries += query
  end

  ###################################################################
  #                                                                 #
  #                     SHARED FUNCTIONS                            #
  #                                                                 #
  ###################################################################

  # Updates @select or @update hash's condition field.
  # Params:
  # - op (str): Operator that will be used to compare (>, <, =, and in, etc.).
  # - col (str): Column that will be conditioned.
  # - value (dynamic): A value that will be target to compared  with col.
  # Returns:
  # - None
  def where(op,  col, value=nil)
    condition = {:op => op, :col => col, :val => value}
    if @select_in_progress
      @select[:condition] = condition
    elsif @update_in_progrss
      @update[:condition] = condition
    else
      msg = "Error: <where> can only be used either with select or update.\n"
      RubySQL::Assert.default_error_check(0, msg, @dbh)
    end
    self
  end
 
  ###################################################################
  #                                                                 #
  #                        MISCELLANEOUS                            #
  #                                                                 #
  ###################################################################
  
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
    @tb_creator.sqlite3_list_tables
  end

  # This is just for debugging purpose.
  def print
    puts @table
  end
end

require 'rubySQL/db_manager'
require 'rubySQL/connection'
require 'rubySQL/assert'
require 'rubySQL/create'
require 'rubySQL/insert'
require 'rubySQL/drop'
require 'rubySQL/select'
require 'rubySQL/update'
