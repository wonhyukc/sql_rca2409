/*
 * Study and experiment on index ( Postgres ) 
 * William Chung, 241003 
 */
SET max_parallel_workers=4;
SET parallel_leader_participation = ON;

SELECT * FROM census;
SELECT count(*) FROM census;


--drop some columns for better understanding
ALTER TABLE public.census DROP COLUMN "ESTIMATESBASE2010";
ALTER TABLE public.census DROP COLUMN "POPESTIMATE2010";
ALTER TABLE public.census DROP COLUMN "POPESTIMATE2011";
ALTER TABLE public.census DROP COLUMN "POPESTIMATE2012";
ALTER TABLE public.census DROP COLUMN "POPESTIMATE2013";
ALTER TABLE public.census DROP COLUMN "POPESTIMATE2014";
ALTER TABLE public.census DROP COLUMN "POPESTIMATE2015";
ALTER TABLE public.census DROP COLUMN "NPOPCHG_2010";
ALTER TABLE public.census DROP COLUMN "NPOPCHG_2011";
ALTER TABLE public.census DROP COLUMN "NPOPCHG_2012";
ALTER TABLE public.census DROP COLUMN "NPOPCHG_2013";
ALTER TABLE public.census DROP COLUMN "NPOPCHG_2014";
ALTER TABLE public.census DROP COLUMN "NPOPCHG_2015";
ALTER TABLE public.census DROP COLUMN "BIRTHS2010";
ALTER TABLE public.census DROP COLUMN "BIRTHS2011";
ALTER TABLE public.census DROP COLUMN "BIRTHS2012";
ALTER TABLE public.census DROP COLUMN "BIRTHS2013";
ALTER TABLE public.census DROP COLUMN "BIRTHS2014";
ALTER TABLE public.census DROP COLUMN "BIRTHS2015";
ALTER TABLE public.census DROP COLUMN "DEATHS2010";
ALTER TABLE public.census DROP COLUMN "DEATHS2011";
ALTER TABLE public.census DROP COLUMN "DEATHS2012";
ALTER TABLE public.census DROP COLUMN "DEATHS2013";
ALTER TABLE public.census DROP COLUMN "DEATHS2014";
ALTER TABLE public.census DROP COLUMN "DEATHS2015";
ALTER TABLE public.census DROP COLUMN "NATURALINC2010";
ALTER TABLE public.census DROP COLUMN "NATURALINC2011";
ALTER TABLE public.census DROP COLUMN "NATURALINC2012";
ALTER TABLE public.census DROP COLUMN "NATURALINC2013";
ALTER TABLE public.census DROP COLUMN "NATURALINC2014";
ALTER TABLE public.census DROP COLUMN "NATURALINC2015";
ALTER TABLE public.census DROP COLUMN "INTERNATIONALMIG2010";
ALTER TABLE public.census DROP COLUMN "INTERNATIONALMIG2011";
ALTER TABLE public.census DROP COLUMN "INTERNATIONALMIG2012";
ALTER TABLE public.census DROP COLUMN "INTERNATIONALMIG2013";
ALTER TABLE public.census DROP COLUMN "INTERNATIONALMIG2014";
ALTER TABLE public.census DROP COLUMN "INTERNATIONALMIG2015";
ALTER TABLE public.census DROP COLUMN "DOMESTICMIG2010";
ALTER TABLE public.census DROP COLUMN "DOMESTICMIG2011";
ALTER TABLE public.census DROP COLUMN "DOMESTICMIG2012";
ALTER TABLE public.census DROP COLUMN "DOMESTICMIG2013";
ALTER TABLE public.census DROP COLUMN "DOMESTICMIG2014";
ALTER TABLE public.census DROP COLUMN "DOMESTICMIG2015";
ALTER TABLE public.census DROP COLUMN "NETMIG2010";
ALTER TABLE public.census DROP COLUMN "NETMIG2011";
ALTER TABLE public.census DROP COLUMN "NETMIG2012";
ALTER TABLE public.census DROP COLUMN "NETMIG2013";
ALTER TABLE public.census DROP COLUMN "NETMIG2014";
ALTER TABLE public.census DROP COLUMN "NETMIG2015";
ALTER TABLE public.census DROP COLUMN "RESIDUAL2010";
ALTER TABLE public.census DROP COLUMN "RESIDUAL2011";
ALTER TABLE public.census DROP COLUMN "RESIDUAL2012";
ALTER TABLE public.census DROP COLUMN "RESIDUAL2013";
ALTER TABLE public.census DROP COLUMN "RESIDUAL2014";
ALTER TABLE public.census DROP COLUMN "RESIDUAL2015";
ALTER TABLE public.census DROP COLUMN "GQESTIMATESBASE2010";
ALTER TABLE public.census DROP COLUMN "GQESTIMATES2010";
ALTER TABLE public.census DROP COLUMN "GQESTIMATES2011";
ALTER TABLE public.census DROP COLUMN "GQESTIMATES2012";
ALTER TABLE public.census DROP COLUMN "GQESTIMATES2013";
ALTER TABLE public.census DROP COLUMN "GQESTIMATES2014";
ALTER TABLE public.census DROP COLUMN "GQESTIMATES2015";
ALTER TABLE public.census DROP COLUMN "RBIRTH2011";
ALTER TABLE public.census DROP COLUMN "RBIRTH2012";
ALTER TABLE public.census DROP COLUMN "RBIRTH2013";
ALTER TABLE public.census DROP COLUMN "RBIRTH2014";
ALTER TABLE public.census DROP COLUMN "RBIRTH2015";
ALTER TABLE public.census DROP COLUMN "RDEATH2011";
ALTER TABLE public.census DROP COLUMN "RDEATH2012";
ALTER TABLE public.census DROP COLUMN "RDEATH2013";
ALTER TABLE public.census DROP COLUMN "RDEATH2014";
ALTER TABLE public.census DROP COLUMN "RDEATH2015";
ALTER TABLE public.census DROP COLUMN "RNATURALINC2011";
ALTER TABLE public.census DROP COLUMN "RNATURALINC2012";
ALTER TABLE public.census DROP COLUMN "RNATURALINC2013";
ALTER TABLE public.census DROP COLUMN "RNATURALINC2014";
ALTER TABLE public.census DROP COLUMN "RNATURALINC2015";
ALTER TABLE public.census DROP COLUMN "RINTERNATIONALMIG2011";
ALTER TABLE public.census DROP COLUMN "RINTERNATIONALMIG2012";
ALTER TABLE public.census DROP COLUMN "RINTERNATIONALMIG2013";
ALTER TABLE public.census DROP COLUMN "RINTERNATIONALMIG2014";
ALTER TABLE public.census DROP COLUMN "RINTERNATIONALMIG2015";
ALTER TABLE public.census DROP COLUMN "RDOMESTICMIG2011";
ALTER TABLE public.census DROP COLUMN "RDOMESTICMIG2012";
ALTER TABLE public.census DROP COLUMN "RDOMESTICMIG2013";
ALTER TABLE public.census DROP COLUMN "RDOMESTICMIG2014";
ALTER TABLE public.census DROP COLUMN "RDOMESTICMIG2015";
ALTER TABLE public.census DROP COLUMN "RNETMIG2011";
ALTER TABLE public.census DROP COLUMN "RNETMIG2012";
ALTER TABLE public.census DROP COLUMN "RNETMIG2013";
ALTER TABLE public.census DROP COLUMN "RNETMIG2014";
ALTER TABLE public.census DROP COLUMN "RNETMIG2015";


