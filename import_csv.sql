CREATE TABLE games_2014 (
    name             text NOT NULL,
    developer        text,
    publisher        text,
    release_date     text,
    mode             text,
    box_art_url	     text
);


COPY games_2014 FROM '/home/colson/Documents/scripts/2014-Games/games_2014.csv' CSV HEADER;
