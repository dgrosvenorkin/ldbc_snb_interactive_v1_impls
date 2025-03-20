--interactive-short-5.sql
select p_personid, p_firstname, p_lastname
from ldbc.messages, ldbc.person
where m_messageid = 3298541986358 and Person_id = p_personid;