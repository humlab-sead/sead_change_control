-- DROP TYPE IF EXISTS "public"."breakpoint";

-- CREATE TYPE "public"."breakpoint" AS (
--     "func" oid,
--     "linenumber" int4,
--     "targetname" text COLLATE "pg_catalog"."default"
-- );

-- ALTER TYPE "public"."breakpoint" OWNER TO "sead_master";

-- DROP TYPE IF EXISTS "public"."dblink_pkey_results";

-- CREATE TYPE "public"."dblink_pkey_results" AS (
--     "position" int4,
--     "colname" text COLLATE "pg_catalog"."default"
-- );

-- ALTER TYPE "public"."dblink_pkey_results" OWNER TO "sead_master";

-- DROP TYPE IF EXISTS "public"."frame";

-- CREATE TYPE "public"."frame" AS (
--     "level" int4,
--     "targetname" text COLLATE "pg_catalog"."default",
--     "func" oid,
--     "linenumber" int4,
--     "args" text COLLATE "pg_catalog"."default"
-- );

-- ALTER TYPE "public"."frame" OWNER TO "sead_master";

-- DROP TYPE IF EXISTS "public"."proxyinfo";

-- CREATE TYPE "public"."proxyinfo" AS (
--     "serverversionstr" text COLLATE "pg_catalog"."default",
--     "serverversionnum" int4,
--     "proxyapiver" int4,
--     "serverprocessid" int4
-- );

-- ALTER TYPE "public"."proxyinfo" OWNER TO "sead_master";

-- DROP TYPE IF EXISTS "public"."targetinfo";

-- CREATE TYPE "public"."targetinfo" AS (
--     "target" oid,
--     "schema" oid,
--     "nargs" int4,
--     "argtypes" "pg_catalog"."oidvector",
--     "targetname" "pg_catalog"."name",
--     "argmodes" char( 1)[] COLLATE "pg_catalog"."default",
--     "argnames" text[] COLLATE "pg_catalog"."default",
--     "targetlang" oid,
--     "fqname" text COLLATE "pg_catalog"."default",
--     "returnsset" bool,
--     "returntype" oid);

-- ALTER TYPE "public"."targetinfo" OWNER TO "sead_master";

-- DROP TYPE IF EXISTS "public"."tbiblio";

-- CREATE TYPE "public"."tbiblio" AS (
--     "reference" varchar( 60)
--     COLLATE "pg_catalog"."default",
--     "author" varchar(255)
--     COLLATE "pg_catalog"."default",
--     "title" text COLLATE "pg_catalog"."default",
--     "notes" text COLLATE "pg_catalog"."default");

-- ALTER TYPE "public"."tbiblio" OWNER TO "sead_master";

-- DROP TYPE IF EXISTS "public"."tcountsheet";

-- CREATE TYPE "public"."tcountsheet" AS (
--     "countsheetcode" varchar( 10)
--     COLLATE "pg_catalog"."default",
--     "countsheetname" varchar(100)
--     COLLATE "pg_catalog"."default",
--     "sitecode" varchar(10)
--     COLLATE "pg_catalog"."default",
--     "sheetcontext" varchar(25)
--     COLLATE "pg_catalog"."default",
--     "sheettype" varchar(25)
--     COLLATE "pg_catalog"."default");

-- ALTER TYPE "public"."tcountsheet" OWNER TO "sead_master";

-- DROP TYPE IF EXISTS "public"."tfossil";

-- CREATE TYPE "public"."tfossil" AS (
--     "fossilbugscode" varchar( 10)
--     COLLATE "pg_catalog"."default",
--     "code" numeric(18, 10),
--     "samplecode" varchar(10)
--     COLLATE "pg_catalog"."default",
--     "abundance" int4);

-- ALTER TYPE "public"."tfossil" OWNER TO "sead_master";

-- DROP TYPE IF EXISTS "public"."tsample";

-- CREATE TYPE "public"."tsample" AS (
--     "samplecode" varchar( 10)
--     COLLATE "pg_catalog"."default",
--     "sitecode" varchar(10)
--     COLLATE "pg_catalog"."default",
--     "x" varchar(50)
--     COLLATE "pg_catalog"."default",
--     "y" varchar(50)
--     COLLATE "pg_catalog"."default",
--     "zordepthtop" numeric(18, 10),
--     "zordepthbot" numeric(18, 10),
--     "refnrcontext" varchar(50)
--     COLLATE "pg_catalog"."default",
--     "countsheetcode" varchar(10)
--     COLLATE "pg_catalog"."default");

-- ALTER TYPE "public"."tsample" OWNER TO "sead_master";

-- DROP TYPE IF EXISTS "public"."var";

-- CREATE TYPE "public"."var" AS (
--     "name" text COLLATE "pg_catalog"."default",
--     "varclass" char( 1)
--     COLLATE "pg_catalog"."default",
--     "linenumber" int4,
--     "isunique" bool,
--     "isconst" bool,
--     "isnotnull" bool,
--     "dtype" oid,
--     "value" text COLLATE "pg_catalog"."default");

-- ALTER TYPE "public"."var" OWNER TO "sead_master";

