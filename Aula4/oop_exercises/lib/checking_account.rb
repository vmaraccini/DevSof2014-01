require_relative 'bank_account'

class CheckingAccount < BankAccount

  TRANSFER_FEE = 8

  def deposit(amount)
    @balance += amount
    log_transaction('Deposit', amount)
  end

  def withdraw(amount)

    if @balance + @credit_line >= amount
      #Allows the withdraw
      @balance -= amount
      log_transaction('Withdrawal', amount)
    end
    
  end

  def transfer(account, amount)

    if @balance >= amount + TRANSFER_FEE
      self.withdraw(amount)
      self.withdraw(TRANSFER_FEE)
      account.deposit(amount)
    end

  end

end
