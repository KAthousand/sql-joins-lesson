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

\copy artists FROM './spotify/data/artist.csv' WITH (FORMAT csv); 
\copy albums FROM './spotify/data/album.csv' WITH (FORMAT csv); 
\copy tracks FROM './spotify/data/track.csv' WITH (FORMAT csv);