--add id column
ALTER TABLE public.census	ADD COLUMN id SERIAL;

--make a row bigger enough
ALTER TABLE public.census ALTER COLUMN "STNAME" TYPE text USING "STNAME"::char::text;
ALTER TABLE public.census ALTER COLUMN "CTYNAME" TYPE text USING "STNAME"::char::text;

SELECT id, * FROM census;




/***************************************
 * Repeat to make more than 1M rows. If your computer is slow, more than 500K rows. 
 * 1,634,816 rows
 */
INSERT INTO census ("SUMLEV", "REGION", "DIVISION", "STATE", "COUNTY", "STNAME", "CTYNAME", "CENSUS2010POP")
	SELECT "SUMLEV", "REGION", "DIVISION", "STATE", "COUNTY", "STNAME", "CTYNAME", "CENSUS2010POP" 
	FROM census; 
SELECT max(id), count(*) FROM census;
---------------------------------------------------





--DROP INDEX ix_id;
CREATE UNIQUE INDEX ix_id ON census(id);	--almost same AS PK

--create same table but no index
SELECT * INTO census_noindex FROM census;



EXPLAIN
SELECT * FROM census a;
--search and study: what is the difference betweend first and the second cost value
/*
Seq Scan on census a  (cost=0.00..44974.16 rows=1634816 width=94)
*/

