/* drops all tables */

DROP TABLE employees CASCADE;
DROP TABLE customers CASCADE;
DROP TABLE books CASCADE;
DROP TABLE orders CASCADE;
DROP TABLE orderline CASCADE ;
DROP TABLE events CASCADE;
DROP TABLE locations CASCADE ;
DROP TABLE membership CASCADE;
DROP TABLE rentals CASCADE;
DROP TABLE storestock CASCADE;
DROP TABLE copies CASCADE;

/* creates tables */

CREATE TABLE books (
    isbn          NUMERIC(15) NOT NULL,
    title         VARCHAR(50),
    afirstname    VARCHAR(20),
    alastname     VARCHAR(20),
    price         DECIMAL(10,2),
    publishdate   DATE,
    CONSTRAINT books_pk PRIMARY KEY ( isbn )
);

CREATE TABLE copies (
    copynbr                INTEGER NOT NULL,
    locations_locationid   INTEGER NOT NULL,
    books_isbn             NUMERIC(15) NOT NULL,
    CONSTRAINT copies_pk PRIMARY KEY ( locations_locationid,
    copynbr, books_isbn )
);

CREATE TABLE customers (
    customerid   NUMERIC(10) NOT NULL,
    cfirstname   VARCHAR(15),
    clastname    VARCHAR(15),
    address      VARCHAR(30),
    city         VARCHAR(30),
    state        VARCHAR(2),
    zip          NUMERIC(5),
    CONSTRAINT customers_pk PRIMARY KEY ( customerid )
);

CREATE TABLE employees (
    employeeid    NUMERIC(10) NOT NULL,
    firstname     VARCHAR(15),
    lastname      VARCHAR(15),
    salary        NUMERIC(10,2),
    hoursworked   NUMERIC(10,2),
    CONSTRAINT employees_pk1 PRIMARY KEY ( employeeid )
);

CREATE TABLE events (
    eventid                INTEGER NOT NULL,
    eventdate              DATE,
    eventtype              VARCHAR(20),
    eventdescription       VARCHAR(70),
    locations_locationid   INTEGER NOT NULL,
    CONSTRAINT events_pk PRIMARY KEY ( eventid )
);


CREATE TABLE locations (
    locationid   INTEGER NOT NULL,
    address      VARCHAR(30),
    city         VARCHAR(30),
    state        VARCHAR(2),
    zip          NUMERIC(5),
    capacity     INTEGER,
    CONSTRAINT locations_pk PRIMARY KEY ( locationid )
);


CREATE TABLE membership (
    memstartdate           DATE NOT NULL,
    memenddate             DATE,
    memtype                VARCHAR(3),
    customers_customerid   NUMERIC(10) NOT NULL
);

CREATE UNIQUE INDEX membership__idx ON
    membership ( customers_customerid ASC );

ALTER TABLE membership ADD CONSTRAINT membership_pk PRIMARY KEY ( memstartdate,
customers_customerid );




CREATE TABLE orders (
    orderid                NUMERIC(10) NOT NULL,
    employees_employeeid    NUMERIC(10) NOT NULL,
    customers_customerid   NUMERIC(10) NOT NULL,
    locations_locationid   INTEGER NOT NULL,
    CONSTRAINT orders_pk PRIMARY KEY ( orderid )
);

CREATE TABLE orderline (
    unitssold        INTEGER,
    price            DECIMAL(10,2),
    orders_orderid   NUMERIC(10) NOT NULL,
    books_isbn       NUMERIC(15) NOT NULL,
    CONSTRAINT orderline_pk1 PRIMARY KEY ( orders_orderid,
books_isbn )
);


CREATE TABLE rentals (
    rentdate               DATE NOT NULL,
    todate                 DATE NOT NULL,
    returneddate           DATE,
    status                 VARCHAR(10),
    overduefine            NUMERIC(10,2),
    customers_customerid   NUMERIC(10) NOT NULL,
    employees_employeeid    NUMERIC(10) NOT NULL,
    copies_locations_locationid   INTEGER NOT NULL,
    copies_copynbr                INTEGER NOT NULL,
    copies_books_isbn             NUMERIC(15) NOT NULL,
    renttime                      NUMERIC(2,2) NOT NULL,
    CONSTRAINT rentals_pk PRIMARY KEY ( customers_customerid,
    copies_locations_locationid,
    copies_copynbr,
    copies_books_isbn,
    rentdate,
    renttime )
);

CREATE TABLE storestock (
    locations_locationid   INTEGER NOT NULL,
    books_isbn             NUMERIC(15) NOT NULL,
    quantity               INTEGER,
    CONSTRAINT storestock_pk PRIMARY KEY ( locations_locationid,
books_isbn )
);

