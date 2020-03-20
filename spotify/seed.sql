DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS spotify_users;
DROP TABLE IF EXISTS tracks;
DROP TABLE IF EXISTS albums;
DROP TABLE IF EXISTS artists;

CREATE TABLE artists(
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255)
);


CREATE TABLE albums(
  name VARCHAR(255),
  label VARCHAR(255),
  id VARCHAR(255) PRIMARY KEY
);

CREATE TABLE tracks(
  name VARCHAR(255),
  artist_id VARCHAR(255) REFERENCES artists(id),
  album_id VARCHAR(255) REFERENCES albums(id),
  disc_number INTEGER,
  popularity INTEGER,
  id VARCHAR(255) PRIMARY KEY
);

CREATE TABLE spotify_users(
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE likes(
  user_id SERIAL REFERENCES spotify_users(id),
  tracks_id VARCHAR(255) REFERENCES tracks(id),
  confirmed BOOLEAN DEFAULT FALSE
);

\copy artists FROM './data/artist.csv' WITH (FORMAT csv); 
\copy albums FROM './data/album.csv' WITH (FORMAT csv); 
\copy tracks FROM './data/track.csv' WITH (FORMAT csv);
