
#+ Create the database.
#+
#+ $Id: mkdb_sqlite.4gl 685 2011-05-05 10:56:18Z  $

IMPORT util
IMPORT os

&include "db.inc"

CONSTANT DB_EXP = "../db/njm_demo.exp/"

DEFINE db,dbfil  VARCHAR(20)
DEFINE dbdir, drv STRING

MAIN
  DEFINE con VARCHAR(300)

	CALL startlog( base.application.getProgramName()||".log" )

	LET db = fgl_getenv("DBNAME")
	IF db IS NULL OR db = " " THEN LET db = DEF_DBNAME END IF

	LET dbdir = fgl_getenv("DBDIR")
	IF dbdir IS NULL OR dbdir = " " THEN LET dbdir = DEF_DBDIR END IF

	LET drv = fgl_getenv("DBDRIVER")
	IF drv IS NULL OR drv = " " THEN LET drv = DEF_DBDRIVER END IF

	IF drv.subString(4,6) != "sqt" THEN
		CALL fgl_winMessage("ERROR","This program is only intended for SQLite!\n"||drv,"exclamation")
		EXIT PROGRAM
	END IF

	IF NOT os.path.exists(dbdir) THEN
		RUN "mkdir "||dbdir
	END IF

	LET dbfil = dbdir||os.path.separator()||db||".db"
	RUN "sqlite3 ||dbfil" WITHOUT WAITING

	DISPLAY "DB:",db," DBDir:",dbdir," SRC:",dbfil
	LET con = "db+driver='"||drv||"',source='"||dbfil||"'"

	IF NOT connect( con ) THEN
		CREATE DATABASE dbfil
		CONNECT TO dbfil
	END IF

	CALL doit()

END MAIN
---------------------------------------------------
FUNCTION create()
	DISPLAY "Creating tables..."
	CREATE TABLE customer (
		customer_code CHAR(8) PRIMARY KEY,
		customer_name VARCHAR(30),
		contact_name VARCHAR(30),
		email VARCHAR(100),
		web_passwd CHAR(10),
		del_addr INTEGER,
		inv_addr INTEGER,
		disc_code CHAR(2),
		credit_limit INTEGER,
		total_invoices DECIMAL(12,2),
		outstanding_amount DECIMAL(12,2)
		--UNIQUE(customer_code)
	)

	CREATE TABLE countries (
		country_code CHAR(3) PRIMARY KEY,
		country_name CHAR(40)
	)

	CREATE TABLE addresses (
		rec_key SERIAL, -- PRIMARY KEY,
		line1 VARCHAR(40),
		line2 VARCHAR(40),
		line3 VARCHAR(40),
		line4 VARCHAR(40),
		line5 VARCHAR(40),
		postal_code VARCHAR(8),
		country_code CHAR(3),
		UNIQUE(line1, postal_code)
	)
	CREATE INDEX addr_idx ON addresses ( line2, line3 )

	EXECUTE IMMEDIATE "
	CREATE TABLE stock (
		stock_code CHAR(8) PRIMARY KEY,
		stock_cat CHAR(10),
		pack_flag CHAR(1),
		supp_code CHAR(10),
		barcode CHAR(13),
		description CHAR(30),
		price DECIMAL(12,2),
		cost DECIMAL(12,2),
		tax_code CHAR(1),
		disc_code CHAR(2),
		physical_stock INTEGER,
		allocated_stock INTEGER,
		free_stock INTEGER CONSTRAINT ch_free CHECK (free_stock  >= 0),
		long_desc VARCHAR(100),
		img_url VARCHAR(100),
		UNIQUE( barcode )
	)"
	--EXECUTE IMMEDIATE "ALTER TABLE stock ADD CONSTRAINT CHECK (free_stock >= 0)"
	CREATE INDEX stk_idx ON stock ( description )

	CREATE TABLE pack_items (
		pack_code CHAR(8),
		stock_code CHAR(8),
		qty INTEGER,
		price DECIMAL(12,2),
		cost DECIMAL(12,2),
		tax_code CHAR(1),
		disc_code CHAR(2)
	)

	CREATE TABLE stock_cat (
		catid CHAR(10),
		cat_name CHAR(80)
	);

	CREATE TABLE supplier (
		supp_code CHAR(10),
		supp_name CHAR(80),
		disc_code CHAR(2),
		addr_line1 VARCHAR(40),
		addr_line2 VARCHAR(40),
		addr_line3 VARCHAR(40),
		addr_line4 VARCHAR(40),
		addr_line5 VARCHAR(40),
		postal_code VARCHAR(8),
		tel CHAR(20),
		email VARCHAR(60)
	)

	CREATE TABLE ord_head (
		order_number SERIAL, -- PRIMARY KEY,
		order_datetime DATETIME YEAR TO SECOND,
		order_date DATE,
		order_ref VARCHAR(40),
		req_del_date DATE,
		customer_code VARCHAR(8),
		customer_name VARCHAR(30),
		del_address1 VARCHAR(40),
		del_address2 VARCHAR(40),
		del_address3 VARCHAR(40),
		del_address4 VARCHAR(40),
		del_address5 VARCHAR(40),
		del_postcode VARCHAR(8),
		inv_address1 VARCHAR(40),
		inv_address2 VARCHAR(40),
		inv_address3 VARCHAR(40),
		inv_address4 VARCHAR(40),
		inv_address5 VARCHAR(40),
		inv_postcode VARCHAR(8),
		username CHAR(8),
		items INTEGER,
		total_qty INTEGER,
		total_nett DECIMAL(12,2),
		total_tax DECIMAL(12,2),
		total_gross DECIMAL(12,2),
		total_disc DECIMAL(12,3)
	)
