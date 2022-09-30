require_relative '../lib/post_repository.rb'

def reset_posts_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

RSpec.describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  it 'gets all posts' do
    repo = PostRepository.new
    
    post = repo.all
    expect(post.length).to eq 2
    expect(post[0].title).to eq 'Post 1'
    expect(post[0].contents).to eq 'How are you?'
    expect(post[0].views).to eq '3'
    expect(post[0].user_account_id).to eq '1'
    expect(post[1].title).to eq 'Post 2'
    expect(post[1].contents).to eq 'What are you doing today?'
    expect(post[1].views).to eq '5'
    expect(post[1].user_account_id).to eq '1'
  end

  it 'returns an entry' do
    repo = PostRepository.new
    post = repo.all

    post = repo.find(1)
    expect(post.title).to eq 'Post 1'
    expect(post.contents).to eq 'How are you?'
    expect(post.views).to eq '3'
    expect(post.user_account_id).to eq '1'
  end

  it 'creates a new post' do
    repo = PostRepository.new
    new_post = Post.new
    new_post.title = 'Post 3'
    new_post.contents = 'Hi there!'
    new_post.views = '2'
    new_post.user_account_id = '1'
    repo.create(new_post)
    post = repo.find(3)
    expect(post.title).to eq 'Post 3'
    expect(post.contents).to eq 'Hi there!'
    expect(post.views).to eq '2'
    expect(post.user_account_id).to eq '1'
  end

  it 'deletes a post' do
    repo = PostRepository.new
    
    repo.delete(1)
    post = repo.all
    expect(post.length).to eq 1
  end

  it 'updates a record' do
    repo = PostRepository.new
    post = repo.find(1)
    post.title = 'Post one'
    post.contents = 'How are you today?'
    post.views = '4'
    repo.update(post)
    
    posts = repo.all
    expect(posts[0].title).to eq 'Post one'
    expect(posts[0].contents).to eq 'How are you today?'
    expect(posts[0].views).to eq '4'
    expect(posts[0].user_account_id).to eq '1'
  end
end
