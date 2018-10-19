# ifeq ($(HOST_OS), windows)
all:
	@bash make.sh

clean:
	@find . -depth -name "*.o" -exec rm -f {} \;
lib:

clean_lib:

libs:

clean_libs:

