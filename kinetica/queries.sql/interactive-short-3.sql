--interactive-short-3.sql
select p_personid, p_firstname, p_lastname, creationdate
from ldbc.person_knows_person pkp, ldbc.person_mv p
where pkp.Person_id_0 = 2199023268616 and Person_id_1 = p_personid
order by creationdate desc, p_personid asc;