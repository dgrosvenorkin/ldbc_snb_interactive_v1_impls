drop table if exists ldbc.post;
drop table if exists ldbc.comment;
drop table if exists ldbc.country;
drop table if exists ldbc.organisation;
drop table if exists ldbc.likes;
drop table if exists ldbc.tag;
drop table if exists ldbc.tagclass;
drop table if exists ldbc.message;
drop table if exists ldbc.forum;
drop table if exists ldbc.person;
drop table if exists ldbc.place;

--- Static
drop table if exists ldbc.organisation_isLocatedIn_place;
drop table if exists ldbc.place_isPartOf_place;
drop table if exists ldbc.tag_hasType_tagclass;
drop table if exists ldbc.tagclass_isSubclassOf_tagclass;

--- Dynamic
drop table if exists ldbc.comment_hasCreator_person;
drop table if exists ldbc.comment_hasTag_tag;
drop table if exists ldbc.comment_isLocatedIn_place;
drop table if exists ldbc.comment_replyOf_comment;
drop table if exists ldbc.comment_replyOf_post;
drop table if exists ldbc.forum_containerOf_post;
drop table if exists ldbc.forum_hasMember_person;
drop table if exists ldbc.forum_hasModerator_person;
drop table if exists ldbc.forum_hasTag_tag;
drop table if exists ldbc.person_email_emailaddress;
drop table if exists ldbc.person_hasInterest_tag;
drop table if exists ldbc.person_isLocatedIn_place;
drop table if exists ldbc.person_knows_person;
drop table if exists ldbc.person_likes_comment;
drop table if exists ldbc.person_likes_post;
drop table if exists ldbc.person_speaks_language;
drop table if exists ldbc.person_studyAt_organisation;
drop table if exists ldbc.person_workAt_organisation;
drop table if exists ldbc.post_hasCreator_person;
drop table if exists ldbc.post_hasTag_tag;
drop table if exists ldbc.post_isLocatedIn_place;


