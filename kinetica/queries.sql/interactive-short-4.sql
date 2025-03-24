--interactive-short-4.sql
select COALESCE(m_ps_imagefile,m_content) AS content, m_creationdate
from ldbc.messages_mv
where m_messageid = 3298541986358;