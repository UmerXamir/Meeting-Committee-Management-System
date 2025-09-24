/*
 Navicat Premium Data Transfer

 Source Server         : tapal-local-host
 Source Server Type    : PostgreSQL
 Source Server Version : 170006 (170006)
 Source Host           : localhost:5432
 Source Catalog        : postgres
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 170006 (170006)
 File Encoding         : 65001

 Date: 24/09/2025 17:58:12
*/


-- ----------------------------
-- Type structure for agenda_item_status
-- ----------------------------
DROP TYPE IF EXISTS "public"."agenda_item_status";
CREATE TYPE "public"."agenda_item_status" AS ENUM (
  'draft',
  'in_review',
  'finalized',
  'removed'
);
ALTER TYPE "public"."agenda_item_status" OWNER TO "postgres";

-- ----------------------------
-- Type structure for gtrgm
-- ----------------------------
DROP TYPE IF EXISTS "public"."gtrgm";
CREATE TYPE "public"."gtrgm" (
  INPUT = "public"."gtrgm_in",
  OUTPUT = "public"."gtrgm_out",
  INTERNALLENGTH = VARIABLE,
  CATEGORY = U,
  DELIMITER = ','
);
ALTER TYPE "public"."gtrgm" OWNER TO "postgres";

-- ----------------------------
-- Type structure for meeting_status
-- ----------------------------
DROP TYPE IF EXISTS "public"."meeting_status";
CREATE TYPE "public"."meeting_status" AS ENUM (
  'draft',
  'scheduled',
  'completed',
  'cancelled'
);
ALTER TYPE "public"."meeting_status" OWNER TO "postgres";

-- ----------------------------
-- Type structure for priority_enum
-- ----------------------------
DROP TYPE IF EXISTS "public"."priority_enum";
CREATE TYPE "public"."priority_enum" AS ENUM (
  'low',
  'medium',
  'high'
);
ALTER TYPE "public"."priority_enum" OWNER TO "postgres";

-- ----------------------------
-- Type structure for role_enum
-- ----------------------------
DROP TYPE IF EXISTS "public"."role_enum";
CREATE TYPE "public"."role_enum" AS ENUM (
  'system_admin',
  'company_secretary',
  'board_member',
  'committee_member',
  'observer',
  'guest'
);
ALTER TYPE "public"."role_enum" OWNER TO "postgres";

-- ----------------------------
-- Type structure for rsvp_status
-- ----------------------------
DROP TYPE IF EXISTS "public"."rsvp_status";
CREATE TYPE "public"."rsvp_status" AS ENUM (
  'pending',
  'accepted',
  'declined',
  'tentative',
  'attended',
  'absent'
);
ALTER TYPE "public"."rsvp_status" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for meeting_actions_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."meeting_actions_id_seq";
CREATE SEQUENCE "public"."meeting_actions_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for action_items
-- ----------------------------
DROP TABLE IF EXISTS "public"."action_items";
CREATE TABLE "public"."action_items" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "meeting_id" uuid,
  "agenda_item_id" uuid,
  "description" text COLLATE "pg_catalog"."default" NOT NULL,
  "assigned_to" uuid,
  "due_date" date,
  "status" text COLLATE "pg_catalog"."default" DEFAULT 'open'::text,
  "created_at" timestamptz(6) NOT NULL DEFAULT now(),
  "closed_at" timestamptz(6)
)
;

-- ----------------------------
-- Records of action_items
-- ----------------------------

-- ----------------------------
-- Table structure for agenda_item_versions
-- ----------------------------
DROP TABLE IF EXISTS "public"."agenda_item_versions";
CREATE TABLE "public"."agenda_item_versions" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "agenda_item_id" uuid NOT NULL,
  "version_num" int4 NOT NULL,
  "title" text COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "metadata" jsonb,
  "created_by" uuid,
  "created_at" timestamptz(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of agenda_item_versions
-- ----------------------------

-- ----------------------------
-- Table structure for agenda_item_workflow
-- ----------------------------
DROP TABLE IF EXISTS "public"."agenda_item_workflow";
CREATE TABLE "public"."agenda_item_workflow" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "agenda_item_id" uuid NOT NULL,
  "from_status" varchar(20) COLLATE "pg_catalog"."default",
  "to_status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "changed_by" uuid,
  "change_reason" text COLLATE "pg_catalog"."default",
  "changed_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Records of agenda_item_workflow
-- ----------------------------

-- ----------------------------
-- Table structure for agenda_items
-- ----------------------------
DROP TABLE IF EXISTS "public"."agenda_items";
CREATE TABLE "public"."agenda_items" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "meeting_id" uuid,
  "committee_id" uuid NOT NULL,
  "proposer_id" uuid NOT NULL,
  "title" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "status" varchar(24) COLLATE "pg_catalog"."default" NOT NULL,
  "priority" varchar(20) COLLATE "pg_catalog"."default",
  "estimated_minutes" int4,
  "created_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "document_tsv" tsvector,
  "department_id" uuid,
  "version" int4 NOT NULL DEFAULT 1,
  "reviewer_notes" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of agenda_items
-- ----------------------------
INSERT INTO "public"."agenda_items" VALUES ('8de4166a-ced4-409e-a203-1746c96beacb', '19274aa2-52b1-490f-9147-27fddde118b6', '3762b809-b6b2-4762-ad04-f462f3f110d1', 'c25cdac9-8bfa-4056-aa51-f2e470b8abbb', 'Agenda 1', 'description', 'draft', 'High', 15, '2025-09-17 16:38:59.98686', '2025-09-17 16:38:59.986861', NULL, 'cd30d1b0-cb1e-42bb-a543-0a55bccad17e', 1, NULL);
INSERT INTO "public"."agenda_items" VALUES ('b7589543-26cd-4a06-934c-a8c9cfc9d885', '49fbbedd-0290-4345-a64c-6b1a9544e7ed', '3762b809-b6b2-4762-ad04-f462f3f110d1', 'be782e82-93da-46e6-96ad-da981a134736', 'Agenda with comments and votes', 'desc', 'draft', 'High', 10, '2025-09-23 14:35:18.337771', '2025-09-23 14:35:18.337771', NULL, 'cd30d1b0-cb1e-42bb-a543-0a55bccad17e', 1, NULL);

-- ----------------------------
-- Table structure for agenda_versions
-- ----------------------------
DROP TABLE IF EXISTS "public"."agenda_versions";
CREATE TABLE "public"."agenda_versions" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "meeting_id" uuid NOT NULL,
  "finalized_by" uuid,
  "finalized_at" timestamptz(6) NOT NULL DEFAULT now(),
  "agenda_snapshot" jsonb NOT NULL,
  "notes" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of agenda_versions
-- ----------------------------

-- ----------------------------
-- Table structure for agenda_workflow
-- ----------------------------
DROP TABLE IF EXISTS "public"."agenda_workflow";
CREATE TABLE "public"."agenda_workflow" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "agenda_item_id" uuid NOT NULL,
  "from_status" varchar(24) COLLATE "pg_catalog"."default",
  "to_status" varchar(24) COLLATE "pg_catalog"."default" NOT NULL,
  "changed_by" uuid,
  "comment" text COLLATE "pg_catalog"."default",
  "changed_at" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Records of agenda_workflow
-- ----------------------------

-- ----------------------------
-- Table structure for attachments
-- ----------------------------
DROP TABLE IF EXISTS "public"."attachments";
CREATE TABLE "public"."attachments" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "agenda_item_id" uuid,
  "filename" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "file_url" text COLLATE "pg_catalog"."default" NOT NULL,
  "checksum" varchar(255) COLLATE "pg_catalog"."default",
  "uploaded_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "version" int4 DEFAULT 1,
  "is_current" bool DEFAULT true,
  "uploaded_by" uuid,
  "content_type" text COLLATE "pg_catalog"."default",
  "size" int8
)
;

