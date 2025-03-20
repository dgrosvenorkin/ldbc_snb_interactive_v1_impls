--interactive-short-1.sql
select p_firstname, p_lastname, p_birthday, p_location_ip, p_browserused, Place_id, p_gender,  p_creationdate
from ldbc.person_mv
where p_personid = 2199023268616;