CREATE TABLE "ldbc"."tag"
(
    "t_tagid" SMALLINT (dict) NOT NULL,
    "t_name" VARCHAR (128, dict) NOT NULL,
    "t_url" VARCHAR (128, dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."tagclass"
(
    "tc_tagclassid" SMALLINT (dict) NOT NULL,
    "tc_name" VARCHAR (256) NOT NULL,
    "tc_url" VARCHAR (256) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."tagclass_isSubclassOf_tagclass"
(
    "TagClass_id_0" SMALLINT (dict) NOT NULL,
    "TagClass_id_1" SMALLINT (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."tag_hasType_tagclass"
(
    "Tag_id" SMALLINT (dict) NOT NULL,
    "TagClass_id" SMALLINT (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."comment"
(
    "m_messageid" BIGINT NOT NULL,
    "m_creationdate" TIMESTAMP NOT NULL,
    "m_locationip" IPV4 NOT NULL,
    "m_browserused" VARCHAR (32, dict) NOT NULL,
    "m_content" VARCHAR,
    "m_length" SMALLINT (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."comment_hasCreator_person"
(
    "Comment_id" BIGINT NOT NULL,
    "Person_id" BIGINT (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."comment_hasTag_tag"
(
    "Comment_id" BIGINT NOT NULL,
    "Tag_id" SMALLINT (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."comment_isLocatedIn_place"
(
    "Comment_id" BIGINT NOT NULL,
    "Place_id" INTEGER (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."comment_replyOf_comment"
(
    "Comment_id_0" BIGINT NOT NULL,
    "Comment_id_1" BIGINT NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."comment_replyOf_post"
(
    "Comment_id" BIGINT NOT NULL,
    "Post_id" BIGINT NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."forum"
(
    "f_forumid" BIGINT NOT NULL,
    "f_title" VARCHAR (128) NOT NULL,
    "f_creationdate" TIMESTAMP NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."forum_containerOf_post"
(
    "Forum_id" BIGINT NOT NULL,
    "Post_id" BIGINT NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."forum_hasMember_person"
(
    "Forum_id" BIGINT NOT NULL,
    "Person_id" BIGINT (dict) NOT NULL,
    "joinDate" TIMESTAMP NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."forum_hasModerator_person"
(
    "Forum_id" BIGINT NOT NULL,
    "Person_id" BIGINT (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."forum_hasTag_tag"
(
    "Forum_id" BIGINT NOT NULL,
    "Tag_id" SMALLINT (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."organisation"
(
    "o_organisationid" SMALLINT (dict) NOT NULL,
    "o_type" VARCHAR (16, dict) NOT NULL,
    "o_name" VARCHAR (128, dict) NOT NULL,
    "o_url" VARCHAR (256, dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."organisation_isLocatedIn_place"
(
    "Organisation_id" SMALLINT (dict) NOT NULL,
    "Place_id" SMALLINT (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."person"
(
    "p_personid" BIGINT (dict) NOT NULL,
    "p_firstname" VARCHAR (64, dict) NOT NULL,
    "p_lastname" VARCHAR (32, dict) NOT NULL,
    "p_gender" VARCHAR (8, dict) NOT NULL,
    "p_birthday" TIMESTAMP NOT NULL,
    "p_creationdate" TIMESTAMP NOT NULL,
    "p_location_ip" IPV4 NOT NULL,
    "p_browserused" VARCHAR (32, dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."person_email_emailaddress"
(
    "Person_id" BIGINT (dict) NOT NULL,
    "email" VARCHAR (64) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."person_hasInterest_tag"
(
    "Person_id" BIGINT (dict) NOT NULL,
    "Tag_id" SMALLINT (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."person_isLocatedIn_place"
(
    "Person_id" BIGINT (dict) NOT NULL,
    "Place_id" SMALLINT (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."person_knows_person"
(
    "Person_id_0" BIGINT (dict) NOT NULL,
    "Person_id_1" BIGINT (dict) NOT NULL,
    "creationDate" TIMESTAMP NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."person_likes_comment"
(
    "Person_id" BIGINT (dict) NOT NULL,
    "Comment_id" BIGINT NOT NULL,
    "creationDate" TIMESTAMP NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."person_likes_post"
(
    "Person_id" BIGINT (dict) NOT NULL,
    "Post_id" BIGINT NOT NULL,
    "creationDate" TIMESTAMP NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."person_speaks_language"
(
    "Person_id" BIGINT (dict) NOT NULL,
    "P_language" VARCHAR (2, dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."person_studyAt_organisation"
(
    "Person_id" BIGINT (dict) NOT NULL,
    "Organization_id" SMALLINT NOT NULL,
    "classYear" INTEGER (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."person_workAt_organisation"
(
    "Person_id" BIGINT (dict) NOT NULL,
    "Organization_id" SMALLINT NOT NULL,
    "workFrom" SMALLINT NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."place"
(
    "pl_placeid" SMALLINT (dict) NOT NULL,
    "pl_name" VARCHAR (128, dict) NOT NULL,
    "pl_url" VARCHAR (128, dict) NOT NULL,
    "pl_type" VARCHAR (16, dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."place_isPartOf_place"
(
    "Place_id_0" SMALLINT (dict) NOT NULL,
    "Place_id_1" SMALLINT (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."post"
(
    "m_messageid" BIGINT NOT NULL,
    "m_ps_imagefile" VARCHAR (32),
    "m_creationdate" TIMESTAMP NOT NULL,
    "m_location_ip" IPV4 NOT NULL,
    "m_browserused" VARCHAR (32, dict) NOT NULL,
    "m_ps_language" VARCHAR (2, dict),
    "m_content" VARCHAR,
    "m_length" SMALLINT (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."post_hasCreator_person"
(
    "Post_id" BIGINT NOT NULL,
    "Person_id" BIGINT (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."post_hasTag_tag"
(
    "Post_id" BIGINT NOT NULL,
    "Tag_id" SMALLINT (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);

CREATE TABLE "ldbc"."post_isLocatedIn_place"
(
    "Post_id" BIGINT NOT NULL,
    "Place_id" SMALLINT (dict) NOT NULL
)
TIER STRATEGY (
    ( ( VRAM 1, RAM 5, DISK0 5, PERSIST 5 ) )
);