--	CREATE UNIQUE INDEX oh_idx ON ord_head ( order_number )

	CREATE TABLE ord_payment (
		order_number INTEGER,
		payment_type CHAR(1),
		del_type CHAR(1),
		card_type CHAR(1),
		card_no CHAR(20),
		expires_m SMALLINT,
		expires_y SMALLINT,
		issue_no SMALLINT,
		payment_amount DECIMAL(12,2),
		del_amount DECIMAL(6,2)
	)

	CREATE TABLE ord_detail (
		order_number INTEGER,
		line_number SMALLINT,
		stock_code VARCHAR(8),
		pack_flag CHAR(1),
		price DECIMAL(12,2),
		quantity INTEGER,
		disc_percent DECIMAL(5,2),
		disc_value DECIMAL(10,3),
		tax_code CHAR(1),
		tax_rate DECIMAL(5,2),
		tax_value DECIMAL(10,2),
		nett_value DECIMAL(10,2),
		gross_value DECIMAL(10,2),
			PRIMARY KEY (order_number, line_number),
			FOREIGN KEY (order_number) REFERENCES ord_head
	)

	CREATE TABLE disc (
		stock_disc CHAR(2),
		customer_disc CHAR(2),
		disc_percent DECIMAL(5,2),
			PRIMARY KEY (stock_disc, customer_disc)
	)

	CREATE TABLE sys_users (
		user_key SERIAL, -- PRIMARY KEY,
		username VARCHAR(10),
		fullname VARCHAR(40),
		password VARCHAR(20),
		email VARCHAR(40),
		office_tel VARCHAR(30),
		mobile_tel VARCHAR(30),
		def_cust VARCHAR(8),
		user_type CHAR(1),
		prog_no SMALLINT,
		active CHAR(1)
	)
	CREATE TABLE sys_user_roles (
		user_key INTEGER,
		role_key INTEGER,
		active CHAR(1),
			PRIMARY KEY (user_key, role_key)
	)
	CREATE TABLE sys_roles (
		role_key SERIAL, -- PRIMARY KEY,
		role_type CHAR(1),
		role_name VARCHAR(30),
		active CHAR(1)
	)
	CREATE TABLE sys_menus (
		menu_key	SERIAL,
		m_id      VARCHAR(6),
		m_pid     VARCHAR(6),
		m_type    CHAR(1),
		m_text    VARCHAR(40),
		m_item    VARCHAR(80),
		m_passw   VARCHAR(8)
	);
	CREATE TABLE sys_menu_roles (
		menu_key INTEGER,
		role_key INTEGER,
		active CHAR(1),
			PRIMARY KEY (menu_key, role_key)
	)
	DISPLAY "Done."
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION load()
	DEFINE l_dbfil, l_line, l_line2 STRING
	DEFINE c base.Channel
	LET c = base.Channel.create()
	CALL c.openFile( DB_EXP||"njm_demo.sql","r")
	WHILE NOT c.isEof()
		LET l_line = c.readLine()
		IF l_line.subString(1,7) = "{ TABLE" THEN
			LET l_line2 = c.readLine()
			IF l_line2.getLength() < 8 OR l_line2.subString(1,8) != "{ unload" THEN
				LET l_line2 = c.readLine()
			END IF
			CALL process_line( l_line, l_line2 ) 
		END IF
	END WHILE

	CALL insert_system()

