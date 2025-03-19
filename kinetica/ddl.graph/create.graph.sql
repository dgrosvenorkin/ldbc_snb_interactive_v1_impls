-- Create a directed graph from category,place,movement(label:gender,age),dma nodes - See View Schema button. The graph_table option can be commented out for large graphs
CREATE OR REPLACE DIRECTED GRAPH ldbc.graph(
    NODES => INPUT_TABLES(        
        (SELECT distinct pl_type AS LABEL,       'PLACE' AS LABEL_KEY from ldbc.place),
        (SELECT distinct o_type AS LABEL,        'ORG' AS LABEL_KEY from ldbc.organisation),
        (SELECT distinct p_gender AS LABEL,      'GENDER' AS LABEL_KEY from ldbc.person),
        (SELECT distinct p_browserused AS LABEL, 'BROWSER' AS LABEL_KEY from ldbc.person),
        (SELECT 'post:comment' AS LABEL,         'MESSAGE' AS LABEL_KEY),

        (SELECT CONCAT(pl_placeid,'_pl')      AS NAME, pl_type AS LABEL from ldbc.place),
        (SELECT CONCAT(o_organisationid,'_o') AS NAME, o_type AS LABEL from ldbc.organisation),
        (SELECT CONCAT(p_personid,'_p')       AS NAME, CONCAT(CONCAT(p_gender,':'),p_browserused) AS LABEL from ldbc.person),
        (SELECT distinct P_language           AS NAME, 'language' AS LABEL from ldbc.person_speaks_language),
        (SELECT CONCAT(m_messageid,'_m')      AS NAME, 'post' AS LABEL from ldbc.post),
        (SELECT CONCAT(m_messageid,'_m')      AS NAME, 'comment' AS LABEL from ldbc.comment)
    ),
    EDGES => INPUT_TABLES(
        (SELECT CONCAT(s.Place_id_0,'_pl') AS NODE1_NAME, CONCAT(s.Place_id_1,'_pl') AS NODE2_NAME, 'isPartOf' as LABEL --'place_isPartOf_place'  AS LABEL 
        from ldbc.place_isPartOf_place s )
        
        ,(SELECT CONCAT(Organisation_id,'_o') AS NODE1_NAME, CONCAT(Place_id,'_pl') AS NODE2_NAME, 'isLocatedIn'  AS LABEL  -- 'organisation_isLocatedIn_place'  AS LABEL 
        from ldbc.organisation_isLocatedIn_place )

        ,(SELECT CONCAT(Person_id,'_p') AS NODE1_NAME, CONCAT(Place_id,'_pl') AS NODE2_NAME, 'isLocatedIn'  AS LABEL --'person_isLocatedIn_place'  AS LABEL 
        from ldbc.person_isLocatedIn_place s)

        ,(SELECT CONCAT(Person_id,'_p') AS NODE1_NAME, CONCAT(Organization_id,'_o') AS NODE2_NAME, 'workAt'  AS LABEL --'person_workAt_organisation'  AS LABEL 
        from ldbc.person_workAt_organisation s)

        ,(SELECT CONCAT(Person_id,'_p') AS NODE1_NAME, CONCAT(Organization_id,'_o') AS NODE2_NAME, 'studyAt'  AS LABEL --'person_studyAt_organisation'  AS LABEL 
        from ldbc.person_studyAt_organisation s)

        ,(SELECT CONCAT(Person_id,'_p') AS NODE1_NAME, P_language AS NODE2_NAME, 'speaks'  AS LABEL --'person_speaks_language'  AS LABEL 
        from ldbc.person_speaks_language s)

        ,(SELECT CONCAT(Comment_id,'_m') AS NODE1_NAME, CONCAT(Place_id,'_pl') AS NODE2_NAME, 'isLocatedIn'  AS LABEL --'comment_isLocatedIn_place'  AS LABEL 
        from ldbc.comment_isLocatedIn_place) -- issue with this one

        ,(SELECT CONCAT(Post_id,'_m') AS NODE1_NAME, CONCAT(Place_id,'_pl') AS NODE2_NAME, 'isLocatedIn'  AS LABEL --'post_isLocatedIn_place'  AS LABEL 
        from ldbc.post_isLocatedIn_place)

        ,(SELECT CONCAT(Post_id,'_m') AS NODE1_NAME, CONCAT(Person_id,'_p') AS NODE2_NAME, 'hasCreator'  AS LABEL --'post_hasCreator_person'  AS LABEL 
        from ldbc.post_hasCreator_person)

        ,(SELECT CONCAT(Comment_id,'_m') AS NODE1_NAME, CONCAT(Person_id,'_p') AS NODE2_NAME, 'hasCreator'  AS LABEL --'comment_hasCreator_person'  AS LABEL 
        from ldbc.comment_hasCreator_person)

        ,(SELECT CONCAT(Person_id,'_p') AS NODE1_NAME, CONCAT(Post_id,'_m') AS NODE2_NAME, 'likes'  AS LABEL --'person_likes_post'  AS LABEL 
        from ldbc.person_likes_post)

        ,(SELECT CONCAT(Person_id,'_p') AS NODE1_NAME, CONCAT(Comment_id,'_m') AS NODE2_NAME, 'likes'  AS LABEL --'person_likes_comment'  AS LABEL 
        from ldbc.person_likes_comment)
    ),
    OPTIONS => KV_PAIRS( 
     label_delimiter      = ':' 
    --,graph_table          = 'ldbc.graph_table'
    ,allow_multiple_edges ='false'
    ,export_graph_schema  = 'true'
    ,schema_node_labelkeys = 'false'
    ,schema_edge_labelkeys = 'true'
    --,keep_derived_table = 'true'
    )
);