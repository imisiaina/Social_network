Social Media Model and Repository Classes Design Recipe

1. Design and create the Table

As a social network user,
So I can have my information registered,
I'd like to have a user account with my email address.

As a social network user,
So I can have my information registered,
I'd like to have a user account with my username.

As a social network user,
So I can write on my timeline,
I'd like to create posts associated with my user account.

As a social network user,
So I can write on my timeline,
I'd like each of my posts to have a title and a content.

As a social network user,
So I can know who reads my posts,
I'd like each of my posts to have a number of views.

nouns: user_account, email_address, username, posts, title, content, views

   |    Record	  |        Properties       |
---+--------------+-------------------------+---
   | user_account | email_address, username |
---+--------------+-------------------------+---
   |     post     |  title, content, views  |

Name of the first table (always plural): user_accounts

Column names: email_address, username

Name of the second table (always plural): posts

Column names: title, contents, views

-- Remember to always have the primary key id as a first column. Its type will always be SERIAL.

Table: user_accounts
id: SERIAL
email_address: text
username: text

Table: posts
id: SERIAL
title: text
contents: text
views: int

Can one POSTS have many USER_ACCOUNTS? No
Can one USER_ACCOUNTS have many POSTS? Yes
-- You'll then be able to say that:

USER_ACCOUNTS has many POSTS
And on the other side, POSTS belongs to USER_ACCOUNTS

In that case, the foreign key is in the table POSTS

file: social_network_tables.sql

-- -- Replace the table name, columm names and types.

-- -- Create the table without the foreign key first.
CREATE TABLE user_accounts (
  id SERIAL PRIMARY KEY,
  email_address text,
  username text
  );

-- -- Then the table with the foreign key first.
CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title text,
  contents text,
  views int,
  user_account_id int,
  
  constraint fk_post foreign key(user_account_id) references 
  user_accounts(id) 
  on delete cascade
  );

psql -h 127.0.0.1 social_network < social_network_tables.sql


2. Create Test SQL seeds

(file: spec/seeds.sql)

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE posts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO posts (title, content, views, user_accounts_id) VALUES ('Post 1', 'How are you?', '3', '1');
INSERT INTO posts (title, content, views, user_accounts_id) VALUES ('Post 2', 'What are you doing today?', '5', '1');
Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

psql -h 127.0.0.1 social_network < seeds.sql

3. Define the class names

Table name: posts

Model class # (in lib/post.rb)

class Post
end

Repository class # (in lib/post_repository.rb)

class PostRepository
end

Table name: user_accounts

Model class # (in lib/user_account.rb)

class UserAccount
end

Repository class # (in lib/user_account_repository.rb)

class UserAccountRepository
end

4. Implement the Model class
Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

Table name: posts

Model class # (in lib/posts.rb)

class Post

  attr_accessor :id, :title, :contents, :views, :user_account_id
end

Table name: user_accounts

Model class # (in lib/user_account.rb)

class UserAccount

  attr_accessor :id, :email_address, :username
end


5. Define the Repository Class interface
Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

Table name: user_accounts

# Repository class (in lib/user_account_repository.rb)

class UserAccountRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT email_address, username FROM user_accounts;

    # Returns an array of user_account objects.
  end

  # finding one record with id as argument
  def find(id)
    # Executes the SQL query:
    # SELECT email_address, username FROM user_accounts WHERE id = $1;

    # Returns a single user_account object.
  end

  # inserting a new record with instance of Post class as argument
  def create(user_account)
    # Executes the SQL query:
    # INSERT INTO user_accounts (email_address, username) VALUES ($1, $2)
    # Returns nothing.
  end

  # deletes a record with id as argument
  def delete(id)
    # Executes the SQL query:
    # DELETE FROM user_accounts WHERE id = $1
    # Returns nothing.
  end

  # updates a record with instance of Post class as argument
  def update(user_account)
    # Executes the SQL query:
    # UPDATE user_accounts SET email_address = $1, username = $2
    # Returns nothing.
  end
end

Table name: posts

# Repository class (in lib/post_repository.rb)

class PostRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT title, contents, views, user_account_id FROM posts;

    # Returns an array of Post objects.
  end

  # finding one record with id as argument
  def find(id)
    # Executes the SQL query:
    # SELECT title, contents, views, user_account_id FROM posts WHERE id = $1;

    # Returns a single Post object.
  end

  # inserting a new record with instance of Post class as argument
  def create(post)
    # Executes the SQL query:
    # INSERT INTO posts (title, contents, views, user_account_id) VALUES ($1, $2, $3, $4)
    # Returns nothing.
  end

  # deletes a record with id as argument
  def delete(id)
    # Executes the SQL query:
    # DELETE FROM posts WHERE id = $1
    # Returns nothing.
  end

  # updates a record with instance of Post class as argument
  def update(post)
    # Executes the SQL query:
    # UPDATE posts SET title = $1, contents = $2, views = $3, user_account_id = $4
    # Returns nothing.
  end
end

6. Write Test Examples
Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

# 1
# Get all user accounts

repo = UserAccountRepository.new

user_account = repo.all
user_account.length # =>  1
user_account.first.email_address # =>  'name@email.com'
user_account.first.username # => 'Miles'

# 2
# Find an account

repo = UserAccountRepository.new

user_account = repo.find(1)
user_account.email_address # =>  'name@email.com'
user_account.username # => 'Miles'

# 3
# Create a new account

repo = UserAccountRepository.new
new_account = UserAccount.new
new_account.email_address = 'name1@hotmail.com'
new_account.username = 'Alexander'
    
repo.create(new_account) # => nil

user_accounts = repo.all
last_account = user_accounts.last
last_account.email_address # => 'name1@hotmail.com'
last_account.username # => 'Alexander'

# 4
# Delete an account

repo = UserAccountRepository.new
repo.delete(1)
user_accounts = repo.all
first_account = user_account.first
first_account.email_address # => 'name1@hotmail.com'
first_account.username # => 'Alexander'

# 5
# Update an account
repo = UserAccountRepository.new

user_account = repo.find(1)
user_account.email_address = 'surname@email.co.uk'
user_account.username = 'Bob'
repo.update(user_account.email_address)
repo.update(user_account.username)

accounts = repo.all
first_account = accounts.first
first_account.email_address # => 'surname@email.co.uk'
first_account.username # => 'Bob'

# 6
# Get all posts

repo = PostRepository.new

post = repo.all
post.length # =>  2
post.first.title # =>  'Post 1'
post.first.contents # => 'How are you'
post.first.views # => '3'
post.first.user_account_id # => '1'
post.last.title # =>  'Post 2'
post.last.contents # => 'What are you doing today?'
post.last.views # => '5'
post.last.user_account_id # => '1'


# 7
# Find a post

repo = PostRepository.new

post = repo.find(1)
post.title # =>  'Post 1'
post.contents # => 'How are you?'
post.views # => '3'
post.user_account_id # => '1'

# 8
# Create a new post

repo = PostRepository.new
new_post = Post.new
new_post.title = 'Post 3'
new_post.contents = 'Hi there!'
new_post.views = '2'
new_post.user_account_id = '1'
    
repo.create(new_post) # => nil

posts = repo.all
last_post = posts.last
last_post.title # => 'Post 3'
last_post.contents # => 'Hi there!'
last_post.views # => '2'
last_post.user_account_id # => '1'

# 9
# Delete a post

repo = PostRepository.new
repo.delete(1)
posts = repo.all
first_post = posts.first
first_post.title # =>  'Post 2'
first_post.contents # => 'What are you doing today?'
first_post.views # => '5'
first_post.user_account_id # => '1'

# 10
# Update a post
repo = PostRepository.new

post = repo.find(1)
post.title = 'Post one'
post.contents = 'How are you today?'
post.views = '4'
post.user_account_id = '1'
repo.update(post.title)
repo.update(post.contents)
repo.update(post.views)
repo.update(post.user_account_id)

posts = repo.all
first_post = posts.first
first_post.title # => 'Post one'
first_post.contents # => 'How are you today?'
first_post.views # => '4'
first_post.user_account_id # => '1'

7. Reload the SQL seeds before each test run
Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

# file: spec/post_repository_spec.rb

def reset_posts_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

# file: spec/user_account_repository_spec.rb

def reset_user_accounts_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe UserAccountRepository do
  before(:each) do 
    reset_user_accounts_table
  end

  # (your tests will go here).
end


8. Test-drive and implement the Repository class behaviour
After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour.