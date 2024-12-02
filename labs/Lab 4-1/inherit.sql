
CREATE TABLE cities (
	name		text,
	population	float8,
	elevation	int		-- (in ft)
);

CREATE TABLE capitals (
	state		char(2)
) INHERITS (cities);

INSERT INTO cities VALUES ('San Francisco', 7.24E+5, 63);
INSERT INTO cities VALUES ('Las Vegas', 2.583E+5, 2174);
INSERT INTO cities VALUES ('Mariposa', 1200, 1953);

INSERT INTO capitals VALUES ('Sacramento', 3.694E+5, 30, 'CA');
INSERT INTO capitals VALUES ('Madison', 1.913E+5, 845, 'WI');

