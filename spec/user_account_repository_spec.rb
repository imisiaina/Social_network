require_relative '../lib/user_account_repository.rb'

def reset_user_accounts_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end
  
RSpec.describe UserAccountRepository do
  before(:each) do 
    reset_user_accounts_table
  end

  it 'gets all user accounts' do
    repo = UserAccountRepository.new
    user_account = repo.all
    expect(user_account.length).to eq 1
    expect(user_account.first.email_address).to eq 'name@email.com'
    expect(user_account.first.username).to eq 'Miles'
  end

  it 'finds an account' do
    repo = UserAccountRepository.new
    user_account = repo.find(1)
    expect(user_account.email_address).to eq 'name@email.com'
    expect(user_account.username).to eq 'Miles'
  end

  it 'creates a new account' do 
    repo = UserAccountRepository.new
    new_account = UserAccount.new
    new_account.email_address = 'name1@hotmail.com'
    new_account.username = 'Alexander'

    repo.create(new_account)
    
    user_accounts = repo.all
    last_account = user_accounts.last
    expect(last_account.email_address).to eq 'name1@hotmail.com'
    expect(last_account.username).to eq 'Alexander'
  end

  it 'deletes an account' do
    repo = UserAccountRepository.new
    repo.delete(1)
    user_accounts = repo.all
    expect(user_accounts.length).to eq 0
  end

  it 'updates an account' do
    repo = UserAccountRepository.new
    
    user_account = repo.find(1)
    user_account.email_address = 'surname@email.co.uk'
    user_account.username = 'Bob'
    repo.update(user_account)
  
    accounts = repo.all
    expect(accounts[0].email_address).to eq 'surname@email.co.uk'
    expect(accounts[0].username).to eq 'Bob'
  end
end

