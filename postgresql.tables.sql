-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- Create table cities
CREATE TABLE "cities" (
  "id" INTEGER NOT NULL,
  "country" VARCHAR(50),
  "city" VARCHAR(150),
  PRIMARY KEY ("id")
);

-- Insert 3 example lines into table cities
INSERT INTO "cities"("id", "country", "city") VALUES (1, 'USA', 'Palo Alto');
INSERT INTO "cities"("id", "country", "city") VALUES (2, 'Czech Republic', 'Brno');
INSERT INTO "cities"("id", "country", "city") VALUES (3, 'USA', 'Sunnyvale');

-- Create staging table for export
CREATE TABLE "staging_cities" (LIKE "cities");

-- Create table countries
CREATE TABLE "countries" (
  "country_id" INTEGER NOT NULL,
  "country" VARCHAR(50),
  PRIMARY KEY ("country_id")
);

-- Insert 2 example lines into table countries
INSERT INTO "countries"("country_id", "country") VALUES (1, 'USA');
INSERT INTO "countries"("country_id", "country") VALUES (2, 'Czech Republic');

-- Create normalized variant of table cities
CREATE TABLE "normcities" (
  "id" INTEGER NOT NULL,
  "country_id" INTEGER NOT NULL,
  "city" VARCHAR(150),
  PRIMARY KEY ("id"),
  FOREIGN KEY ("country_id") REFERENCES "countries"("country_id")
);

-- Insert 3 example lines into table normcities
INSERT INTO "normcities"("id", "country_id", "city") VALUES (1, 1, 'Palo Alto');
INSERT INTO "normcities"("id", "country_id", "city") VALUES (2, 2, 'Brno');
INSERT INTO "normcities"("id", "country_id", "city") VALUES (3, 1, 'Sunnyvale');

-- Create visits table that is suitable for incremental import
CREATE TABLE "visits" (
  "id" INTEGER NOT NULL,
  "city" VARCHAR(50),
  "last_update_date" TIMESTAMP NOT NULL,
  PRIMARY KEY ("id")
);

-- Insert couple of records to table visits
INSERT INTO "visits"("id", "city", "last_update_date") VALUES(1, 'Freemont', '1983-05-22 01:01:01');
INSERT INTO "visits"("id", "city", "last_update_date") VALUES(2, 'Jicin', '1987-02-02 02:02:02');

-- Special table with booleans
CREATE TABLE "table_with_booleans" (
  "id" INTEGER NOT NULL,
  "city" VARCHAR(50),
  "visited" BOOLEAN,
  PRIMARY KEY ("id")
);

-- Insert couple of records to table table_with_booleans
INSERT INTO "table_with_booleans"("id", "city", "visited") VALUES(1, 'Prague', true);
INSERT INTO "table_with_booleans"("id", "city", "visited") VALUES(2, 'Brno', false);
INSERT INTO "table_with_booleans"("id", "city", "visited") VALUES(3, 'Jicin', true);

-- Create custom schema "us"
CREATE SCHEMA "us";

-- Create variant of table cities in schema US
CREATE TABLE "us"."cities" (LIKE "cities");

-- Populate data in us.cities from cities
INSERT INTO "us"."cities" SELECT * FROM "cities" WHERE "country" = 'USA';
