# ![](https://ga-dash.s3.amazonaws.com/production/assets/logo-9f88ae6c9c3871690e33280fcf557f33.png)  SOFTWARE ENGINEERING IMMERSIVE

# Relationships in SQL / SQL JOINs

![](./images/xkcd.png)

## Learning Objectives

- Discuss different types of table relationships.
- Create tables with foreign key references.
- Discuss and create join tables.
- Insert rows in join tables.
- Select data using join tables.


## Introduction

While it is conceivable to store all of the data that is needed for a particular domain model object or resource in a single table, there are numerous downsides to such an approach.  For example, in a `students database`, let's say we had a column called "teacher_name". If the students got a new teacher, we would have to update every single row in that column.   

Further, there are weak guarantees for the consistency and correctness of hard-coded fields in a single column. If we're hard-coding every row, what happens if your developer makes a few minor spelling mistakes or miscapitalizations? Suddenly the data would become incredibly difficult to search. 

Leveraging table relations can improve `data integrity` and provide stronger guarantees regarding the consistency and correctness of what we store and retrieve from a database.

<hr>

One of the key features of relational databases is that they can represent
relationships between rows in different tables.

We'll focus on two types of relationships: **one-to-many** and **many-to-many**. Let's think of some examples of each:
- One to many
- Many to many

<hr>


Let's use Spotify to imagine this in the real world. We could start out with two tables, `artists` and `tracks`.
Our goal now is to somehow indicate the relationship between an artist and a track.
In this case, that relationship indicates who performed the track.

You can imagine that we'd like to use this information in a number of ways, such as...
- Getting the artist information for a given track
- Getting all tracks performed by a given artist
- Searching for tracks based on attributes of the artist (e.g., all tracks
  performed by artists at Interscope)
  
#### What kind of relationship do we see between artist and track?

## JOINS

### First Step:

First thing we need is a database to work in. We can do this with in PSQL like this:

```sql
CREATE DATABASE spotify_db;
```

-or-

There is a shorthand command that we can do outside of `psql` directly in our bash command line:

```bash
createdb spotify_db
```

### Building it from the ground up
Let's build out our Spotify database, starting with artist, album, and track.
Note how id's are PRIMARY KEYs, and relationships are established when these
ids are referenced by other tables.

```sql
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
  artist_id VARCHAR(255),
  album_id VARCHAR(255),
  disc_number INTEGER,
  popularity INTEGER,
  id VARCHAR(255) PRIMARY KEY
);
```

> We have setup some data for our new tables. You can run this file the bash commands `psql -d spotify_db -f ./spotify/seed.sql`

Using simple `SELECT` statements, if we wanted to find all songs by `Beyonce` we would have to execute to queries, e.g.:

```sql
SELECT * FROM artists
WHERE name LIKE 'Beyonc%';

           id           |  name
------------------------+---------
 6vWDO969PvNqNYHIOW5v0m | Beyoncé
(1 row)
```

And then copy + paste the artists.id into a `SELECT` query `FROM` the `track` table:

```sql
SELECT name FROM tracks
WHERE artist_id = '6vWDO969PvNqNYHIOW5v0m';

                       name
--------------------------------------------------
 Video Phone - Extended Remix featuring Lady Gaga
 Crazy In Love
 Drunk in Love
 ***Flawless
 Video Phone
(5 rows)
```
We can see that the tables we are `SELECT`ing `FROM` are the exact tables defined in the db schema.  As will be shown below, SQL does not confine the user to simply querying data from individual tables.  

It is possible, at least from a user interface perspective, to stitch together two tables along a common column such that the table to be queried from looks more like the following:

```sql
SELECT * FROM artists
JOIN tracks ON tracks.artist_id = artists.id
LIMIT 3;

           id           |     name      |            name            |       artist_id        |        album_id        | disc_number | popularity |           id
------------------------+---------------+----------------------------+------------------------+------------------------+-------------+------------+------------------------
 3HCpwNmFp2rvjkdjTs4uxs | Kyuss         | Demon Cleaner              | 3HCpwNmFp2rvjkdjTs4uxs | 1npen0QK3TNxZd2hLNzzOj |           1 |         52 | 2cVphsi72OjF7s0rtt2z5e
 1hCkSJcXREhrodeIHQdav8 | Ramin Djawadi | This World                 | 1hCkSJcXREhrodeIHQdav8 | 2poAUFGkHetMzM4xzLBVhY |           1 |         52 | 41otw6RUcMhVgO1LDOLmFX
 2gCsNOpiBaMNh20jQ5prf0 | Buddy Guy     | Baby Please Dont Leave Me  | 2gCsNOpiBaMNh20jQ5prf0 | 7bkjnyiMG8mXzmEyfY49wD |           1 |         45 | 7JECM65zNFrYIHdvxj8NbO
```

> hint: If the formatting in your terminal is wonky, you can try `\x` to turn on or off "expanded display"

How is this possible?

To `SELECT` information on two or more tables at ones, we can use a `JOIN` clause.
This will produce rows that contain information from both tables. When joining
two or more tables, we have to tell the database how to match up the rows.
(e.g. to make sure the author information is correct for each book).

This is done using the `ON` clause, which specifies which properties to match.

```sql
SELECT artists.name, tracks.name FROM artists
JOIN tracks ON tracks.artist_id = artists.id
WHERE artists.name LIKE 'Beyonc%';

  name   |                       name
---------+--------------------------------------------------
 Beyoncé | Video Phone - Extended Remix featuring Lady Gaga
 Beyoncé | Crazy In Love
 Beyoncé | Drunk in Love
 Beyoncé | ***Flawless
 Beyoncé | Video Phone
(5 rows)
```

**Notice that now we should include the table name for each column.**
In some cases this isn't necessary where SQL can disambiguate the columns
between the various tables, but it makes parsing the statement much easier
when table names are explicitly included.

Also, our select items can be more varied now and include either all or
just some of the columns from the associated tables.

```sql
SELECT * FROM artists
JOIN tracks ON tracks.artist_id = artists.id
WHERE artists.name LIKE 'Beyonc%';

-[ RECORD 1 ]-------------------------------------------------
id          | 6vWDO969PvNqNYHIOW5v0m
name        | Beyoncé
name        | Video Phone - Extended Remix featuring Lady Gaga
artist_id   | 6vWDO969PvNqNYHIOW5v0m
album_id    | 1wuC0jj7341uFOuCyqzwe8
disc_number | 1
popularity  | 53
id          | 2nX9948PslVYrrHUf6w0eL
-[ RECORD 2 ]-------------------------------------------------
id          | 6vWDO969PvNqNYHIOW5v0m
name        | Beyoncé
name        | Crazy In Love
artist_id   | 6vWDO969PvNqNYHIOW5v0m
album_id    | 6oxVabMIqCMJRYN1GqR3Vf
disc_number | 1
popularity  | 80
id          | 5IVuqXILoxVWvWEPm82Jxr
-[ RECORD 3 ]-------------------------------------------------
id          | 6vWDO969PvNqNYHIOW5v0m
name        | Beyoncé
name        | Drunk in Love
artist_id   | 6vWDO969PvNqNYHIOW5v0m
album_id    | 2UJwKSBUz6rtW4QLK74kQu
disc_number | 1
popularity  | 77
id          | 6jG2YzhxptolDzLHTGLt7S
-[ RECORD 4 ]-------------------------------------------------
id          | 6vWDO969PvNqNYHIOW5v0m
name        | Beyoncé
name        | ***Flawless
artist_id   | 6vWDO969PvNqNYHIOW5v0m
album_id    | 2UJwKSBUz6rtW4QLK74kQu
disc_number | 1
popularity  | 68
id          | 7tefUew2RUuSAqHyegMoY1
-[ RECORD 5 ]-------------------------------------------------
id          | 6vWDO969PvNqNYHIOW5v0m
name        | Beyoncé
name        | Video Phone
artist_id   | 6vWDO969PvNqNYHIOW5v0m
album_id    | 23Y5wdyP5byMFktZf8AcWU
disc_number | 2
popularity  | 55
id          | 53hNzjDClsnsdYpLIwqXvn
```

