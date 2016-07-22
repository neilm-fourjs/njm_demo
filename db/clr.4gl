
MAIN
	DEFINE l_db STRING
	LET l_db = "../etc/njm_demo.db"
	DATABASE l_db
	DELETE FROM web_access
END MAIN
