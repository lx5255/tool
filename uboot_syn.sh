#!/bin/sh
# echo $filter_path
# echo $file_format
export BOARD_DIR="./board/100ask24x0/" 
export CPU_DIR="./cpu/arm920t/" 

 export common_filter_path="\
 			  ! -path ".*git*""\ 
 			  # ! -path ".*cpu*""
 			  # -path ".*drivers*" \
 			  # -path ".*dtt*" \
 			  # -path ".*fs*" \
 			  # -path ".*include*" \
 			  # -path ".*lib_arm*" \
 			  # -path ".*nand_spl*" \
 			  # -path ".*net*" \
 			  # -path ".*post*" \
 			  # -path ".*rtc*" \
 			  # -path ".*100ask24x0*"" \

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
find . \( $common_fil0ter_path \) $ct_filter_path -regex $ct_file_format | xargs ctags -R --fields=+lS --languages=+Asm --c++-kinds=+p --fields=+iaS --extra=+q

# find ./board/100ask24x0/ $common_filter_path $ct_filter_path -regex $ct_file_format | xargs ctags -R --fields=+lS --languages=+Asm --c++-kinds=+p --fields=+iaS --extra=+q

# for cscope
find . ! -path "./board*"\
       ! -path "./cpu*"\
    -regex $ct_file_format > cscope.input
find $BOARD_DIR  -regex $ct_file_format >> cscope.input
find $CPU_DIR  -regex $ct_file_format >> cscope.input
# find ./board/100ask24x0/ $common_filter_path $ct_filter_path -regex $ct_file_format > cscope.input

cscope -b -i cscope.input

rm cscope.input

#for filenametags
echo -e "!_TAG_FILE_SORTED\t2\t/2=foldcase/">filenametags
# find . $common_filter_path -regex $lookup_file_format -type f -printf "%f\t%p\t1\n" | sort -f>>filenametags

find . ! -path "./board*"\
       ! -path "./cpu*"\
    -regex $lookup_file_format -type f -printf "%f\t%p\t1\n" | sort -f>>filenametags

find $BOARD_DIR  -regex $lookup_file_format  -type f -printf "%f\t%p\t1\n" | sort -f>>filenametags 
# find ./cpu/arm920t/ -regex $lookup_file_format  -type f -printf "%f\t%p\t1\n" | sort -f>>filenametags 
find $CPU_DIR -regex $lookup_file_format  -type f -printf "%f\t%p\t1\n" | sort -f>>filenametags 
