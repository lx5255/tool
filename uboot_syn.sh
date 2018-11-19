#!/bin/sh
# echo $filter_path
# echo $file_format


#!/bin/sh

# for common
export common_filter_path="\
			 ! -path "*git*" \
			 ! -path ".*board*" \
			 ! -path ".*74xx_7xx*" \
			 ! -path ".*arm1136*" \
			 ! -path ".*arm720t*" \
			 ! -path ".*arm925t*" \
			 ! -path ".*arm926*" \
			 ! -path ".*arm946*" \
			 ! -path ".*arm_intcm*" \
			 ! -path ".*at32ap*" \
			 ! -path ".*bf533*" \
			 ! -path ".*i386*" \
			 ! -path ".*ixp*" \
			 ! -path ".*lh7a40x*" \
			 ! -path ".*mcf52x2*" \
			 ! -path ".*microblaze*" \
			 ! -path ".*mip*" \
			 ! -path ".*mpc*" \
			 ! -path ".*nios*" \
			 ! -path ".*sa1100*" \
			 ! -path ".*apps_headphone*""
			 # ! -path ".*ac461x_uboot_lib*" \

# for cscope/tag
export ct_filter_path="\
			 ! -path ".*tools*" \
			 ! -path ".*output*" \
			 ! -path ".*download*""

export ct_file_format='.*\.\(c\|h\|s\|S\|ld\|lds\|s51\)'

# for filenametags
export lookup_file_format='.*\.\(c\|h\|s\|S\|ld\|lds\|s51\|lst\|map\)'

rm tags cscope.out filenametags
# for tags
find . $common_filter_path $ct_filter_path -regex $ct_file_format | xargs ctags -R --fields=+lS --languages=+Asm --c++-kinds=+p --fields=+iaS --extra=+q
find ./board/100ask24x0/ $common_filter_path $ct_filter_path -regex $ct_file_format | xargs ctags -R --fields=+lS --languages=+Asm --c++-kinds=+p --fields=+iaS --extra=+q

# for cscope
find . $common_filter_path $ct_filter_path -regex $ct_file_format > cscope.input
find ./board/100ask24x0/ $common_filter_path $ct_filter_path -regex $ct_file_format > cscope.input

cscope -b -i cscope.input

rm cscope.input

#for filenametags
echo -e "!_TAG_FILE_SORTED\t2\t/2=foldcase/">filenametags
find . $common_filter_path -regex $lookup_file_format -type f -printf "%f\t%p\t1\n" | sort -f>>filenametags
find ./board/100ask24x0/ $common_filter_path -regex $lookup_file_format -type f -printf "%f\t%p\t1\n" | sort -f>>filenametags
