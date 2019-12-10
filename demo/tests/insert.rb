require 'rubySQL'

rbsql = RubySQL.new
rbsql.connect("DB_demo.db")

# Insert values into table COMPANY_A
rbsql.insert([1, "ABC", 29, "Tucson, AA", {"SALARY":100000.00}]).into("COMPANY_A")
rbsql.insert([2, "DEF", 30, "Los Angeles, CA", {"SALARY":200000.00}]).into("COMPANY_A")
rbsql.insert([3, "GHI", 40, "San Francisco, CA", {"SALARY":300000.00}]).into("COMPANY_A")
rbsql.insert([4, "JKL", 50, "Phoenix, AZ", {"SALARY":400000.00}]).into("COMPANY_A")

rbsql.close
