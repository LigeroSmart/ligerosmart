-- --
-- Update an existing OTRS database from 2.1 to 2.2
-- Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
-- --
-- $Id: DBUpdate-to-2.2.postgresql.sql,v 1.7 2007-03-07 19:33:27 martin Exp $
-- --
--
-- usage: cat DBUpdate-to-2.2.postgresql.sql | psql otrs
--
-- --

--
-- ticket
--
ALTER TABLE ticket ADD freetime3 timestamp(0);
ALTER TABLE ticket ADD freetime4 timestamp(0);
ALTER TABLE ticket ADD freetime5 timestamp(0);
ALTER TABLE ticket ADD freetime6 timestamp(0);
ALTER TABLE ticket ADD type_id INTEGER;
ALTER TABLE ticket ADD service_id INTEGER;
ALTER TABLE ticket ADD sla_id INTEGER;

--
-- ticket_priority
--
ALTER TABLE ticket_priority ADD valid_id SMALLINT NOT NULL DEFAULT 1;
UPDATE ticket_priority SET valid_id = 1;

--
-- ticket_type
--
CREATE TABLE ticket_type (
    id serial,
    name VARCHAR (50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);
INSERT INTO ticket_type
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('default', 1, 1, current_timestamp, 1, current_timestamp);

--
-- ticket_history
--
ALTER TABLE ticket_history ADD type_id INTEGER;

--
-- ticket_history_type
--
INSERT INTO ticket_history_type
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('TypeUpdate', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('ServiceUpdate', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('SLAUpdate', 1, 1, current_timestamp, 1, current_timestamp);

--
-- service
--
CREATE TABLE service (
    id serial,
    name VARCHAR (200) NOT NULL,
    valid_id INTEGER NOT NULL,
    comments VARCHAR (200) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);
ALTER TABLE service ADD FOREIGN KEY (create_by) REFERENCES system_user(id);
ALTER TABLE service ADD FOREIGN KEY (change_by) REFERENCES system_user(id);

--
-- sla
--
CREATE TABLE sla (
    id serial,
    service_id INTEGER NOT NULL,
    name VARCHAR (200) NOT NULL,
    calendar_name VARCHAR (100),
    response_time INTEGER NOT NULL,
    max_time_to_repair INTEGER NOT NULL,
    min_time_between_incidents INTEGER NOT NULL,
    valid_id INTEGER NOT NULL,
    comments VARCHAR (200) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
ALTER TABLE sla ADD FOREIGN KEY (create_by) REFERENCES system_user(id);
ALTER TABLE sla ADD FOREIGN KEY (change_by) REFERENCES system_user(id);
ALTER TABLE sla ADD FOREIGN KEY (service_id) REFERENCES service(id);