/* adds foreign keys */

ALTER TABLE events
    ADD CONSTRAINT events_locations_fk FOREIGN KEY ( locations_locationid )
        REFERENCES locations ( locationid );
        
ALTER TABLE copies
    ADD CONSTRAINT copies_books_fk FOREIGN KEY ( books_isbn )
        REFERENCES books ( isbn );

ALTER TABLE copies
    ADD CONSTRAINT copies_locations_fk FOREIGN KEY ( locations_locationid )
        REFERENCES locations ( locationid );
        
 ALTER TABLE orders
    ADD CONSTRAINT orders_locations_fk FOREIGN KEY ( locations_locationid )
        REFERENCES locations ( locationid );
        
ALTER TABLE rentals
    ADD CONSTRAINT rentals_books_fk FOREIGN KEY ( books_isbn )
        REFERENCES books ( isbn );

ALTER TABLE rentals
    ADD CONSTRAINT rentals_copies_fk FOREIGN KEY ( copies_locations_locationid,
    copies_copynbr,
    copies_books_isbn )
        REFERENCES copies ( locations_locationid,
        copynbr,
        books_isbn );

ALTER TABLE rentals
    ADD CONSTRAINT rentals_customers_fk FOREIGN KEY ( customers_customerid )
        REFERENCES customers ( customerid );

ALTER TABLE rentals
    ADD CONSTRAINT rentals_employee_fk FOREIGN KEY ( employee_employeeid )
        REFERENCES employee ( employeeid );

ALTER TABLE membership
    ADD CONSTRAINT membership_customers_fk FOREIGN KEY ( customers_customerid )
        REFERENCES customers ( customerid );

ALTER TABLE orders
    ADD CONSTRAINT orders_customers_fk FOREIGN KEY ( customers_customerid )
        REFERENCES customers ( customerid );

ALTER TABLE orders
    ADD CONSTRAINT orders_employees_fk FOREIGN KEY ( employees_employeeid )
        REFERENCES employees ( employeeid );

ALTER TABLE orderline
    ADD CONSTRAINT orderline_books_fk FOREIGN KEY ( books_isbn )
        REFERENCES books ( isbn );

ALTER TABLE orderline
    ADD CONSTRAINT orderline_orders_fk FOREIGN KEY ( orders_orderid )
        REFERENCES orders ( orderid );

ALTER TABLE storestock
    ADD CONSTRAINT storestock_books_fk FOREIGN KEY ( books_isbn )
        REFERENCES books ( isbn );

ALTER TABLE storestock
    ADD CONSTRAINT storestock_locations_fk FOREIGN KEY ( locations_locationid )
        REFERENCES locations ( locationid );
    
COMMIT;

    /* inserts data */  

LOAD DATA INFILE 'c:/books.csv' 
INTO TABLE books 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(isbn, title, afirstname, alastname, price, publishdate);

LOAD DATA INFILE 'c:/copies.csv' 
INTO TABLE copies 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(copynbr, locations_locationid, books_isbn);

LOAD DATA INFILE 'c:/customers.csv' 
INTO TABLE customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(customerid,
    cfirstname,
    clastname,
    address,
    city,
    state,
    zip);

LOAD DATA INFILE 'c:/employees.csv' 
INTO TABLE employees
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(employeeid,
    firstname,
    lastname,
    salary,
    hoursworked);

LOAD DATA INFILE 'c:/events.csv' 
INTO TABLE events
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(eventid,
    eventdate,
    eventtype,
    eventdescription,
    locations_locationid);

LOAD DATA INFILE 'c:/locations.csv' 
INTO TABLE locations 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(locationid,
    address,
    city,
    state,
    zip,
    capacity);

LOAD DATA INFILE 'c:/membership.csv' 
INTO TABLE membership
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(memstartdate,
    memenddate,
    memtype,
    customers_customerid);

LOAD DATA INFILE 'c:/rentals.csv' 
INTO TABLE rentals 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(rentdate,
    todate,
    returneddate,
    status,
    overduefine,
    customers_customerid,
    employees_employeeid,
    copies_locations_locationid,
    copies_copynbr,
    copies_books_isbn,
    renttime );

LOAD DATA INFILE 'c:/storestock.csv' 
INTO TABLE storestock
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
( locations_locationid,
    books_isbn,
    quantity);

LOAD DATA INFILE 'c:/orders.csv' 
INTO TABLE orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(orderid,
    employees_employeeid,
    customers_customerid,
    locations_locationid);

LOAD DATA INFILE 'c:/orderline.csv' 
INTO TABLE orderline 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(unitssold,
    price,
    orders_orderid,
    books_isbn);



COMMIT;