### We Do:

Let's write out a SQL query that will return the names of the top 10 tracks and their artist's name.

### What could go wrong?
There are no explicit checks to ensure that we're actually obeying these references. If a developer accidentally typed an invalid id number while inserting data, they wouldn't even realize a mistake was made.

### Solution: Foreign Keys
To remedy this problem, we can instruct the database to ensure that the relationships
between tables are valid, and that new records cannot be inserted that break these
constraints.  In other words, the `referential integrity` of our data is maintained.

By using the `REFERENCES` keyword, foreign key constraints can be added to the schema.

```SQL
CREATE TABLE tracks(
  name VARCHAR(255),
  artist_id VARCHAR(255) REFERENCES artists(id),
  album_id VARCHAR(255) REFERENCES albums(id),
  disc_number INTEGER,
  popularity INTEGER,
  id VARCHAR(255) PRIMARY KEY
);
```

After adding references, postgresql will now reject insert/update/delete queries that violate the consistency of the define relationships, viz., a track can't be added that has an invalid artist_id.

Note: `\d+` and a table name displays a helpful view of the structure of a table along with
its relationships and constraints.

### Multi-Joins

`JOIN` statements can also be linked together to query data across several tables.

```sql
SELECT albums.name
FROM albums
JOIN tracks ON tracks.album_id = albums.id
JOIN artists ON tracks.artist_id = artists.id
WHERE artists.name LIKE 'Beyonc%';

name
--------------------------------------
I AM...SASHA FIERCE THE BONUS TRACKS
Dangerously In Love
BEYONCÉ [Platinum Edition]
BEYONCÉ [Platinum Edition]
I AM...SASHA FIERCE
```

## Join tables > Many-to-Many Relations
You can make a table that is specifically and only used to join two other tables and create a many-to-many relationship. We call these "Join Tables". They typically consist of at minimum, two foreign keys and possibly other metadata. For example, if we added users and likes to our Spotify database, we don't need to know more about "likes" than its relationships to other tables:

```SQL
CREATE TABLE spotify_users(
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE likes(
  user_id SERIAL REFERENCES spotify_users(id),
  track_id VARCHAR(255) REFERENCES tracks(id)
);
```

## AS

Also, `AS` can be used to give more descriptive names to the values returned
by join clauses. Check the results of the following two select statements and notice how much clearer the results of the second statement are.

Without `AS`:

```sql
SELECT artists.name, tracks.name
FROM artists
JOIN tracks ON artists.id = tracks.artist_id
WHERE artists.name LIKE 'Beyonc%';
```

With `AS`:

```sql
SELECT artists.name AS artist_name, tracks.name AS track_name
FROM artists
JOIN tracks ON artists.id = tracks.artist_id
WHERE artists.name LIKE 'Beyonc%';
```

### We Do:

Let's try to get the artist's name, track's name, album's name and label for everything under the label "Rhino/Elektra". We should also alias the columns to make the response more clear.

# Further Practice
>Side Note: Having trouble with `null` values? Try [psql coalesce](http://www.postgresqltutorial.com/postgresql-coalesce/)
- [SQL for Beginners](https://www.codewars.com/collections/sql-for-beginners/): Created by WDI14 graduate and current GA instructor Mike Nabil.
- [SQL Zoo](https://sqlzoo.net/)
- [Code School Try SQL](https://www.codeschool.com/courses/try-sql)
- [W3 Schools SQL tutorial](https://www.w3schools.com/sql/)
- [Postgres Guide](http://postgresguide.com/)
- [SQL Course](http://www.sqlcourse.com/)
