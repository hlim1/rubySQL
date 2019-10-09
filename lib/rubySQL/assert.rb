class RubySQL::Assert
  def self.check_db_name(db_name)
    if not db_name.is_a?(String)
      puts "Invalid db_name type. db_name must given in String."
      printf "User input <%s>, which is type <%s>.\n", db_name, db_name.class
      exit
    end
  end
end
