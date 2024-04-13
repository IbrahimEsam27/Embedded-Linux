include makeconfig

createlib:
	@$(MAKE) -C $(LIB_PATH) $@
build: createlib
	$(CC) $(file) -I $(LIB_PATH) -lmylib -L $(LIB_PATH) -o runprogram

.PHONY: clean
clean:
	@if [ -e $(PATH_TO_OBJECT) ] ; \
	then \
		echo "File exists" ; \
		rm runprogram ; \
		$(MAKE) -C $(LIB_PATH) $@ ; \
	fi ;

