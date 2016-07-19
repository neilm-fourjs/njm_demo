

--------------------------------------------------------------------------------
FUNCTION connect( con )
	DEFINE con VARCHAR(300)

	DISPLAY TIME,":Connecting using:",con
	TRY
		DATABASE con
	CATCH
		DISPLAY "Failed:",SQLCA.SQLCODE
		DISPLAY "Error:",STATUS,":",SQLERRMESSAGE
		RETURN FALSE
	END TRY
	RETURN TRUE
END FUNCTION
--------------------------------------------------------------------------------