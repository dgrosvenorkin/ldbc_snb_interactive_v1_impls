--interactive-short-2.sql 
with recursive 
p_messages AS (
	  select m_messageid, m_content, m_ps_imagefile, m_creationdate, m_c_replyof, Person_id
	  from ldbc.messages_mv
	  where Person_id = 2199023268616
	  order by m_creationdate desc
	  limit 10
), parent_post(postid, replyof, orig_postid, creator)  as (
  select m_messageid, m_c_replyof, m_messageid, Person_id from p_messages
  UNION ALL
  select m_messageid, m_c_replyof, orig_postid, Person_id
    from ldbc.messages_mv, parent_post
    where m_messageid = replyof
)
SELECT 
    p1.m_messageid
    ,coalesce(p1.m_content,p1.m_ps_imagefile) as m_content
    ,p1.m_creationdate
    ,p2.m_messageid as postid
    ,p2.Person_id
    ,p_firstname
    ,p_lastname
FROM (SELECT * from p_messages) p1
LEFT JOIN 
  (select orig_postid, postid as m_messageid, Person_id, p_firstname, p_lastname
      from parent_post, ldbc.person_mv
      where replyof is null and creator = Person_id
  ) p2
on p2.orig_postid = p1.m_messageid
order by m_creationdate desc, p2.m_messageid desc;