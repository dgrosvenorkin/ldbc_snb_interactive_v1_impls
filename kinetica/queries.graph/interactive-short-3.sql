// IS3. Friends of a person
/*
:param personId: 10995116277794
 */
 /*
MATCH (n:Person {id: $personId })-[r:KNOWS]-(friend)
RETURN
    friend.id AS personId,
    friend.firstName AS firstName,
    friend.lastName AS lastName,
    r.creationDate AS friendshipCreationDate
ORDER BY
    friendshipCreationDate DESC,
    toInteger(personId) ASC
*/

-- You wouldn't use graph for this query but here it is
SELECT 
p.p_personid
,p.p_firstname
,p.p_lastname
,pkp.creationdate
FROM query_graph( graph => 'ldbc.graph', 
    queries => input_tables
    (
        (SELECT CONCAT('2199023268616','_p') as NODE_NAME)
        ,(SELECT 1 as HOP_ID, 'knows' as EDGE_LABEL)
    ),
    rings => 1, options => kv_pairs(find_common_labels = 'true', result_table_index = '2') 
) s 
INNER JOIN ldbc.person p on s.QUERY_NODE_NAME_TARGET = CHAR64(CONCAT(p.p_personid,'_p')) 
INNER JOIN ldbc.person_knows_person pkp on (s.QUERY_NODE_NAME_SOURCE = CHAR64(CONCAT(pkp.Person_id_0,'_p')) 
    and s.QUERY_NODE_NAME_TARGET = CHAR64(CONCAT(pkp.Person_id_1,'_p')) )
ORDER by creationdate DESC, p.p_personid ASC