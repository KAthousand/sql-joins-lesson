## Further Lab

- first clone the entire sql-joins repository.
- Navigate to `spotify`
- In your terminal, create a new sql database with: `createdb musicdb`
- Fill that database with data by entering the following command in the terminal: `psql -d musicdb -f seed.sql`
- Take a look at the `seed.sql` file in this repository and observe the tables, column names, and their relationships.
- Enter `psql` in the terminal so you can start interacting with this new database.

Using `SELECT` statements, do the following:
- Find all songs released on albums from the `Interscope` label
- Find all of Beyoncé's tracks
- Find all of the disc numbers only for Beyonce's tracks
- Find all of the names of Beyoncé's albums
- Find all of the album names, track names, and artist id associated with Beyoncé
- Find all songs released on `Virgin Records` that have a `popularity` score > 30

Bonus:
- Find the artist who has released tracks on the most albums
>Hint: The last few may need more than one `join` clause each
