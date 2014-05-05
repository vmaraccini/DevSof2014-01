require_relative 'checking_account'

class StudentAccount < CheckingAccount

	CREDIT_LINE = 0 #Setting the credit_line to 0 makes it so that students can only use their balance to make transactions.
	MONTHLY_FEE = 0 #Overrides monthly fee	

	def initialize
		super
		@monthly_fee = MONTHLY_FEE
		@credit_line = CREDIT_LINE
	end

end
