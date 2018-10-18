# ifeq ($(HOST_OS), windows)
all:
	echo exichlieddd
	@bash make.sh

clean:
	@find . -depth -name "*.o" -exec rm -f {} \;
lib:

clean_lib:

libs:

clean_libs:

