require_relative 'bank_account'

class SalaryAccount < CheckingAccount

	def initialize

		super
		@monthly_fee = @monthly_fee/ 2 #Overrides monthly fee

	end
  	
  	def transfer(account,amount)
  		#Does nothing.
  	end

end