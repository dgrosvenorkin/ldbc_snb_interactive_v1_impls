create or replace materialized view ldbc.person_mv as (
    select * from 
    ldbc.person p 
    INNER JOIN 
    ldbc.person_isLocatedIn_place pip on p.p_personid = pip.Person_id
    LEFT JOIN 
    ldbc.person_studyAt_organisation pso on p.p_personid = pso.Person_id
);

create or replace materialized view ldbc.comment_mv as (
    select * from 
    ldbc.comment c
    INNER JOIN 
    ldbc.comment_hasCreator_person chp on c.m_messageid = chp.Comment_id
    INNER JOIN 
    ldbc.comment_isLocatedIn_place cip on c.m_messageid = cip.Comment_id
    INNER JOIN 
    ldbc.comment_replyOf_comment crc on c.m_messageid = crc.Comment_id_0
    INNER JOIN 
    ldbc.comment_replyOf_post crp on c.m_messageid = crp.Comment_id
);

create or replace materialized view ldbc.post_mv as (
    select * from 
    ldbc.post p
    INNER JOIN 
    ldbc.post_hasCreator_person php on p.m_messageid = php.Post_id
    INNER JOIN 
    ldbc.post_isLocatedIn_place pip on p.m_messageid = pip.Post_id
    INNER JOIN 
    ldbc.forum_containerOf_post fcp on p.m_messageid = fcp.Post_id
);

create or replace materialized view ldbc.forum_mv as (
    select * from 
    ldbc.forum f
    INNER JOIN 
    ldbc.forum_hasModerator_person fhp on f.f_forumid = fhp.Forum_id
);

create or replace materialized view ldbc.tag_mv as (
    select * from 
    ldbc.tag t
    INNER JOIN 
    ldbc.tag_hasType_tagclass tht on t.t_tagid = tht.Tag_id
);

create or replace materialized view ldbc.organization_mv as (
    select * from 
    ldbc.organisation  o
    INNER JOIN 
    ldbc.organisation_isLocatedIn_place oip on o.organisationid = oip.Organisation_id
);

/*
create or replace materialized view ldbc.place_mv as (
    select * from 
    ldbc.place p
    INNER JOIN 
    ldbc.place_isPartOf_place pip on p.pl_placeid = pip.
);
*/

create or replace materialized view ldbc.messages as (
    SELECT m_messageid, m_ps_imagefile, m_creationdate, m_location_ip, m_browserused, m_ps_language, m_content, m_length, Person_id, Place_id as Place_id, Forum_id, NULL AS m_c_replyof, 'post' as m_type
    FROM ldbc.post_mv
    UNION ALL
    SELECT m_messageid, NULL, m_creationdate, m_locationip, m_browserused, NULL, m_content, m_length, Person_id, Place_id, NULl, coalesce(Comment_id_1, Post_id), 'comment' as m_type
    FROM ldbc.comment_mv
)