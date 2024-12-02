CREATE TABLE music (
    title TEXT,
    artist VARCHAR(255), 
    album TEXT,
    count INT,
    rating NUMERIC,
    len INTERVAL
) PARTITION BY HASH (artist);

CREATE TABLE music0 PARTITION OF music
    FOR VALUES WITH (MODULUS 4, REMAINDER 0);

-- Create the second hash partition (remainder 1 of modulus 4)
CREATE TABLE music1 PARTITION OF music
    FOR VALUES WITH (MODULUS 4, REMAINDER 1);

-- Create the third hash partition (remainder 2 of modulus 4)
CREATE TABLE music2 PARTITION OF music
    FOR VALUES WITH (MODULUS 4, REMAINDER 2);

-- Create the fourth hash partition (remainder 3 of modulus 4)
CREATE TABLE music3 PARTITION OF music
    FOR VALUES WITH (MODULUS 4, REMAINDER 3);


\copy music (title, artist, album, count, rating, len) FROM 'library.csv' DELIMITER ',' CSV;


