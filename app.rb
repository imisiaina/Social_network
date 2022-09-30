require_relative 'lib/database_connection'
require_relative 'lib/???.rb'
require_relative 'lib/???_repository.rb'

DatabaseConnection.connect('social_network')

artist_repository = ArtistRepository.new
artist_repository.all.each do |artist|
  p artist
end

album_repository = AlbumRepository.new
album_repository.all.each do |album|
  p album
end

repository = AlbumRepository.new
album = Album.new
album.title = 'Trompe le Monde'
album.release_year = 1991
album.artist_id = 1
repository.create(album)
all_albums = repository.all
p all_albums