END FUNCTION
--------------------------------------------------------------------------------
FUNCTION process_line( l_line1, l_line2 )
	DEFINE l_line1, l_line2 STRING
	DEFINe l_tab, l_fil STRING
	DEFINE l_st base.StringTokenizer
	IF l_line2.subString(1,8) != "{ unload" THEN RETURN END IF

	--DISPLAY "Line1:",l_line1
	--DISPLAY "Line2:",l_line2

	LET l_st = base.StringTokenizer.create(l_line1," ")
	LET l_tab = l_st.nextToken() # { 
	LET l_tab = l_st.nextToken() # TABLE
	LET l_tab = l_st.nextToken() # table name

	LET l_st = base.StringTokenizer.create(l_line2," ")
	LET l_fil = l_st.nextToken() # {
	LET l_fil = l_st.nextToken() # unload
	LET l_fil = l_st.nextToken() # file
	LET l_fil = l_st.nextToken() # name
	LET l_fil = l_st.nextToken() # =
	LET l_fil = l_st.nextToken() # file-name

	DISPLAY "Tab:",l_tab, " File:",l_fil

	EXECUTE IMMEDIATE "delete from "||l_tab
	TRY
		CASE l_tab 
			WHEN "addresses"
				LOAD FROM DB_EXP||l_fil INSERT INTO addresses
			WHEN "countries"
				LOAD FROM DB_EXP||l_fil INSERT INTO countries
			WHEN "customer"
				LOAD FROM DB_EXP||l_fil INSERT INTO customer
			WHEN "disc"
				LOAD FROM DB_EXP||l_fil INSERT INTO disc
			WHEN "ord_detail"
				LOAD FROM DB_EXP||l_fil INSERT INTO ord_detail
			WHEN "ord_head"
				LOAD FROM DB_EXP||l_fil INSERT INTO ord_head
			WHEN "ord_payment"
				LOAD FROM DB_EXP||l_fil INSERT INTO ord_payment
			WHEN "pack_items"
				LOAD FROM DB_EXP||l_fil INSERT INTO pack_items
			WHEN "stock"
				LOAD FROM DB_EXP||l_fil INSERT INTO stock
			WHEN "stock_cat"
				LOAD FROM DB_EXP||l_fil INSERT INTO stock_cat
			WHEN "supplier"
				LOAD FROM DB_EXP||l_fil INSERT INTO supplier
		{	WHEN "sys_menu_roles"
				LOAD FROM DB_EXP||l_fil INSERT INTO sys_menu_roles
			WHEN "sys_menus"
				LOAD FROM DB_EXP||l_fil INSERT INTO sys_menus
			WHEN "sys_roles"
				LOAD FROM DB_EXP||l_fil INSERT INTO sys_roles
			WHEN "sys_users"
				LOAD FROM DB_EXP||l_fil INSERT INTO sys_users }
		END CASE
	CATCH
		DISPLAY "Failed:",SQLCA.SQLERRD[2],":",SQLERRMESSAGE
	END TRY

END FUNCTION