-- ----------------------------
-- Records of attachments
-- ----------------------------
INSERT INTO "public"."attachments" VALUES ('43a48486-e704-47e4-97a4-db89015839c0', '8de4166a-ced4-409e-a203-1746c96beacb', 'MIS Standard Observation Report_export_1755088388394.xlsx', '/Uploads/MIS Standard Observation Report_export_1755088388394.xlsx', NULL, '2025-09-23 11:47:56.232299', 1, 't', '79bc4d69-28a6-4813-ba21-7ed1f2c94fab', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 16304);

-- ----------------------------
-- Table structure for audit_logs
-- ----------------------------
DROP TABLE IF EXISTS "public"."audit_logs";
CREATE TABLE "public"."audit_logs" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "user_id" uuid,
  "action" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "entity_type" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "entity_id" uuid NOT NULL,
  "timestamp" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "details" jsonb
)
;

-- ----------------------------
-- Records of audit_logs
-- ----------------------------

-- ----------------------------
-- Table structure for comments
-- ----------------------------
DROP TABLE IF EXISTS "public"."comments";
CREATE TABLE "public"."comments" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "agenda_item_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "text" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "parent_id" uuid
)
;

-- ----------------------------
-- Records of comments
-- ----------------------------
INSERT INTO "public"."comments" VALUES ('15e0bd4c-d5be-46df-8264-38d9a7a2a965', 'b7589543-26cd-4a06-934c-a8c9cfc9d885', 'be782e82-93da-46e6-96ad-da981a134736', 'Umer', '2025-09-23 14:35:18.338115', NULL);

-- ----------------------------
-- Table structure for committee_members
-- ----------------------------
DROP TABLE IF EXISTS "public"."committee_members";
CREATE TABLE "public"."committee_members" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "committee_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "role_in_committee" varchar(100) COLLATE "pg_catalog"."default",
  "added_at" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Records of committee_members
-- ----------------------------
INSERT INTO "public"."committee_members" VALUES ('01993e63-ba24-76f0-8938-6ddc1bc29e15', '881f69ac-6dfa-4028-8dc0-54c914053cd6', 'f156ad1e-f51d-44c7-82a3-6e99f333dadf', NULL, '2025-09-12 19:45:47.172142');
INSERT INTO "public"."committee_members" VALUES ('01993e63-ba2b-764b-a6fd-fae4cdf8b388', '881f69ac-6dfa-4028-8dc0-54c914053cd6', '598b86cc-caee-4f70-8431-56d4cebe8772', NULL, '2025-09-12 19:45:47.179293');
INSERT INTO "public"."committee_members" VALUES ('01995686-dff4-7f98-8921-4c160ca6a546', '3762b809-b6b2-4762-ad04-f462f3f110d1', 'f156ad1e-f51d-44c7-82a3-6e99f333dadf', NULL, '2025-09-17 12:15:03.786895');
INSERT INTO "public"."committee_members" VALUES ('01995686-e09d-7d60-bd88-e46ab26659c2', '3762b809-b6b2-4762-ad04-f462f3f110d1', '598b86cc-caee-4f70-8431-56d4cebe8772', NULL, '2025-09-17 12:15:03.962911');
INSERT INTO "public"."committee_members" VALUES ('01995689-9e54-77ec-b945-f38355e16c2c', '3762b809-b6b2-4762-ad04-f462f3f110d1', 'c25cdac9-8bfa-4056-aa51-f2e470b8abbb', NULL, '2025-09-17 12:18:03.604259');

-- ----------------------------
-- Table structure for committees
-- ----------------------------
DROP TABLE IF EXISTS "public"."committees";
CREATE TABLE "public"."committees" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "created_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Records of committees
-- ----------------------------
INSERT INTO "public"."committees" VALUES ('881f69ac-6dfa-4028-8dc0-54c914053cd6', 'Tapal Committee no 1', 'Umer creating this committee for testing purpose', '2025-09-12 19:17:30.821393');
INSERT INTO "public"."committees" VALUES ('3762b809-b6b2-4762-ad04-f462f3f110d1', 'Committtee 2', '3 members', '2025-09-17 12:13:04.325814');

-- ----------------------------
-- Table structure for department_users
-- ----------------------------
DROP TABLE IF EXISTS "public"."department_users";
CREATE TABLE "public"."department_users" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "department_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "role_in_dept" text COLLATE "pg_catalog"."default" DEFAULT 'coordinator'::text
)
;

-- ----------------------------
-- Records of department_users
-- ----------------------------
INSERT INTO "public"."department_users" VALUES ('01993e81-f788-75b9-8e10-9018e7e338fb', 'cd30d1b0-cb1e-42bb-a543-0a55bccad17e', '5c92c600-1a8e-44f0-9ef4-c5dbc23b2463', 'coordinator');
INSERT INTO "public"."department_users" VALUES ('01993e81-f7a7-70e0-a53e-c06b2e5bdf50', 'cd30d1b0-cb1e-42bb-a543-0a55bccad17e', 'c25cdac9-8bfa-4056-aa51-f2e470b8abbb', 'coordinator');

-- ----------------------------
-- Table structure for departments
-- ----------------------------
DROP TABLE IF EXISTS "public"."departments";
CREATE TABLE "public"."departments" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" text COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "created_at" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Records of departments
-- ----------------------------
INSERT INTO "public"."departments" VALUES ('cd30d1b0-cb1e-42bb-a543-0a55bccad17e', 'Security', 'Test', '2025-09-12 19:17:30.821393');
INSERT INTO "public"."departments" VALUES ('8935e9ad-7492-4fef-a76c-281aa6aa2e1e', 'Test department', 'testing', '2025-09-15 17:29:36.582673');

