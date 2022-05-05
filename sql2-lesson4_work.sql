CREATE OR REPLACE VIEW `city_region_country` AS
select
 ci.id AS 'ID',
 ci.country_id AS 'country ID',
 ci.region_id AS 'region ID',
 ci.important AS ' is capital',
 ci.title AS city,
 co.title AS country,
 re.title AS region
from _cities ci
	left join _countries co ON ci.country_id = co.id
    left join _regions re ON ci.region_id = re.id
;