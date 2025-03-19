/*// IS1. Profile of a person
:param personId: 10995116277794

MATCH (n:Person {id: $personId })-[:IS_LOCATED_IN]->(p:City)
RETURN
    n.firstName AS firstName,
    n.lastName AS lastName,
    n.birthday AS birthday,
    n.locationIP AS locationIP,
    n.browserUsed AS browserUsed,
    p.id AS cityId,
    n.gender AS gender,
    n.creationDate AS creationDate
    */


SELECT 
t.p_firstname
, t.p_lastname
, t.p_birthday
, t.p_location_ip
, t.p_browserused
, SPLIT(s.QUERY_NODE2_NAME,'_',1) as cityId
, t.p_gender
, t.p_creationdate
from
QUERY_GRAPH (
    GRAPH => 'ldbc.graph',
    QUERIES => INPUT_TABLES(
        (SELECT CONCAT('2199023268616','_p') as NODE_NAME),
        (SELECT 1 as HOP_ID, 'isLocatedIn' as EDGE_LABEL)
    ),
    RINGS => 1,
    OPTIONS => KV_PAIRS(
        force_undirected = 'true',
        find_common_labels = 'true'
    )
) as s
INNER JOIN ldbc.person as t
on s.QUERY_NODE1_NAME = CHAR64(CONCAT(t.p_personid,'_p')) -- Have to cast to CHAR64 for the join to work