-- ----------------------------
-- Table structure for meeting_actions
-- ----------------------------
DROP TABLE IF EXISTS "public"."meeting_actions";
CREATE TABLE "public"."meeting_actions" (
  "id" int4 NOT NULL DEFAULT nextval('meeting_actions_id_seq'::regclass),
  "meeting_id" uuid,
  "agenda_item_id" uuid,
  "title" text COLLATE "pg_catalog"."default" NOT NULL,
  "owner_id" uuid,
  "due_date" date,
  "status" text COLLATE "pg_catalog"."default" DEFAULT 'pending'::text,
  "created_at" timestamp(6) DEFAULT now(),
  "updated_at" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Records of meeting_actions
-- ----------------------------

-- ----------------------------
-- Table structure for meeting_attendance
-- ----------------------------
DROP TABLE IF EXISTS "public"."meeting_attendance";
CREATE TABLE "public"."meeting_attendance" (
  "meeting_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "attended" bool
)
;

-- ----------------------------
-- Records of meeting_attendance
-- ----------------------------

-- ----------------------------
-- Table structure for meeting_attendees
-- ----------------------------
DROP TABLE IF EXISTS "public"."meeting_attendees";
CREATE TABLE "public"."meeting_attendees" (
  "id" uuid NOT NULL,
  "meeting_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "rsvp" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "rsvp_at" timestamptz(6),
  "attended" bool DEFAULT false,
  "attended_at" timestamptz(6),
  "role_in_meeting" text COLLATE "pg_catalog"."default",
  "created_at" timestamptz(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of meeting_attendees
-- ----------------------------
INSERT INTO "public"."meeting_attendees" VALUES ('79b1134d-1fb8-4d5d-aefc-5c8f6b1ac877', '2c5a31a9-7b3e-4615-b90f-9cb601de178e', 'f156ad1e-f51d-44c7-82a3-6e99f333dadf', 'pending', NULL, 'f', NULL, 'participant', '2025-09-15 19:28:51.360273+05');
INSERT INTO "public"."meeting_attendees" VALUES ('cd8502d3-5dc5-4e0a-97b8-7b67cee9b236', '2c5a31a9-7b3e-4615-b90f-9cb601de178e', '598b86cc-caee-4f70-8431-56d4cebe8772', 'pending', NULL, 'f', NULL, 'participant', '2025-09-15 19:28:51.360273+05');
INSERT INTO "public"."meeting_attendees" VALUES ('d76cad04-c6f9-4195-a1bf-d23babb4e78f', '49fbbedd-0290-4345-a64c-6b1a9544e7ed', 'f156ad1e-f51d-44c7-82a3-6e99f333dadf', 'pending', NULL, 'f', NULL, NULL, '2025-09-17 12:16:08.593461+05');
INSERT INTO "public"."meeting_attendees" VALUES ('fc010ed7-52ad-4215-ba51-07bf07298e17', '49fbbedd-0290-4345-a64c-6b1a9544e7ed', '598b86cc-caee-4f70-8431-56d4cebe8772', 'pending', NULL, 'f', NULL, NULL, '2025-09-17 12:16:08.593461+05');
INSERT INTO "public"."meeting_attendees" VALUES ('2d4f0d89-b047-4ab5-a644-3a802a47d491', '19274aa2-52b1-490f-9147-27fddde118b6', '598b86cc-caee-4f70-8431-56d4cebe8772', 'pending', NULL, 'f', NULL, NULL, '2025-09-17 12:18:18.78651+05');
INSERT INTO "public"."meeting_attendees" VALUES ('4f289ef8-ff3c-49f7-aaa3-c609479b0be8', '19274aa2-52b1-490f-9147-27fddde118b6', 'c25cdac9-8bfa-4056-aa51-f2e470b8abbb', 'pending', NULL, 'f', NULL, NULL, '2025-09-17 12:18:18.78651+05');
INSERT INTO "public"."meeting_attendees" VALUES ('e53d989a-d594-437d-9524-281765756a8f', '19274aa2-52b1-490f-9147-27fddde118b6', 'f156ad1e-f51d-44c7-82a3-6e99f333dadf', 'pending', NULL, 'f', NULL, NULL, '2025-09-17 12:18:18.78651+05');

-- ----------------------------
-- Table structure for meeting_minutes
-- ----------------------------
DROP TABLE IF EXISTS "public"."meeting_minutes";
CREATE TABLE "public"."meeting_minutes" (
  "id" uuid NOT NULL,
  "meetingid" uuid NOT NULL,
  "body_md" text COLLATE "pg_catalog"."default",
  "approved_by" uuid,
  "approved_at" timestamp(6)
)
;

-- ----------------------------
-- Records of meeting_minutes
-- ----------------------------

-- ----------------------------
-- Table structure for meeting_rsvps
-- ----------------------------
DROP TABLE IF EXISTS "public"."meeting_rsvps";
CREATE TABLE "public"."meeting_rsvps" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "meeting_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "responded_at" timestamp(6)
)
;

-- ----------------------------
-- Records of meeting_rsvps
-- ----------------------------

-- ----------------------------
-- Table structure for meetings
-- ----------------------------
DROP TABLE IF EXISTS "public"."meetings";
CREATE TABLE "public"."meetings" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "committee_id" uuid NOT NULL,
  "organizer_id" uuid NOT NULL,
  "title" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "start_time" timestamp(6) NOT NULL,
  "end_time" timestamp(6),
  "location" text COLLATE "pg_catalog"."default",
  "virtual_link" text COLLATE "pg_catalog"."default",
  "status" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "agenda_deadline" timestamp(6)
)
;

-- ----------------------------
-- Records of meetings
-- ----------------------------
INSERT INTO "public"."meetings" VALUES ('2c5a31a9-7b3e-4615-b90f-9cb601de178e', '881f69ac-6dfa-4028-8dc0-54c914053cd6', '00000000-0000-0000-0000-000000000000', 'Meeting created by umer', '2025-09-15 18:45:06.828', '2025-09-15 18:45:06.828', 'string', NULL, 'minutes_in_review', '2025-09-15 18:55:33.786322', '2025-09-15 18:55:33.788841', '2025-09-15 18:45:06.828');
INSERT INTO "public"."meetings" VALUES ('49fbbedd-0290-4345-a64c-6b1a9544e7ed', '3762b809-b6b2-4762-ad04-f462f3f110d1', '00000000-0000-0000-0000-000000000000', 'Meeting with committee 2', '2025-09-17 12:12:03.196', '2025-09-25 12:12:03.196', 'karwan', NULL, 'draft', '2025-09-17 12:16:08.41586', '2025-09-17 12:16:08.593461', '2025-09-30 12:12:03.196');
INSERT INTO "public"."meetings" VALUES ('19274aa2-52b1-490f-9147-27fddde118b6', '3762b809-b6b2-4762-ad04-f462f3f110d1', '00000000-0000-0000-0000-000000000000', 'Meeting with committee 2', '2025-09-17 12:12:03.196', '2025-09-25 12:12:03.196', 'karwan', NULL, 'draft', '2025-09-17 12:18:18.783498', '2025-09-17 12:18:18.78651', '2025-09-30 12:12:03.196');

-- ----------------------------
-- Table structure for memberships
-- ----------------------------
DROP TABLE IF EXISTS "public"."memberships";
CREATE TABLE "public"."memberships" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "user_id" uuid NOT NULL,
  "committee_id" uuid NOT NULL,
  "role_in_committee" text COLLATE "pg_catalog"."default",
  "is_active" bool NOT NULL DEFAULT true,
  "created_at" timestamptz(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of memberships
-- ----------------------------

-- ----------------------------
-- Table structure for minutes
-- ----------------------------
DROP TABLE IF EXISTS "public"."minutes";
CREATE TABLE "public"."minutes" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "meeting_id" uuid NOT NULL,
  "created_by" uuid,
  "content" text COLLATE "pg_catalog"."default",
  "created_at" timestamptz(6) NOT NULL DEFAULT now(),
  "updated_at" timestamptz(6)
)
;

-- ----------------------------
-- Records of minutes
-- ----------------------------

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS "public"."roles";
CREATE TABLE "public"."roles" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of roles
-- ----------------------------
INSERT INTO "public"."roles" VALUES ('35b11ae9-8a14-484f-a76b-8784b5286787', 'system_admin', 'Full system access');
INSERT INTO "public"."roles" VALUES ('6874d6e4-2f9d-4090-8f1d-e1578e7e142e', 'company_secretary', 'Committee/meeting organizer');
INSERT INTO "public"."roles" VALUES ('33a632d0-26b3-497e-a2aa-8ddb43444aa8', 'member', 'Committee member');
INSERT INTO "public"."roles" VALUES ('45ac19ec-9479-4781-a9dc-2049c344a245', 'observer', 'Guest user');

-- ----------------------------
-- Table structure for user_roles
-- ----------------------------
DROP TABLE IF EXISTS "public"."user_roles";
CREATE TABLE "public"."user_roles" (
  "user_id" uuid NOT NULL,
  "role_id" uuid NOT NULL
)
;

-- ----------------------------
-- Records of user_roles
-- ----------------------------
INSERT INTO "public"."user_roles" VALUES ('c25cdac9-8bfa-4056-aa51-f2e470b8abbb', '45ac19ec-9479-4781-a9dc-2049c344a245');
INSERT INTO "public"."user_roles" VALUES ('be782e82-93da-46e6-96ad-da981a134736', '35b11ae9-8a14-484f-a76b-8784b5286787');
INSERT INTO "public"."user_roles" VALUES ('c25cdac9-8bfa-4056-aa51-f2e470b8abbb', '33a632d0-26b3-497e-a2aa-8ddb43444aa8');
INSERT INTO "public"."user_roles" VALUES ('be782e82-93da-46e6-96ad-da981a134736', '45ac19ec-9479-4781-a9dc-2049c344a245');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS "public"."users";
CREATE TABLE "public"."users" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "email" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "password_hash" text COLLATE "pg_catalog"."default" NOT NULL,
  "role_id" uuid,
  "created_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO "public"."users" VALUES ('f156ad1e-f51d-44c7-82a3-6e99f333dadf', 'Secretary', 'Secretary@tapal.com', 'D631KkWAz+u5nmEWITmvPTpkA8HTa4PklityHRyMvQs=', NULL, '2025-09-12 03:32:13.030424', '2025-09-12 03:32:13.030424');
INSERT INTO "public"."users" VALUES ('598b86cc-caee-4f70-8431-56d4cebe8772', 'Coordinator', 'Coordinator@tapal.com', 'D631KkWAz+u5nmEWITmvPTpkA8HTa4PklityHRyMvQs=', NULL, '2025-09-12 03:32:35.977612', '2025-09-12 03:32:35.977612');
INSERT INTO "public"."users" VALUES ('5c92c600-1a8e-44f0-9ef4-c5dbc23b2463', 'Guest User', 'guest@tapal.com', 'D631KkWAz+u5nmEWITmvPTpkA8HTa4PklityHRyMvQs=', NULL, '2025-09-12 03:32:46.788967', '2025-09-12 03:32:46.788967');
INSERT INTO "public"."users" VALUES ('be782e82-93da-46e6-96ad-da981a134736', 'Admin', 'admin@tapal.com', '0fadf52a4580cfebb99e61162139af3d3a6403c1d36b83e4962b721d1c8cbd0b', NULL, '2025-09-12 03:31:52.599022', '2025-09-12 03:31:52.599022');
INSERT INTO "public"."users" VALUES ('79bc4d69-28a6-4813-ba21-7ed1f2c94fab', 'umer@tapal.com', 'umer@tapal.com', '0fadf52a4580cfebb99e61162139af3d3a6403c1d36b83e4962b721d1c8cbd0b', NULL, '2025-09-15 13:54:38.020902', '2025-09-15 13:54:38.020902');
INSERT INTO "public"."users" VALUES ('c25cdac9-8bfa-4056-aa51-f2e470b8abbb', 'admin', 'Committee@tapal.com', 'D631KkWAz+u5nmEWITmvPTpkA8HTa4PklityHRyMvQs=', NULL, '2025-09-12 03:32:27.987064', '2025-09-12 03:32:27.987064');

-- ----------------------------
-- Table structure for votes
-- ----------------------------
DROP TABLE IF EXISTS "public"."votes";
CREATE TABLE "public"."votes" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "agenda_item_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "vote_value" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "voted_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Records of votes
-- ----------------------------
INSERT INTO "public"."votes" VALUES ('10f3de6d-3483-45dc-a78c-1cf01a6b4071', 'b7589543-26cd-4a06-934c-a8c9cfc9d885', 'be782e82-93da-46e6-96ad-da981a134736', 'string', '2025-09-23 14:35:18.338029');

-- ----------------------------
-- Function structure for armor
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."armor"(bytea, _text, _text);
CREATE OR REPLACE FUNCTION "public"."armor"(bytea, _text, _text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pg_armor'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for armor
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."armor"(bytea);
CREATE OR REPLACE FUNCTION "public"."armor"(bytea)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pg_armor'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for crypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."crypt"(text, text);
CREATE OR REPLACE FUNCTION "public"."crypt"(text, text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pg_crypt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for dearmor
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."dearmor"(text);
CREATE OR REPLACE FUNCTION "public"."dearmor"(text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_dearmor'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for decrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."decrypt"(bytea, bytea, text);
CREATE OR REPLACE FUNCTION "public"."decrypt"(bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_decrypt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for decrypt_iv
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."decrypt_iv"(bytea, bytea, bytea, text);
CREATE OR REPLACE FUNCTION "public"."decrypt_iv"(bytea, bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_decrypt_iv'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for digest
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."digest"(text, text);
CREATE OR REPLACE FUNCTION "public"."digest"(text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_digest'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for digest
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."digest"(bytea, text);
CREATE OR REPLACE FUNCTION "public"."digest"(bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_digest'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for encrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."encrypt"(bytea, bytea, text);
CREATE OR REPLACE FUNCTION "public"."encrypt"(bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_encrypt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for encrypt_iv
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."encrypt_iv"(bytea, bytea, bytea, text);
CREATE OR REPLACE FUNCTION "public"."encrypt_iv"(bytea, bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_encrypt_iv'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gen_random_bytes
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gen_random_bytes"(int4);
CREATE OR REPLACE FUNCTION "public"."gen_random_bytes"(int4)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_random_bytes'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gen_random_uuid
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gen_random_uuid"();
CREATE OR REPLACE FUNCTION "public"."gen_random_uuid"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/pgcrypto', 'pg_random_uuid'
  LANGUAGE c VOLATILE
  COST 1;

-- ----------------------------
-- Function structure for gen_salt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gen_salt"(text, int4);
CREATE OR REPLACE FUNCTION "public"."gen_salt"(text, int4)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pg_gen_salt_rounds'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gen_salt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gen_salt"(text);
CREATE OR REPLACE FUNCTION "public"."gen_salt"(text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pg_gen_salt'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_btree_consistent
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_btree_consistent"(internal, int2, anyelement, int4, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_btree_consistent"(internal, int2, anyelement, int4, internal, internal)
  RETURNS "pg_catalog"."bool" AS '$libdir/btree_gin', 'gin_btree_consistent'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_anyenum
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_anyenum"(anyenum, anyenum, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_anyenum"(anyenum, anyenum, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_anyenum'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_bit
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_bit"(bit, bit, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_bit"(bit, bit, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_bit'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_bool
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_bool"(bool, bool, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_bool"(bool, bool, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_bool'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_bpchar
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_bpchar"(bpchar, bpchar, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_bpchar"(bpchar, bpchar, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_bpchar'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_bytea"(bytea, bytea, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_bytea"(bytea, bytea, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_char
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_char"(char, char, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_char"(char, char, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_char'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_cidr
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_cidr"(cidr, cidr, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_cidr"(cidr, cidr, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_cidr'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_date
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_date"(date, date, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_date"(date, date, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_date'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_float4
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_float4"(float4, float4, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_float4"(float4, float4, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_float4'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_float8
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_float8"(float8, float8, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_float8"(float8, float8, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_float8'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_inet
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_inet"(inet, inet, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_inet"(inet, inet, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_inet'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_int2
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_int2"(int2, int2, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_int2"(int2, int2, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_int2'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_int4
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_int4"(int4, int4, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_int4"(int4, int4, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_int4'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_int8
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_int8"(int8, int8, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_int8"(int8, int8, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_int8'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_interval
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_interval"(interval, interval, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_interval"(interval, interval, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_interval'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_macaddr
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_macaddr"(macaddr, macaddr, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_macaddr"(macaddr, macaddr, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_macaddr'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_macaddr8
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_macaddr8"(macaddr8, macaddr8, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_macaddr8"(macaddr8, macaddr8, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_macaddr8'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_money
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_money"(money, money, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_money"(money, money, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_money'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_name
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_name"(name, name, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_name"(name, name, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_name'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_numeric
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_numeric"(numeric, numeric, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_numeric"(numeric, numeric, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_numeric'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_oid
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_oid"(oid, oid, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_oid"(oid, oid, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_oid'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_text
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_text"(text, text, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_text"(text, text, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_time
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_time"(time, time, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_time"(time, time, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_time'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_timestamp
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_timestamp"(timestamp, timestamp, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_timestamp"(timestamp, timestamp, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_timestamp'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_timestamptz
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_timestamptz"(timestamptz, timestamptz, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_timestamptz"(timestamptz, timestamptz, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_timestamptz'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_timetz
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_timetz"(timetz, timetz, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_timetz"(timetz, timetz, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_timetz'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_uuid
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_uuid"(uuid, uuid, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_uuid"(uuid, uuid, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_uuid'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_compare_prefix_varbit
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_compare_prefix_varbit"(varbit, varbit, int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_compare_prefix_varbit"(varbit, varbit, int2, internal)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_compare_prefix_varbit'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_enum_cmp
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_enum_cmp"(anyenum, anyenum);
CREATE OR REPLACE FUNCTION "public"."gin_enum_cmp"(anyenum, anyenum)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_enum_cmp'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_anyenum
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_anyenum"(anyenum, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_anyenum"(anyenum, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_anyenum'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_bit
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_bit"(bit, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_bit"(bit, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_bit'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_bool
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_bool"(bool, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_bool"(bool, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_bool'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_bpchar
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_bpchar"(bpchar, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_bpchar"(bpchar, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_bpchar'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_bytea"(bytea, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_bytea"(bytea, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_char
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_char"(char, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_char"(char, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_char'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_cidr
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_cidr"(cidr, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_cidr"(cidr, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_cidr'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_date
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_date"(date, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_date"(date, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_date'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_float4
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_float4"(float4, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_float4"(float4, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_float4'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_float8
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_float8"(float8, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_float8"(float8, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_float8'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_inet
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_inet"(inet, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_inet"(inet, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_inet'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_int2
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_int2"(int2, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_int2"(int2, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_int2'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_int4
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_int4"(int4, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_int4"(int4, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_int4'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_int8
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_int8"(int8, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_int8"(int8, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_int8'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_interval
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_interval"(interval, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_interval"(interval, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_interval'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_macaddr
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_macaddr"(macaddr, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_macaddr"(macaddr, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_macaddr'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_macaddr8
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_macaddr8"(macaddr8, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_macaddr8"(macaddr8, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_macaddr8'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_money
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_money"(money, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_money"(money, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_money'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_name
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_name"(name, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_name"(name, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_name'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_numeric
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_numeric"(numeric, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_numeric"(numeric, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_numeric'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_oid
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_oid"(oid, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_oid"(oid, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_oid'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_text
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_text"(text, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_text"(text, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_time
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_time"(time, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_time"(time, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_time'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_timestamp
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_timestamp"(timestamp, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_timestamp"(timestamp, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_timestamp'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_timestamptz
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_timestamptz"(timestamptz, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_timestamptz"(timestamptz, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_timestamptz'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_timetz
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_timetz"(timetz, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_timetz"(timetz, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_timetz'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_trgm
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_trgm"(text, internal, int2, internal, internal, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_trgm"(text, internal, int2, internal, internal, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/pg_trgm', 'gin_extract_query_trgm'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_uuid
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_uuid"(uuid, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_uuid"(uuid, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_uuid'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_query_varbit
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_query_varbit"(varbit, internal, int2, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_query_varbit"(varbit, internal, int2, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_query_varbit'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_anyenum
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_anyenum"(anyenum, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_anyenum"(anyenum, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_anyenum'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_bit
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_bit"(bit, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_bit"(bit, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_bit'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_bool
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_bool"(bool, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_bool"(bool, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_bool'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_bpchar
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_bpchar"(bpchar, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_bpchar"(bpchar, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_bpchar'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_bytea"(bytea, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_bytea"(bytea, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_char
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_char"(char, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_char"(char, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_char'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_cidr
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_cidr"(cidr, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_cidr"(cidr, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_cidr'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_date
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_date"(date, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_date"(date, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_date'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_float4
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_float4"(float4, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_float4"(float4, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_float4'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_float8
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_float8"(float8, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_float8"(float8, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_float8'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_inet
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_inet"(inet, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_inet"(inet, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_inet'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_int2
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_int2"(int2, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_int2"(int2, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_int2'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_int4
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_int4"(int4, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_int4"(int4, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_int4'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_int8
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_int8"(int8, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_int8"(int8, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_int8'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_interval
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_interval"(interval, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_interval"(interval, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_interval'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_macaddr
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_macaddr"(macaddr, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_macaddr"(macaddr, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_macaddr'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_macaddr8
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_macaddr8"(macaddr8, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_macaddr8"(macaddr8, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_macaddr8'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_money
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_money"(money, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_money"(money, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_money'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_name
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_name"(name, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_name"(name, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_name'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_numeric
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_numeric"(numeric, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_numeric"(numeric, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_numeric'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_oid
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_oid"(oid, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_oid"(oid, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_oid'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_text
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_text"(text, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_text"(text, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_time
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_time"(time, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_time"(time, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_time'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_timestamp
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_timestamp"(timestamp, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_timestamp"(timestamp, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_timestamp'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_timestamptz
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_timestamptz"(timestamptz, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_timestamptz"(timestamptz, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_timestamptz'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_timetz
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_timetz"(timetz, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_timetz"(timetz, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_timetz'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_trgm
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_trgm"(text, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_trgm"(text, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/pg_trgm', 'gin_extract_value_trgm'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_uuid
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_uuid"(uuid, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_uuid"(uuid, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_uuid'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_extract_value_varbit
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_extract_value_varbit"(varbit, internal);
CREATE OR REPLACE FUNCTION "public"."gin_extract_value_varbit"(varbit, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/btree_gin', 'gin_extract_value_varbit'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_numeric_cmp
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_numeric_cmp"(numeric, numeric);
CREATE OR REPLACE FUNCTION "public"."gin_numeric_cmp"(numeric, numeric)
  RETURNS "pg_catalog"."int4" AS '$libdir/btree_gin', 'gin_numeric_cmp'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_trgm_consistent
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_trgm_consistent"(internal, int2, text, int4, internal, internal, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_trgm_consistent"(internal, int2, text, int4, internal, internal, internal, internal)
  RETURNS "pg_catalog"."bool" AS '$libdir/pg_trgm', 'gin_trgm_consistent'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gin_trgm_triconsistent
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gin_trgm_triconsistent"(internal, int2, text, int4, internal, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gin_trgm_triconsistent"(internal, int2, text, int4, internal, internal, internal)
  RETURNS "pg_catalog"."char" AS '$libdir/pg_trgm', 'gin_trgm_triconsistent'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gtrgm_compress
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gtrgm_compress"(internal);
CREATE OR REPLACE FUNCTION "public"."gtrgm_compress"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/pg_trgm', 'gtrgm_compress'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gtrgm_consistent
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gtrgm_consistent"(internal, text, int2, oid, internal);
CREATE OR REPLACE FUNCTION "public"."gtrgm_consistent"(internal, text, int2, oid, internal)
  RETURNS "pg_catalog"."bool" AS '$libdir/pg_trgm', 'gtrgm_consistent'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gtrgm_decompress
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gtrgm_decompress"(internal);
CREATE OR REPLACE FUNCTION "public"."gtrgm_decompress"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/pg_trgm', 'gtrgm_decompress'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gtrgm_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gtrgm_distance"(internal, text, int2, oid, internal);
CREATE OR REPLACE FUNCTION "public"."gtrgm_distance"(internal, text, int2, oid, internal)
  RETURNS "pg_catalog"."float8" AS '$libdir/pg_trgm', 'gtrgm_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gtrgm_in
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gtrgm_in"(cstring);
CREATE OR REPLACE FUNCTION "public"."gtrgm_in"(cstring)
  RETURNS "public"."gtrgm" AS '$libdir/pg_trgm', 'gtrgm_in'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gtrgm_options
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gtrgm_options"(internal);
CREATE OR REPLACE FUNCTION "public"."gtrgm_options"(internal)
  RETURNS "pg_catalog"."void" AS '$libdir/pg_trgm', 'gtrgm_options'
  LANGUAGE c IMMUTABLE
  COST 1;

-- ----------------------------
-- Function structure for gtrgm_out
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gtrgm_out"("public"."gtrgm");
CREATE OR REPLACE FUNCTION "public"."gtrgm_out"("public"."gtrgm")
  RETURNS "pg_catalog"."cstring" AS '$libdir/pg_trgm', 'gtrgm_out'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gtrgm_penalty
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gtrgm_penalty"(internal, internal, internal);
CREATE OR REPLACE FUNCTION "public"."gtrgm_penalty"(internal, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/pg_trgm', 'gtrgm_penalty'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gtrgm_picksplit
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gtrgm_picksplit"(internal, internal);
CREATE OR REPLACE FUNCTION "public"."gtrgm_picksplit"(internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/pg_trgm', 'gtrgm_picksplit'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gtrgm_same
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gtrgm_same"("public"."gtrgm", "public"."gtrgm", internal);
CREATE OR REPLACE FUNCTION "public"."gtrgm_same"("public"."gtrgm", "public"."gtrgm", internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/pg_trgm', 'gtrgm_same'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gtrgm_union
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gtrgm_union"(internal, internal);
CREATE OR REPLACE FUNCTION "public"."gtrgm_union"(internal, internal)
  RETURNS "public"."gtrgm" AS '$libdir/pg_trgm', 'gtrgm_union'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hmac
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hmac"(text, text, text);
CREATE OR REPLACE FUNCTION "public"."hmac"(text, text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_hmac'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hmac
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hmac"(bytea, bytea, text);
CREATE OR REPLACE FUNCTION "public"."hmac"(bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_hmac'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_armor_headers
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_armor_headers"(text, OUT "key" text, OUT "value" text);
CREATE OR REPLACE FUNCTION "public"."pgp_armor_headers"(IN text, OUT "key" text, OUT "value" text)
  RETURNS SETOF "pg_catalog"."record" AS '$libdir/pgcrypto', 'pgp_armor_headers'
  LANGUAGE c IMMUTABLE STRICT
  COST 1
  ROWS 1000;

-- ----------------------------
-- Function structure for pgp_key_id
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_key_id"(bytea);
CREATE OR REPLACE FUNCTION "public"."pgp_key_id"(bytea)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_key_id_w'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_decrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt"(bytea, bytea, text, text);
CREATE OR REPLACE FUNCTION "public"."pgp_pub_decrypt"(bytea, bytea, text, text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_decrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt"(bytea, bytea);
CREATE OR REPLACE FUNCTION "public"."pgp_pub_decrypt"(bytea, bytea)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_decrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt"(bytea, bytea, text);
CREATE OR REPLACE FUNCTION "public"."pgp_pub_decrypt"(bytea, bytea, text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_decrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt_bytea"(bytea, bytea, text);
CREATE OR REPLACE FUNCTION "public"."pgp_pub_decrypt_bytea"(bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_decrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt_bytea"(bytea, bytea, text, text);
CREATE OR REPLACE FUNCTION "public"."pgp_pub_decrypt_bytea"(bytea, bytea, text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_decrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt_bytea"(bytea, bytea);
CREATE OR REPLACE FUNCTION "public"."pgp_pub_decrypt_bytea"(bytea, bytea)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_encrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_encrypt"(text, bytea, text);
CREATE OR REPLACE FUNCTION "public"."pgp_pub_encrypt"(text, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_encrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_encrypt"(text, bytea);
CREATE OR REPLACE FUNCTION "public"."pgp_pub_encrypt"(text, bytea)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_encrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_encrypt_bytea"(bytea, bytea, text);
CREATE OR REPLACE FUNCTION "public"."pgp_pub_encrypt_bytea"(bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_encrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_encrypt_bytea"(bytea, bytea);
CREATE OR REPLACE FUNCTION "public"."pgp_pub_encrypt_bytea"(bytea, bytea)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_sym_decrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_sym_decrypt"(bytea, text);
CREATE OR REPLACE FUNCTION "public"."pgp_sym_decrypt"(bytea, text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_sym_decrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_sym_decrypt"(bytea, text, text);
CREATE OR REPLACE FUNCTION "public"."pgp_sym_decrypt"(bytea, text, text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_sym_decrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_sym_decrypt_bytea"(bytea, text, text);
CREATE OR REPLACE FUNCTION "public"."pgp_sym_decrypt_bytea"(bytea, text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_sym_decrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_sym_decrypt_bytea"(bytea, text);
CREATE OR REPLACE FUNCTION "public"."pgp_sym_decrypt_bytea"(bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_sym_encrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_sym_encrypt"(text, text, text);
CREATE OR REPLACE FUNCTION "public"."pgp_sym_encrypt"(text, text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_sym_encrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_sym_encrypt"(text, text);
CREATE OR REPLACE FUNCTION "public"."pgp_sym_encrypt"(text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_sym_encrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_sym_encrypt_bytea"(bytea, text, text);
CREATE OR REPLACE FUNCTION "public"."pgp_sym_encrypt_bytea"(bytea, text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_sym_encrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_sym_encrypt_bytea"(bytea, text);
CREATE OR REPLACE FUNCTION "public"."pgp_sym_encrypt_bytea"(bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for set_limit
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."set_limit"(float4);
CREATE OR REPLACE FUNCTION "public"."set_limit"(float4)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'set_limit'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for show_limit
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."show_limit"();
CREATE OR REPLACE FUNCTION "public"."show_limit"()
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'show_limit'
  LANGUAGE c STABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for show_trgm
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."show_trgm"(text);
CREATE OR REPLACE FUNCTION "public"."show_trgm"(text)
  RETURNS "pg_catalog"."_text" AS '$libdir/pg_trgm', 'show_trgm'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for similarity
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."similarity"(text, text);
CREATE OR REPLACE FUNCTION "public"."similarity"(text, text)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'similarity'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for similarity_dist
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."similarity_dist"(text, text);
CREATE OR REPLACE FUNCTION "public"."similarity_dist"(text, text)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'similarity_dist'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for similarity_op
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."similarity_op"(text, text);
CREATE OR REPLACE FUNCTION "public"."similarity_op"(text, text)
  RETURNS "pg_catalog"."bool" AS '$libdir/pg_trgm', 'similarity_op'
  LANGUAGE c STABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for strict_word_similarity
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."strict_word_similarity"(text, text);
CREATE OR REPLACE FUNCTION "public"."strict_word_similarity"(text, text)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'strict_word_similarity'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for strict_word_similarity_commutator_op
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."strict_word_similarity_commutator_op"(text, text);
CREATE OR REPLACE FUNCTION "public"."strict_word_similarity_commutator_op"(text, text)
  RETURNS "pg_catalog"."bool" AS '$libdir/pg_trgm', 'strict_word_similarity_commutator_op'
  LANGUAGE c STABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for strict_word_similarity_dist_commutator_op
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."strict_word_similarity_dist_commutator_op"(text, text);
CREATE OR REPLACE FUNCTION "public"."strict_word_similarity_dist_commutator_op"(text, text)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'strict_word_similarity_dist_commutator_op'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for strict_word_similarity_dist_op
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."strict_word_similarity_dist_op"(text, text);
CREATE OR REPLACE FUNCTION "public"."strict_word_similarity_dist_op"(text, text)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'strict_word_similarity_dist_op'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for strict_word_similarity_op
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."strict_word_similarity_op"(text, text);
CREATE OR REPLACE FUNCTION "public"."strict_word_similarity_op"(text, text)
  RETURNS "pg_catalog"."bool" AS '$libdir/pg_trgm', 'strict_word_similarity_op'
  LANGUAGE c STABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v1
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v1"();
CREATE OR REPLACE FUNCTION "public"."uuid_generate_v1"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v1'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v1mc
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v1mc"();
CREATE OR REPLACE FUNCTION "public"."uuid_generate_v1mc"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v1mc'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v3
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v3"("namespace" uuid, "name" text);
CREATE OR REPLACE FUNCTION "public"."uuid_generate_v3"("namespace" uuid, "name" text)
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v3'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v4
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v4"();
CREATE OR REPLACE FUNCTION "public"."uuid_generate_v4"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v4'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v5
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v5"("namespace" uuid, "name" text);
CREATE OR REPLACE FUNCTION "public"."uuid_generate_v5"("namespace" uuid, "name" text)
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v5'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_nil
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_nil"();
CREATE OR REPLACE FUNCTION "public"."uuid_nil"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_nil'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_dns
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_dns"();
CREATE OR REPLACE FUNCTION "public"."uuid_ns_dns"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_dns'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_oid
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_oid"();
CREATE OR REPLACE FUNCTION "public"."uuid_ns_oid"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_oid'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_url
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_url"();
CREATE OR REPLACE FUNCTION "public"."uuid_ns_url"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_url'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_x500
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_x500"();
CREATE OR REPLACE FUNCTION "public"."uuid_ns_x500"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_x500'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for word_similarity
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."word_similarity"(text, text);
CREATE OR REPLACE FUNCTION "public"."word_similarity"(text, text)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'word_similarity'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for word_similarity_commutator_op
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."word_similarity_commutator_op"(text, text);
CREATE OR REPLACE FUNCTION "public"."word_similarity_commutator_op"(text, text)
  RETURNS "pg_catalog"."bool" AS '$libdir/pg_trgm', 'word_similarity_commutator_op'
  LANGUAGE c STABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for word_similarity_dist_commutator_op
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."word_similarity_dist_commutator_op"(text, text);
CREATE OR REPLACE FUNCTION "public"."word_similarity_dist_commutator_op"(text, text)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'word_similarity_dist_commutator_op'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for word_similarity_dist_op
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."word_similarity_dist_op"(text, text);
CREATE OR REPLACE FUNCTION "public"."word_similarity_dist_op"(text, text)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'word_similarity_dist_op'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for word_similarity_op
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."word_similarity_op"(text, text);
CREATE OR REPLACE FUNCTION "public"."word_similarity_op"(text, text)
  RETURNS "pg_catalog"."bool" AS '$libdir/pg_trgm', 'word_similarity_op'
  LANGUAGE c STABLE STRICT
  COST 1;

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."meeting_actions_id_seq"
OWNED BY "public"."meeting_actions"."id";
SELECT setval('"public"."meeting_actions_id_seq"', 1, false);

-- ----------------------------
-- Primary Key structure for table action_items
-- ----------------------------
ALTER TABLE "public"."action_items" ADD CONSTRAINT "action_items_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table agenda_item_versions
-- ----------------------------
ALTER TABLE "public"."agenda_item_versions" ADD CONSTRAINT "agenda_item_versions_agenda_item_id_version_num_key" UNIQUE ("agenda_item_id", "version_num");

-- ----------------------------
-- Primary Key structure for table agenda_item_versions
-- ----------------------------
ALTER TABLE "public"."agenda_item_versions" ADD CONSTRAINT "agenda_item_versions_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table agenda_item_workflow
-- ----------------------------
CREATE INDEX "idx_workflow_agenda_item" ON "public"."agenda_item_workflow" USING btree (
  "agenda_item_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Checks structure for table agenda_item_workflow
-- ----------------------------
ALTER TABLE "public"."agenda_item_workflow" ADD CONSTRAINT "agenda_item_workflow_from_status_check" CHECK (from_status::text = ANY (ARRAY['draft'::character varying::text, 'in_review'::character varying::text, 'finalized'::character varying::text]));
ALTER TABLE "public"."agenda_item_workflow" ADD CONSTRAINT "agenda_item_workflow_to_status_check" CHECK (to_status::text = ANY (ARRAY['draft'::character varying::text, 'in_review'::character varying::text, 'finalized'::character varying::text]));

-- ----------------------------
-- Primary Key structure for table agenda_item_workflow
-- ----------------------------
ALTER TABLE "public"."agenda_item_workflow" ADD CONSTRAINT "agenda_item_workflow_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table agenda_items
-- ----------------------------
CREATE INDEX "idx_agenda_items_committee" ON "public"."agenda_items" USING btree (
  "committee_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "idx_agenda_items_meeting" ON "public"."agenda_items" USING btree (
  "meeting_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table agenda_items
-- ----------------------------
ALTER TABLE "public"."agenda_items" ADD CONSTRAINT "agenda_items_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table agenda_versions
-- ----------------------------
ALTER TABLE "public"."agenda_versions" ADD CONSTRAINT "agenda_versions_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table agenda_workflow
-- ----------------------------
ALTER TABLE "public"."agenda_workflow" ADD CONSTRAINT "agenda_workflow_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table attachments
-- ----------------------------
CREATE UNIQUE INDEX "uniq_current_attachment_per_item" ON "public"."attachments" USING btree (
  "agenda_item_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
) WHERE is_current = true;

-- ----------------------------
-- Primary Key structure for table attachments
-- ----------------------------
ALTER TABLE "public"."attachments" ADD CONSTRAINT "attachments_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table audit_logs
-- ----------------------------
ALTER TABLE "public"."audit_logs" ADD CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table comments
-- ----------------------------
CREATE INDEX "idx_comments_agenda" ON "public"."comments" USING btree (
  "agenda_item_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table comments
-- ----------------------------
ALTER TABLE "public"."comments" ADD CONSTRAINT "comments_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table committee_members
-- ----------------------------
ALTER TABLE "public"."committee_members" ADD CONSTRAINT "committee_members_committee_id_user_id_key" UNIQUE ("committee_id", "user_id");

-- ----------------------------
-- Primary Key structure for table committee_members
-- ----------------------------
ALTER TABLE "public"."committee_members" ADD CONSTRAINT "committee_members_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table committees
-- ----------------------------
ALTER TABLE "public"."committees" ADD CONSTRAINT "committees_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table department_users
-- ----------------------------
ALTER TABLE "public"."department_users" ADD CONSTRAINT "department_users_department_id_user_id_key" UNIQUE ("department_id", "user_id");

-- ----------------------------
-- Checks structure for table department_users
-- ----------------------------
ALTER TABLE "public"."department_users" ADD CONSTRAINT "department_users_role_in_dept_check" CHECK (role_in_dept = ANY (ARRAY['coordinator'::text, 'member'::text]));

-- ----------------------------
-- Primary Key structure for table department_users
-- ----------------------------
ALTER TABLE "public"."department_users" ADD CONSTRAINT "department_users_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table departments
-- ----------------------------
ALTER TABLE "public"."departments" ADD CONSTRAINT "departments_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table departments
-- ----------------------------
ALTER TABLE "public"."departments" ADD CONSTRAINT "departments_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Checks structure for table meeting_actions
-- ----------------------------
ALTER TABLE "public"."meeting_actions" ADD CONSTRAINT "meeting_actions_status_check" CHECK (status = ANY (ARRAY['pending'::text, 'in_progress'::text, 'completed'::text]));

-- ----------------------------
-- Primary Key structure for table meeting_actions
-- ----------------------------
ALTER TABLE "public"."meeting_actions" ADD CONSTRAINT "meeting_actions_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table meeting_attendance
-- ----------------------------
ALTER TABLE "public"."meeting_attendance" ADD CONSTRAINT "meeting_attendance_pkey" PRIMARY KEY ("meeting_id", "user_id");

-- ----------------------------
-- Primary Key structure for table meeting_attendees
-- ----------------------------
ALTER TABLE "public"."meeting_attendees" ADD CONSTRAINT "meeting_attendees_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table meeting_minutes
-- ----------------------------
ALTER TABLE "public"."meeting_minutes" ADD CONSTRAINT "meeting_minutes_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table meeting_rsvps
-- ----------------------------
CREATE INDEX "idx_rsvps_meeting" ON "public"."meeting_rsvps" USING btree (
  "meeting_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table meeting_rsvps
-- ----------------------------
ALTER TABLE "public"."meeting_rsvps" ADD CONSTRAINT "meeting_rsvps_meeting_id_user_id_key" UNIQUE ("meeting_id", "user_id");

-- ----------------------------
-- Checks structure for table meeting_rsvps
-- ----------------------------
ALTER TABLE "public"."meeting_rsvps" ADD CONSTRAINT "meeting_rsvps_status_check" CHECK (status::text = ANY (ARRAY['accepted'::character varying::text, 'declined'::character varying::text, 'tentative'::character varying::text, 'pending'::character varying::text]));

-- ----------------------------
-- Primary Key structure for table meeting_rsvps
-- ----------------------------
ALTER TABLE "public"."meeting_rsvps" ADD CONSTRAINT "meeting_rsvps_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table meetings
-- ----------------------------
CREATE INDEX "idx_meetings_committee" ON "public"."meetings" USING btree (
  "committee_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table meetings
-- ----------------------------
ALTER TABLE "public"."meetings" ADD CONSTRAINT "meetings_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table memberships
-- ----------------------------
ALTER TABLE "public"."memberships" ADD CONSTRAINT "memberships_user_id_committee_id_key" UNIQUE ("user_id", "committee_id");

-- ----------------------------
-- Primary Key structure for table memberships
-- ----------------------------
ALTER TABLE "public"."memberships" ADD CONSTRAINT "memberships_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table minutes
-- ----------------------------
ALTER TABLE "public"."minutes" ADD CONSTRAINT "minutes_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table roles
-- ----------------------------
ALTER TABLE "public"."roles" ADD CONSTRAINT "roles_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table roles
-- ----------------------------
ALTER TABLE "public"."roles" ADD CONSTRAINT "roles_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table user_roles
-- ----------------------------
ALTER TABLE "public"."user_roles" ADD CONSTRAINT "user_roles_pkey" PRIMARY KEY ("user_id", "role_id");

-- ----------------------------
-- Uniques structure for table users
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "users_email_key" UNIQUE ("email");

-- ----------------------------
-- Primary Key structure for table users
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table votes
-- ----------------------------
ALTER TABLE "public"."votes" ADD CONSTRAINT "votes_agenda_item_id_user_id_key" UNIQUE ("agenda_item_id", "user_id");

-- ----------------------------
-- Primary Key structure for table votes
-- ----------------------------
ALTER TABLE "public"."votes" ADD CONSTRAINT "votes_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table action_items
-- ----------------------------
ALTER TABLE "public"."action_items" ADD CONSTRAINT "action_items_agenda_item_id_fkey" FOREIGN KEY ("agenda_item_id") REFERENCES "public"."agenda_items" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;
ALTER TABLE "public"."action_items" ADD CONSTRAINT "action_items_assigned_to_fkey" FOREIGN KEY ("assigned_to") REFERENCES "public"."users" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;
ALTER TABLE "public"."action_items" ADD CONSTRAINT "action_items_meeting_id_fkey" FOREIGN KEY ("meeting_id") REFERENCES "public"."meetings" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table agenda_item_versions
-- ----------------------------
ALTER TABLE "public"."agenda_item_versions" ADD CONSTRAINT "agenda_item_versions_agenda_item_id_fkey" FOREIGN KEY ("agenda_item_id") REFERENCES "public"."agenda_items" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."agenda_item_versions" ADD CONSTRAINT "agenda_item_versions_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."users" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table agenda_item_workflow
-- ----------------------------
ALTER TABLE "public"."agenda_item_workflow" ADD CONSTRAINT "agenda_item_workflow_agenda_item_id_fkey" FOREIGN KEY ("agenda_item_id") REFERENCES "public"."agenda_items" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."agenda_item_workflow" ADD CONSTRAINT "agenda_item_workflow_changed_by_fkey" FOREIGN KEY ("changed_by") REFERENCES "public"."users" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table agenda_items
-- ----------------------------
ALTER TABLE "public"."agenda_items" ADD CONSTRAINT "agenda_items_committee_id_fkey" FOREIGN KEY ("committee_id") REFERENCES "public"."committees" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."agenda_items" ADD CONSTRAINT "agenda_items_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "public"."departments" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;
ALTER TABLE "public"."agenda_items" ADD CONSTRAINT "agenda_items_meeting_id_fkey" FOREIGN KEY ("meeting_id") REFERENCES "public"."meetings" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;
ALTER TABLE "public"."agenda_items" ADD CONSTRAINT "agenda_items_proposer_id_fkey" FOREIGN KEY ("proposer_id") REFERENCES "public"."users" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table agenda_versions
-- ----------------------------
ALTER TABLE "public"."agenda_versions" ADD CONSTRAINT "agenda_versions_finalized_by_fkey" FOREIGN KEY ("finalized_by") REFERENCES "public"."users" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;
ALTER TABLE "public"."agenda_versions" ADD CONSTRAINT "agenda_versions_meeting_id_fkey" FOREIGN KEY ("meeting_id") REFERENCES "public"."meetings" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table agenda_workflow
-- ----------------------------
ALTER TABLE "public"."agenda_workflow" ADD CONSTRAINT "agenda_workflow_agenda_item_id_fkey" FOREIGN KEY ("agenda_item_id") REFERENCES "public"."agenda_items" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."agenda_workflow" ADD CONSTRAINT "agenda_workflow_changed_by_fkey" FOREIGN KEY ("changed_by") REFERENCES "public"."users" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table attachments
-- ----------------------------
ALTER TABLE "public"."attachments" ADD CONSTRAINT "attachments_agenda_item_id_fkey" FOREIGN KEY ("agenda_item_id") REFERENCES "public"."agenda_items" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."attachments" ADD CONSTRAINT "attachments_uploaded_by_fkey" FOREIGN KEY ("uploaded_by") REFERENCES "public"."users" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table audit_logs
-- ----------------------------
ALTER TABLE "public"."audit_logs" ADD CONSTRAINT "audit_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table comments
-- ----------------------------
ALTER TABLE "public"."comments" ADD CONSTRAINT "comments_agenda_item_id_fkey" FOREIGN KEY ("agenda_item_id") REFERENCES "public"."agenda_items" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."comments" ADD CONSTRAINT "comments_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "public"."comments" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."comments" ADD CONSTRAINT "comments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table committee_members
-- ----------------------------
ALTER TABLE "public"."committee_members" ADD CONSTRAINT "committee_members_committee_id_fkey" FOREIGN KEY ("committee_id") REFERENCES "public"."committees" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."committee_members" ADD CONSTRAINT "committee_members_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table department_users
-- ----------------------------
ALTER TABLE "public"."department_users" ADD CONSTRAINT "department_users_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "public"."departments" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."department_users" ADD CONSTRAINT "department_users_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table meeting_actions
-- ----------------------------
ALTER TABLE "public"."meeting_actions" ADD CONSTRAINT "meeting_actions_agenda_item_id_fkey" FOREIGN KEY ("agenda_item_id") REFERENCES "public"."agenda_items" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."meeting_actions" ADD CONSTRAINT "meeting_actions_meeting_id_fkey" FOREIGN KEY ("meeting_id") REFERENCES "public"."meetings" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table user_roles
-- ----------------------------
ALTER TABLE "public"."user_roles" ADD CONSTRAINT "user_roles_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "public"."roles" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."user_roles" ADD CONSTRAINT "user_roles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
