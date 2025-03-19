-- IS2. Recent messages of a person
/*
:param personId: 10995116277795
 */
 /*
MATCH (:Person {id: $personId})<-[:HAS_CREATOR]-(message)
WITH
 message,
 message.id AS messageId,
 message.creationDate AS messageCreationDate
ORDER BY messageCreationDate DESC, messageId ASC
LIMIT 10
MATCH (message)-[:REPLY_OF*0..]->(post:Post),
      (post)-[:HAS_CREATOR]->(person)
RETURN
 messageId,
 coalesce(message.imageFile,message.content) AS messageContent,
 messageCreationDate,
 post.id AS postId,
 person.id AS personId,
 person.firstName AS personFirstName,
 person.lastName AS personLastName
ORDER BY messageCreationDate DESC, messageId ASC
*/


CREATE OR REPLACE TABLE ldbc._2_q1 as 
(
    SELECT s.*, m_creationdate
    FROM query_graph( graph => 'ldbc.graph', 
        queries => input_tables
        (
            (SELECT CONCAT('2199023268616','_p') as NODE_NAME)
            ,(SELECT -1 as HOP_ID, 'hasCreator' as EDGE_LABEL) -- use '-1' to go back one hop since hasCreator is a reverse edge from person to message
        ),
        rings => 1, options => kv_pairs(find_common_labels = 'true', result_table_index = '2') 
    ) s 
    INNER JOIN ldbc.messages as t
    on s.QUERY_NODE_NAME_TARGET = CHAR64(CONCAT(t.m_messageid,'_m')) 
    ORDER by m_creationdate DESC
    LIMIT 10
);
CREATE OR REPLACE TABLE ldbc._2_q2 as 
(
    /* KI_HINT_NO_PARALLEL_EXECUTION */ 
    SELECT *, QUERY_NODE_NAME_SOURCE as joinKey
    FROM query_graph ( graph => 'ldbc.graph', 
        queries => input_tables (
            (SELECT q1.QUERY_NODE_NAME_TARGET AS NODE_NAME FROM ldbc._2_q1 q1)
            ,(SELECT 1 AS HOP_ID, 'replyOf' AS EDGE_LABEL)
            ,(SELECT 2 AS HOP_ID, 'replyOf' AS EDGE_LABEL)
            ,(SELECT 3 AS HOP_ID, 'replyOf' AS EDGE_LABEL)
            ,(SELECT 4 AS HOP_ID, 'replyOf' AS EDGE_LABEL)
            ,(SELECT 5 AS HOP_ID, 'replyOf' AS EDGE_LABEL)
            ,(SELECT 6 AS HOP_ID, 'replyOf' AS EDGE_LABEL)
            ,(SELECT 7 AS HOP_ID, 'replyOf' AS EDGE_LABEL)
            ,(SELECT 8 AS HOP_ID, 'replyOf' AS EDGE_LABEL)
            ,(SELECT 9 AS HOP_ID, 'replyOf' AS EDGE_LABEL)
            ,(SELECT 10 AS HOP_ID, 'replyOf' AS EDGE_LABEL)
            ,(SELECT 'post' AS TARGET_NODE_LABEL)
        ),
        rings => 10, options => kv_pairs(find_common_labels = 'true', result_table_index = '2') 
    )
    UNION ALL
    -- Get all 0 hop post messages
    SELECT *, QUERY_NODE_NAME_TARGET as joinKey
    FROM query_graph ( graph => 'ldbc.graph', 
        queries => input_tables (
            (SELECT q1.QUERY_NODE_NAME_TARGET AS NODE_NAME FROM ldbc._2_q1 q1)
        ),
        rings => 0, options => kv_pairs(find_common_labels = 'true', result_table_index = '2') 
    )
    WHERE LABELS = 'post'
);
CREATE OR REPLACE TABLE ldbc._2_q3 as 
(
    SELECT DISTINCT *
    FROM query_graph ( graph => 'ldbc.graph', 
        queries => input_tables (
            (SELECT q2.QUERY_NODE_NAME_TARGET AS NODE_NAME FROM ldbc._2_q2 q2)
            ,(SELECT 1 AS HOP_ID, 'hasCreator' AS EDGE_LABEL)
        ),
        rings => 1, options => kv_pairs(find_common_labels = 'true', result_table_index = '2') 
    ) s
); 

-- Do this to force replication in later steps
CREATE OR REPLACE Materialized view ldbc._2_q4mv as (
    SELECT 
    p.p_personid
    ,p.p_firstname
    ,p.p_lastname
    ,q2.joinkey
FROM ldbc._2_q2 q2
INNER JOIN ldbc._2_q3 q3 ON q2.QUERY_NODE_NAME_TARGET = q3.QUERY_NODE_NAME_SOURCE
INNER JOIN ldbc.person p on q3.QUERY_NODE_NAME_TARGET = p.p_personid
);

-- Do this to force replication in later steps
CREATE OR REPLACE Materialized view ldbc._2_q5mv as (
    SELECT 
    m2.m_messageid
    ,coalesce(m2.m_content,m2.m_ps_imagefile) as m_content
    ,m2.m_creationdate
    ,p_personid
    ,p_firstname
    ,p_lastname
FROM ldbc._2_q4mv _2_q4mv
INNER JOIN ldbc.messages m2 on _2_q4mv.joinkey = CHAR64(CONCAT(m2.m_messageid,'_m'))
);

SELECT 
    _2_q5mv.m_messageid
    ,_2_q5mv.m_content
    ,_2_q5mv.m_creationdate
    ,m3.m_messageid as postid
    ,_2_q5mv.p_personid
    ,_2_q5mv.p_firstname
    ,_2_q5mv.p_lastname
FROM ldbc.messages m3
INNER JOIN ldbc._2_q5mv _2_q5mv ON m3.m_messageid = _2_q5mv.m_messageid
ORDER BY m_creationdate DESC, m_messageid DESC