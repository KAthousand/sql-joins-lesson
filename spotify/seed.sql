DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS spotify_user;
DROP TABLE IF EXISTS track;
DROP TABLE IF EXISTS album;
DROP TABLE IF EXISTS artist;

CREATE TABLE artist(
  artist_id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255)
);


CREATE TABLE album(
  name VARCHAR(255),
  label VARCHAR(255),
  album_id VARCHAR(255) PRIMARY KEY
);

CREATE TABLE track(
  name VARCHAR(255),
  artist_id VARCHAR(255) REFERENCES artist(artist_id),
  album_id VARCHAR(255) REFERENCES album(album_id),
  disc_number INTEGER,
  popularity INTEGER,
  track_id VARCHAR(255) PRIMARY KEY
);

CREATE TABLE spotify_user(
  spotify_user_id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE likes(
  user_id SERIAL REFERENCES spotify_user(spotify_user_id),
  track_id VARCHAR(255) REFERENCES track(track_id),
  confirmed BOOLEAN DEFAULT FALSE
);

\copy artist FROM './data/artist.csv' WITH (FORMAT csv); 
\copy album FROM './data/album.csv' WITH (FORMAT csv); 
\copy track FROM './data/track.csv' WITH (FORMAT csv); 
