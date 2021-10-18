NAME = main
RES = resource

ML_FLAG = /c /coff
LINK_FLAG = /subsystem:windows

$(NAME).exe: $(NAME).obj $(RES).res
	Link  $(LINK_FLAG) $(NAME).obj $(RES).res

.asm.obj:
	ml $(ML_FLAG) $<
.rc.res:
	rc $<

clean:
	del *.obj
	del *.res