EXPLAIN
SELECT * FROM census a	WHERE id = 24; 
/*
Index Scan using ix_id on census a  (cost=0.43..8.45 rows=1 width=94)
  Index Cond: (id = 24)
 */


-- EXPLAIN: no execution, just show the plan
-- ANALYZE: execute and show the plan
EXPLAIN ANALYZE 
SELECT * FROM census a	WHERE id = 24; 
/*
Index Scan using ix_id on census a  (cost=0.43..8.45 rows=1 width=94) (actual time=0.022..0.024 rows=1 loops=1)
  Index Cond: (id = 24)
Planning Time: 0.076 ms
Execution Time: 0.043 ms
 */


--buffers: show the buffer == cache
EXPLAIN (ANALYZE, buffers) 
SELECT * FROM census a 
WHERE id = 24;
/*
Index Scan using ix_id on census a  (cost=0.43..8.45 rows=1 width=94) (actual time=0.024..0.026 rows=1 loops=1)
  Index Cond: (id = 24)
  Buffers: shared hit=4			******** notice
Planning Time: 0.078 ms
Execution Time: 0.046 ms
*/


EXPLAIN (ANALYZE, buffers) 
SELECT * FROM census a 
WHERE id = 140000;
/*
Index Scan using ix_id on census a  (cost=0.43..8.45 rows=1 width=94) (actual time=0.093..0.095 rows=1 loops=1)
  Index Cond: (id = 140000)
  Buffers: shared hit=3 read=1	********** notice
Planning Time: 0.072 ms
Execution Time: 0.115 ms
 */

EXPLAIN (ANALYZE, buffers) 
SELECT * FROM census_noindex 
WHERE id = 24
/*
Gather  (cost=1000.00..34858.77 rows=1 width=94) (actual time=0.351..161.046 rows=1 loops=1)
  Workers Planned: 2
  Workers Launched: 2
  Buffers: shared hit=2114 read=23230
  ->  Parallel Seq Scan on census_noindex  (cost=0.00..33858.67 rows=1 width=94) (actual time=77.938..128.493 rows=0 loops=3)
        Filter: (id = 24)
        Rows Removed by Filter: 544938
        Buffers: shared hit=2114 read=23230
Planning Time: 0.061 ms
Execution Time: 161.071 ms
*/


-- force to stop parallel execution
SET max_parallel_workers=0;
SET parallel_leader_participation = OFF;

EXPLAIN (ANALYZE, buffers) 
SELECT * FROM census_noindex 
WHERE id = 24
/* 
Gather  (cost=1000.00..36561.70 rows=1 width=94) (actual time=0.360..279.866 rows=1 loops=1)
  Workers Planned: 2
  Workers Launched: 0
  Buffers: shared hit=2210 read=23134
  ->  Parallel Seq Scan on census_noindex  (cost=0.00..35561.60 rows=1 width=94) (actual time=0.111..279.558 rows=1 loops=1)
        Filter: (id = 24)
        Rows Removed by Filter: 1634815
        Buffers: shared hit=2210 read=23134
Planning Time: 0.115 ms
Execution Time: 279.916 ms
 */



/********************************************************
 * search argument
 */

EXPLAIN (ANALYZE, buffers) 
SELECT * FROM census a 
WHERE id +0 = 24;
/*
Gather  (cost=1000.00..42704.52 rows=8174 width=94) (actual time=0.959..1540.735 rows=1 loops=1)
  Workers Planned: 2
  Workers Launched: 0
  Buffers: shared read=28626
  ->  Parallel Seq Scan on census a  (cost=0.00..40887.12 rows=4087 width=94) (actual time=0.662..1540.356 rows=1 loops=1)
        Filter: ((id + 0) = 24)
        Rows Removed by Filter: 1634815
        Buffers: shared read=28626
Planning:
  Buffers: shared hit=49 read=8
Planning Time: 4.883 ms
Execution Time: 1540.802 ms
 */

EXPLAIN (ANALYZE, buffers) 
SELECT * FROM census a 
WHERE id = 24 +1;
/*
Index Scan using ix_id on census a  (cost=0.43..8.45 rows=1 width=94) (actual time=3.325..3.328 rows=1 loops=1)
  Index Cond: (id = 25)
  Buffers: shared read=4
Planning Time: 0.122 ms
Execution Time: 3.354 ms
*/


