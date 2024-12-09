# Reading Notes

These are the reading notes to accompany the slides for the course. The notes consist of:

1. Links to reference material
2. Additional resources
3. Links to material added during class


The main PostgresQL documentation we will be referencing is here: [PostgreQL Official Documents]()

---

## Module 1 - Introduction

### Migration 

The primary reason for most migration to Postgres is the combination of cost and performance. Postgres provides performance equivalent to commercial products but without the licensing fees. The total cost of ownership is entirely based on the organization's internal spending.


Specific migrations will be discussed later. 


### YugabyteDB

Because Postgresql is open source, it is the perfect starting point for building other kinds of databases. For example, YugabyteDB replaces the underlying file system of a standard postgres database cluster with a distributed storage system. This sort of innovation is not possible with a proprietary database product like Oracle.

![](images/Yugabytes.png)

[YugabyteDB home page](https://www.yugabyte.com/)

---

## Module 3 - Installation and Config

#### Directories

Many of the directories contain working information used by PostgreSQL in executing tasks. Normally, these are managed internally by postgres. Some of these are:

1. pg_commit_ts: Stores the commit timestamps for transactions if the track_commit_timestamp feature is enabled.
2. pg_dynshmem: Holds files used for dynamic shared memory segments.
3. pg_logical: Contains files and subdirectories related to logical replication.
4. pg_multixact: Contains data related to multitransaction (multi-xact) structures.
5. pg_serial: Stores information about transactions that are part of the SERIALIZABLE isolation level.
6. pg_tblspc: Links to tablespaces created in the PostgreSQL instance.
7. pg_xact: Tracks the transaction commit status.

[System Catalogues](https://www.postgresql.org/docs/16/catalogs.html)

#### Key Columns in pg_class


**oid**	Object Identifier for the relation. Unique within the database.

**relname**	Name of the relation (e.g., table name, index name).

**relnamespace** OID of the schema (pg_namespace) containing the relation.

**reltype**	OID of the data type for the relation if it is a composite type; otherwise, 0.

**reloftype**	OID of the type if this relation is a typed table; otherwise, 0.

**relowner**	OID of the role that owns the relation.

**relam**	OID of the access method used (only for indexes).

**relfilenode**	Identifier for the physical storage of the relation on disk.

**reltablespace**	OID of the tablespace where the relation is stored (0 for default tablespace).

**relpages**	Approximate number of pages used by the relation on disk (deprecated in recent versions).

**reltuples**	Estimated number of rows in the relation.

**relallvisible**	Number of pages marked as "all visible" in the visibility map (used by VACUUM).

**reltoastrelid**	OID of the associated TOAST table, if the table uses TOAST for large objects.

**relhasindex**	Boolean indicating if the table has indexes.

**relisshared**	Boolean indicating if the relation is shared across all databases in the cluster (e.g., pg_database).

**relnatts**	Number of attributes (columns) in the table or composite type.

**relchecks**	Number of CHECK constraints on the table.

**relkind**	Type of relation:
- r: Ordinary table
- i: Index
- S: Sequence
- v: View
- m: Materialized view
- c: Composite type
- t: TOAST table
- f: Foreign table

**relpersistence**	Persistence type of the relation:
- p: Permanent
- u: Unlogged
- t: Temporary

**relispopulated**	Boolean indicating whether the relation is populated (used for unlogged and materialized views).

**relreplident**	Type of replica identity for replication:
- d: Default (ctid)
- n: None
- f: Full replica identity
- i: Index-based replica identity

**relispartition**	Boolean indicating if the table is a partition.

**relpartbound**	Partition boundary expression (if the table is a partition).

---

## Module 4: Tables and Views

#### Incrementally refreshable materialized views

PostgreSQL 16 introduced support for incrementally refreshable materialized views,
- Uses the command
```sql 
REFRESH MATERIALIZED VIEW ... WITH DATA
```

- Requires the pg_snapshot extension to be installed
- Provides the ability to track changes in tables efficiently.
- Change tracking involves capturing the changes (inserts, updates, deletes) made to the data in the base tables that are used by a materialized view.
- Can use logical replication slots or triggers

```sql
CREATE MATERIALIZED VIEW order_totals 
WITH (incremental_refresh = true) AS
SELECT customer_id, SUM(amount) AS total_amount
FROM orders
GROUP BY customer_id
WITH NO DATA;

REFRESH MATERIALIZED VIEW order_totals WITH DATA;

```

#### Partitioned Index

Supported in PQ

```sql
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    amount DECIMAL
) PARTITION BY RANGE (order_date);


CREATE TABLE orders_2023 PARTITION OF orders
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE orders_2024 PARTITION OF orders
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');


CREATE INDEX ON orders USING btree (order_date);

```
### Subpartitions

Hierarchical Partitioning:
- A partitioned table can have partitions
- And those partitions can themselves be partitioned into subpartitions.

Supported Partitioning Strategies:
- Can mix and match partitioning strategies.
- A parent table can be range-partitioned, for example, and its partitions can be list-partitioned.

```sql
-- Create a parent table with range partitioning
CREATE TABLE sales (
        id SERIAL PRIMARY KEY,
        sale_date DATE NOT NULL,
        region TEXT NOT NULL,
        amount NUMERIC
) PARTITION BY RANGE (sale_date);

-- Create a partition of the parent table
CREATE TABLE sales_2024 (
        LIKE sales INCLUDING ALL
) PARTITION BY LIST (region);

-- Subpartition of the 2024 partition
CREATE TABLE sales_2024_us PARTITION OF sales_2024
    FOR VALUES IN ('US');

CREATE TABLE sales_2024_eu PARTITION OF sales_2024
    FOR VALUES IN ('EU');

```



---

## Module 5: Optimization

[Rule System](https://www.postgresql.org/docs/16/rules.html)

[Indexes](https://www.postgresql.org/docs/16/indexes.html)

[Genetic Optimizer](https://www.postgresql.org/docs/16/geqo.html)

[Explain]()

---

## Module 6: Monitoring

[System Parameters](https://www.postgresql.org/docs/16/runtime-config.html)

[pgbadger](https://github.com/darold/)

### Links to Monitoring tools

[pgAdmin Official Website](https://www.pgadmin.org/)

[pgBadger GitHub Repository](https://github.com/darold/pgbadger)

[pg_top GitHub Repository](https://github.com/markwkm/pg_top)

[PostgreSQL Exporter GitHub Repository](https://github.com/prometheus-community/postgres_exporter)

[pgmetrics GitHub Repository](https://github.com/rapidloop/pgmetrics)

[Percona Monitoring and Management Website](https://www.percona.com/software/database-tools/percona-monitoring-and-management)

[pg_stat_kcache GitHub Repository](https://github.com/powa-team/pg_stat_kcache)

[TimescaleDB Official Website](https://www.timescale.com/)

[pgCluu GitHub Repository](https://github.com/darold/pgcluu)

---

## Module 7: Backups

[pgBackRest User Guide](https://pgbackrest.org/user-guide.html)

### Replication

[Patroni](https://patroni.readthedocs.io/en/latest/)

[PostgreSQL Replication: A Comprehensive Guide](https://kinsta.com/blog/postgresql-replication/)

[Setting Up PostgreSQL Replication: A Step-by-Step Guide](https://medium.com/@umairhassan27/setting-up-postgresql-replication-on-slave-server-a-step-by-step-guide-1ff36bb9a47f)


### Using pg_backup

pg_start_backup and pg_stop_backup perform consistent filesystem-level backups of a database cluster. They ensure the database state is consistent while the backup is being taken by coordinating with PostgreSQL's Write-Ahead Logging (WAL).



#### Configuration

In postgresql.cong

```text
archive_mode = on
archive_command = 'cp %p /path/to/archive/%f'
```

##### pg_startbackup process

```sql
SELECT pg_start_backup('backup_label', true);
```

- `backup_label`: A label for the backup (e.g., the current timestamp or description).
- `true`: Indicates a non-exclusive backup mode 
- The function outputs the starting WAL location, which you can note for reference.

##### Copy

Perform a filesystem-level copy of the PostgreSQL data directory using a tool like rsync or cp. Be sure to exclude `pg_wal` which contains the WAL files that are archived separately. Using rsync

```shell
rsync -a --exclude 'pg_wal/*' /var/lib/postgresql/data /backup/location
```

##### Stop the Backup

After the filesystem copy is complete, run:

```sql
SELECT pg_stop_backup();
```
- Marks the end of the backup.
- Ensures all necessary WAL files are archived.
- Outputs the WAL file name required to restore the backup.

##### Archive WAL Files

Ensure the WAL files generated during the backup are archived. These are necessary to restore the backup to a consistent state. The output of pg_stop_backup indicates the last required WAL file.

##### Restoring the Backup

- Copy the backup files to the new data directory.
- Ensure the pg_wal directory contains the required WAL files or point to the archive location.
- Start PostgreSQL, and it will replay the WAL files to reach a consistent state.

#### PITR

##### Basic Strategy

**Base Backup:**
- A consistent filesystem-level copy of the database cluster
- Taken using tools like pg_basebackup or pg_start_backup/pg_stop_backup.

**WAL Archiving:**
- Write-Ahead Logs (WAL files) are continuously written to an archive directory.
- These WAL files record all changes made to the database.

**Recovery Process:**
- Start with the base backup.
- Replay WAL files to "roll forward" changes made after the base backup.
- Stop the recovery at a specific timestamp or transaction, effectively "recovering" to a specific point in time.

PITR is used to
- Undo accidental data loss or modification.
- Recover to a consistent state after a hardware or software failure.
- Restore a database to a known good state from the past.

#####  Prepare the Base Backup

##### 1 Take a base backup of your database using pg_basebackup or pg_start_backup/pg_stop_backup.

```shell
pg_basebackup -D /path/to/backup -F tar -z -X fetch -P
```

##### 2 Enable WAL Archiving

Ensure archive_mode is enabled and the archive_command is configured in postgresql.conf:

```text
archive_mode = on
archive_command = 'cp %p /path/to/wal_archive/%f'
```

##### 3. Simulate a Recovery Scenario

For recovery, assume a failure or accidental change, and you want to restore to a specific point in time.

##### 4. Restore the Base Backup

Copy the base backup to your PostgreSQL data directory and ensure proper permissions.

```shell 
cp -r /path/to/base_backup/* /var/lib/postgresql/data
chown -R postgres:postgres /var/lib/postgresql/data
```

##### 5. Set Up the Recovery Configuration

Create a recovery.conf file  to configure recovery.

```text 
restore_command = 'cp /path/to/wal_archive/%f %p'
recovery_target_time = '2024-12-01 12:34:56'  # Adjust the time
```

Other recovery targets might be:

- recovery_target_time: A specific timestamp.
- recovery_target_lsn: A specific log sequence number.
- recovery_target_name: A named restore point.
- recovery_target_action: What to do after reaching the target (e.g., pause or promote).

##### 6. Start PostgreSQL in Recovery Mode

Start the PostgreSQL server. It will replay WAL files to restore the database to the desired point in time.

```shell
pg_ctl start -D /var/lib/postgresql/data
```
##### 7. Monitor the Recovery

Check PostgreSQL logs to ensure recovery is proceeding correctly and the desired state is reached.

##### 8. End Recovery

Once recovery is complete:  PostgreSQL exits recovery mode automatically and renames recovery.conf to recovery.done.

**Important Considerations**

1. WAL Archiving Is Crucial: Without archived WAL files, PITR cannot replay changes beyond the base backup.
2. Recovery Target Must Be Precise: Double-check the recovery_target_time or other criteria to ensure accuracy.
3. Disk Space: Ensure sufficient storage for archived WAL files and backups.
4. Backup Strategy: PITR is part of a larger backup strategy, and regular testing of the recovery process is essential.

--- 

## Using active directory

[Postgres and AD](https://www.strongdm.com/blog/connecting-postgres-to-active-directory-for-authentication)

[Integrating PostgreSQL with Active Directory for LDAP Authentication](https://medium.com/@kemalozz/integrating-postgresql-with-active-directory-for-ldap-authentication-360526dfdb25)

## Groups and Roles

Identifying groups for a user

```sql
CREATE ROLE group_role;
CREATE ROLE user_role LOGIN PASSWORD 'xxx';
GRANT group_role TO user_role;

SELECT r.rolname AS member,
       m.rolname AS group
FROM pg_auth_members am
    JOIN pg_roles r ON am.member = r.oid
    JOIN pg_roles m ON am.roleid = m.oid
WHERE r.rolname = 'user_role';



```

---

## Migration


## Migrating DB2 to PostgreSQL

[Migrating from DB2 to PostgreSQL – What You Should Know](https://severalnines.com/blog/migrating-db2-postgresql-what-you-should-know/)

[Converting from other Databases to PostgreSQL](https://wiki.postgresql.org/wiki/Converting_from_other_Databases_to_PostgreSQL)

[IBM DB2 to PostgreSQL Migration](http://www.sqlines.com/db2-to-postgresql)

Additional guide has been added to the extras directory

## Migrating SQL server to PostgreSQL

[Migrate a SQL Server Database to a PostgreSQL Database](https://www.mssqltips.com/sqlservertip/8039/migrate-a-sql-server-database-to-a-postgresql-database/)

[SQL Server to Postgres – A Step-by-Step Migration Journey](https://bryteflow.com/sql-server-vs-postgres-how-to-migrate-sql-to-postgresql/)

[Migrating from SQL Server to PostgreSQL: A Comprehensive Guide](https://pradeepl.com/blog/migrating-from-sql-server-to-postgresql/)



## Oracle to PostgreSQL migration links

[Oracle to PostgreSQL Migration: Challenges and Solutions](https://dataengineeracademy.com/blog/oracle-to-postgresql-migration-challenges-and-solutions/)

[The Complete Oracle to Postgres Migration Guide: Tools, Schema, and Data](https://www.enterprisedb.com/blog/the-complete-oracle-to-postgresql-migration-guide-tutorial-move-convert-database-oracle-alternative)

[Migrating from Oracle to PostgreSQL: A Comprehensive Guide](https://dev.to/pawnsapprentice/migrating-from-oracle-to-postgresql-a-comprehensive-guide-5e8i)

[My Oracle to PostgreSQL Migration: The 7 Tools That Made It Possible](https://www.eversql.com/my-oracle-to-postgresql-migration-the-7-tools-that-made-it-possible/)


## Foreign data wrappers

A Foreign Data Wrapper (FDW) allows access and manipulation of data stored in external databases as if they were part of the database.

To connect to an oracle database

- Define the connection details for the Oracle server.

```sql
CREATE EXTENSION oracle_fdw;

CREATE SERVER oracle_server
FOREIGN DATA WRAPPER oracle_fdw
OPTIONS (dbserver '//oracle_host:1521/orclpdb1');
```

- Map a PostgreSQL user to an Oracle user with the appropriate credentials:

```sql
CREATE USER MAPPING FOR postgres
SERVER oracle_server
OPTIONS (user 'oracle_user', password oracle_password');
```

- Define a foreign table that corresponds to the Oracle table

```sql
CREATE FOREIGN TABLE oracle_employees (
    emp_id INTEGER,
    emp_name TEXT,
    emp_salary NUMERIC
)
SERVER oracle_server
OPTIONS (schema 'ORACLE_SCHEMA', table 'EMPLOYEES');
```

- query the Oracle table as if it were a native table:

```sql
SELECT * FROM oracle_employees WHERE emp_salary > 50000;
```
---

## Database Mocking

[Mock Data Utility](https://github.com/faisaltheparttimecoder/mock-data)

[Pytest and PostgreSQL: Fresh database for every test](https://dev.to/liborjelinek/pytest-and-postgresql-fresh-database-for-every-test-4eni)

[Clean PostgreSQL Databases for Your Tests](https://pytest-pgsql.readthedocs.io/en/latest/)