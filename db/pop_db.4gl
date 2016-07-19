
&include "db.inc"

MAIN
  DEFINE con VARCHAR(300)
	DEFINE db VARCHAR(20)
	DEFINE src,drv STRING

	CALL startlog( base.application.getProgramName()||".log" )

	LET db = fgl_getenv("DBNAME")
	IF db IS NULL OR db = " " THEN LET db = DEF_DBNAME END IF

	LET drv = fgl_getenv("DBDRIVER")
	IF drv IS NULL OR drv = " " THEN LET drv = DEF_DBDRIVER END IF

	IF drv.subString(4,6) != "ifx" THEN
		CALL fgl_winMessage("ERROR","This program is only intended for Informix!","exclamation")
		EXIT PROGRAM
	END IF

	LET src = fgl_getenv("INFORMIXSERVER")

	DISPLAY "DB:",db," FGLPROFILE:",fgl_getenv("FGLPROFILE")," SRC:",src
	LET con = db||"+driver='"||drv||"'" --,source='"||src||"'"

	IF NOT connect( con ) THEN
		EXIT PROGRAM
	END IF

	CALL insert()
END MAIN
---------------------------------------------------
FUNCTION create()
END FUNCTION
---------------------------------------------------
FUNCTION load()
END FUNCTION