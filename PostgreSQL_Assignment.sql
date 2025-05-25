-- rangers Table

CREATE TABLE rangers (
    ranger_id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    region VARCHAR(255) NOT NULL
);

SELECT * from rangers;

DROP TABLE rangers;


INSERT INTO rangers (name, region)
VALUES
    ('Alice Green', 'Northern Hills'),
    ('Bob White', 'River Delta'),
    ('Carol King', 'Mountain Range');




-- species Table

CREATE TABLE species (
    species_id SERIAL NOT NULL PRIMARY KEY,
    common_name VARCHAR(255) NOT NULL UNIQUE,
    scientific_name VARCHAR(255) NOT NULL UNIQUE,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(255) NOT NULL
);

SELECT * from species;

DROP TABLE species;


INSERT INTO species
(common_name, scientific_name, discovery_date, conservation_status)
VALUES
    ('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
    ('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
    ('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
    ('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');




-- sightings Table

CREATE TABLE sightings (
    sighting_id SERIAL NOT NULL PRIMARY KEY,
    ranger_id INTEGER NOT NULL REFERENCES rangers (ranger_id),
    species_id INTEGER NOT NULL REFERENCES species (species_id),
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(255) NOT NULL,
    notes TEXT
);

SELECT * from sightings;

DROP TABLE sightings;

INSERT INTO sightings
(species_id, ranger_id, location, sighting_time, notes)
VALUES
    (1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
    (2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
    (3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
    (1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', null);




-- Problem 1
INSERT INTO rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

-- Problem 2
select count(DISTINCT species_id) from sightings;


-- Problem 3
select * from sightings
WHERE location LIKE '%Pass%';

-- Problem 4
select name, count(*) as total_sightings
from rangers
JOIN sightings ON rangers.ranger_id = sightings.ranger_id
GROUP BY name;


-- Problem 5
SELECT common_name
from species
WHERE NOT EXISTS (
    SELECT * from sightings
    WHERE sightings.species_id = species.species_id 
);


-- Problem 6
SELECT common_name, sighting_time, name 
from (SELECT * from sightings ORDER BY sighting_time DESC LIMIT 2) AS RecentTwoSightings
JOIN species ON species.species_id = RecentTwoSightings.species_id
JOIN rangers ON rangers.ranger_id = RecentTwoSightings.ranger_id;


-- Problem 7
UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';


-- Problem 8
SELECT sighting_id,
CASE 
    WHEN extract(hour from sighting_time) < 12 THEN 'Morning'  
    WHEN extract(hour from sighting_time) > 17 THEN 'Evening'  
    ELSE  'Afternoon'
END AS time_of_day
from sightings;


-- Problem 9
DELETE from rangers
WHERE ranger_id
NOT IN (SELECT ranger_id from sightings);
