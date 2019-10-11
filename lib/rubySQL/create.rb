require 'sqlite3'
require_relative 'assert'

class RubySQL::Create
  def initialize(dbh)
    @dbh = dbh
  end

  def sqlite3_create_tb(table_name, columns, primary_key)
    # Retrieve only the column names
    col_names = columns[0].keys
    table_spec_str = '('

    # columns[0][col][0]: Column type
    # columns[1][col][1]: Column nullable
    col_names.each {|col|
      # TODO: Assert function for type checking
      if col == primary_key
        # TODO: Assert function for checking nullable (MUST be NO)
        table_spec_str.concat("#{col} #{columns[0][col][0]} PRIMARY KEY NOT NULL,")
      else
        if columns[0][col][1].downcase == "no"
          table_spec_str.concat("#{col} #{columns[0][col][0]} NOT NULL,")
        else
          table_spec_str.concat("#{col} #{columns[0][col][0]},")
        end
      end
    }
    table_spec_str.chomp!(',')
    table_spec_str.concat(')')

    puts table_spec_str

    # @dbh.execute("CREATE TABLE #{table_name} 
  end
end
