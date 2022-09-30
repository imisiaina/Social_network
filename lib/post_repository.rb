require 'post.rb'

class PostRepository

  # Selecting all records
  # No arguments
  def all
    sql = 'SELECT title, contents, views, user_account_id FROM posts;'
    result_set = DatabaseConnection.exec_params(sql, [])
    
    posts = []
    
    result_set.each do |record|
      post = Post.new
      post.title = record['title']
      post.contents = record['contents']
      post.views = record['views']
      post.user_account_id = record['user_account_id']
    posts << post
    end
    return posts
  end

  # finding one record with id as argument
  def find(id)
    sql = 'SELECT * FROM posts WHERE id = $1;'
    params = [id]
    result = DatabaseConnection.exec_params(sql, params)
    record = result[0]
    post = Post.new
    post.title = record['title']
    post.contents = record['contents']
    post.views = record['views']
    post.user_account_id = record['user_account_id']
    return post
  end

  # inserting a new record with instance of Post class as argument
  def create(post)
    sql = 'INSERT INTO posts (title, contents, views, user_account_id) VALUES ($1, $2, $3, $4);'
    params = [post.title, post.contents, post.views, post.user_account_id]
    DatabaseConnection.exec_params(sql, params)
  end

  # deletes a record with id as argument
  def delete(id)
    sql = 'DELETE FROM posts WHERE id = $1;'
    params = [id]
    DatabaseConnection.exec_params(sql, params)
  end

  # updates a record with instance of Post class as argument
  def update(post)
    sql = 'UPDATE posts SET title = $1, contents = $2, views = $3;'
    params = [post.title, post.contents, post.views]
    DatabaseConnection.exec_params(sql, params)
  end
end