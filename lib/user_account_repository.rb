require 'user_account.rb'

class UserAccountRepository

  # Selecting all records
  # No arguments
  def all
    sql = 'SELECT email_address, username FROM user_accounts;'
    result_set = DatabaseConnection.exec_params(sql, [])
    
    accounts = []
    
    result_set.each do |record|
      account = UserAccount.new
      account.email_address = record['email_address']
      account.username = record['username']
    accounts << account
    end
    return accounts
  end

  # finding one record with id as argument
  def find(id)
    sql = 'SELECT email_address, username FROM user_accounts WHERE id = $1;'
    params = [id]
    result = DatabaseConnection.exec_params(sql, params)
    record = result[0]
    account = UserAccount.new
    account.email_address = record['email_address']
    account.username = record['username']
    return account
  end

  # inserting a new record with instance of Post class as argument
  def create(user_account)
    sql = 'INSERT INTO user_accounts (email_address, username) VALUES ($1, $2);'
    params = [user_account.email_address, user_account.username]
    DatabaseConnection.exec_params(sql, params)
  end

  # deletes a record with id as argument
  def delete(id)
    sql = 'DELETE FROM user_accounts WHERE id = $1;'
    params = [id]
    DatabaseConnection.exec_params(sql, params)
  end

  # updates a record with instance of Post class as argument
  def update(user_account)
    sql = 'UPDATE user_accounts SET email_address = $1, username = $2;'
    params = [user_account.email_address, user_account.username]
    DatabaseConnection.exec_params(sql, params)
  end
end