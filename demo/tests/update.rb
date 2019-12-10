require 'rubySQL'

rbsql = RubySQL.new
rbsql.connect("DB_demo.db")

# SELECT * FROM COMPANY_A;
rows_a = rbsql.select_all("COMPANY_A")
puts "Returned rows_a:"
rows_a.each {|row|
  puts row
}

# UPDATE
rbsql.update("COMPANY_A").where(">=", "SALARY", 300000).set({"SALARY" => 450000.00})
rbsql.update("COMPANY_A").where(">=", "SALARY", 400000).set({"SALARY" => 550000.00})

# SELECT
rows_b = rbsql.select_from("COMPANY_A", "row").where(">=", "SALARY", 400000).on_columns(["ID", "NAME", "AGE", "SALARY"])
puts "Returned rows_b:"
puts rows_b

rbsql.close
