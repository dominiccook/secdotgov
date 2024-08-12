set foreign_key_checks = 0;

drop database if exists secdotgov;
create database secdotgov;

use secdotgov;

drop table if exists companies;
create table companies (
    company_id int auto_increment not null,
    title varchar(155),
    ticker varchar(55),
    cik_str int(10),
    primary key (company_id)
);

drop table if exists archive_links;
create table archive_links (
    archive_link_id int auto_increment not null,
    host varchar(155),
    path varchar(255),
    submission_type varchar(55),
    company_id int,
    primary key (archive_link_id)
);

drop table if exists filings;
create table filings (
    filing_id int auto_increment not null,
    company_id int,
    quarter_id int,
    file_type varchar(55),
    primary key (filing_id)
);

drop table if exists quarters;
create table quarters (
    quarter_id int auto_increment not null,
    ended_date date,
    quarter VARCHAR(10) GENERATED ALWAYS AS (CONCAT('Q',QUARTER(ended_date), LPAD(EXTRACT(YEAR FROM ended_date) % 100, 2, '0'))),
    primary key (quarter_id)
);

drop table if exists amounts;
create table amounts (
    amount_id int auto_increment not null,
    filing_id int,
    field varchar(155),
    statement varchar(155),
    amount decimal(28,2),
    primary key (amount_id)
);

alter table archive_links 
add constraint `archive_links_idx_1` 
foreign key (`company_id`) 
references `companies` (`company_id`) 
on delete cascade on update cascade;

alter table filings
add constraint `filings_idx_1`
foreign key (`company_id`)
references `companies` (`company_id`) 
on delete cascade on update cascade,
add constraint `filings_idx_2`
foreign key (`quarter_id`)
references `quarters` (`quarter_id`) 
on delete cascade on update cascade;

alter table amounts 
add constraint `amounts_idx_1` 
foreign key (`filing_id`) 
references `filings` (`filing_id`) 
on delete cascade on update cascade;

source insert_companies.sql;
