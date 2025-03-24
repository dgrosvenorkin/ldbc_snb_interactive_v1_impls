// IS5. Creator of a message
/*
:param messageId: 206158431836
 */
 /*
MATCH (m:Message {id:  $messageId })-[:HAS_CREATOR]->(p:Person)
RETURN
    p.id AS personId,
    p.firstName AS firstName,
    p.lastName AS lastName
*/

SELECT 
p.p_personid
,p.p_firstname
,p.p_lastname
FROM query_graph( graph => 'ldbc.graph', 
    queries => input_tables
    (
        (SELECT CONCAT('3298541986358','_m') as NODE_NAME)
        ,(SELECT 1 as HOP_ID, 'hasCreator' as EDGE_LABEL)
    ),
    rings => 1, options => kv_pairs(find_common_labels = 'true', result_table_index = '2') 
) s 
INNER JOIN ldbc.person p on s.QUERY_NODE_NAME_TARGET = CHAR64(CONCAT(p.p_personid,'_p')) 