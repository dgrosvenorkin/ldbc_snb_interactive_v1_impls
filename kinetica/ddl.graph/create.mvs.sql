create or replace materialized view ldbc.messages_test as (
    SELECT m_messageid, m_ps_imagefile, m_creationdate, m_location_ip, m_browserused, m_ps_language, m_content, m_length, 'post' as m_type
    FROM ldbc.post
    UNION ALL
    SELECT m_messageid, NULL, m_creationdate, m_locationip, m_browserused, NULL, m_content, m_length, 'comment' as m_type
    FROM ldbc.comment
)