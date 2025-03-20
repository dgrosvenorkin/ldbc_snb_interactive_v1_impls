// IS4. Content of a message
/*
:param messageId: 206158431836
 */
 /*
MATCH (m:Message {id:  $messageId })
RETURN
    m.creationDate as messageCreationDate,
    coalesce(m.content, m.imageFile) as messageContent
*/

-- You wouldn't use graph for this query but here it is
SELECT 
m.m_creationdate
,coalesce(m.m_content,m.m_ps_imagefile) as m_content
FROM query_graph( graph => 'ldbc.graph', 
    queries => input_tables
    (
        (SELECT CONCAT('3298541986358','_m') as NODE_NAME)
        ,(SELECT 'message' as EDGE_LABEL)
    ),
    rings => 0, options => kv_pairs(find_common_labels = 'true', result_table_index = '2') 
) s 
INNER JOIN ldbc.messages m on s.QUERY_NODE_NAME_TARGET = CHAR64(CONCAT(m.m_messageid,'_m')) 