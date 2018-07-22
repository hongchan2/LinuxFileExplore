#!/bin/bash

declare -a files			# store all files in current directory
declare -i INDEX=0			# files array index
declare -i x_current
declare -i y_current
declare -i x_print
declare -i y_print
declare -i index_num			# total index number
declare -a dir_path
declare -a file_path
declare -a file_origin_path		# store original path
declare -i print_tree_cnt=0		# to treat exception

call_print_SecondWin="false"		# to Optimization program ( add 2nd project )
call_print_ThirdWin="false"		# to Optimization program ( add 2nd project )
zip="*.zip"				# to treat compressed file
gz="*.gz"				# to treat compressed file
trashbin="2015202065-TrashBin"		# to treat trash bin
trashbin_path="${HOME}/${trashbin}"	# store trashbin path
in_trash="false"			# trash or not

firstPrint() {		# function1 to make window
	for (( i=0; i<47+$1; i++ ))
	do
		echo -n "="
	done
}

secondPrint() {		# function2 to make window
	for (( i=0; i<6+$1; i++ ))
	do
		echo "|"
	done
}

secondPrintDraw(){	# function3 to make window
	for (( i=2; i<30; i++ ))
	do
		tput cup $i $1
		echo "|"
	done
}

printBorder() {		# function to make entire window border
	tput cup 0 0
	firstPrint "0"
	echo -n  " 2015202065 HongChan Yun  "
	firstPrint "0"
	echo ""
	firstPrint "10"
	echo -n " List "
	firstPrint "10"
	echo ""
	secondPrint "22"
	secondPrintDraw "29"
	secondPrintDraw "76"
	secondPrintDraw "119"
	firstPrint "6"
	echo -n " Information "
	firstPrint "7"
	echo ""
	secondPrint "0"
	firstPrint "9"
	echo -n " Total "
	firstPrint "10"
	echo -e "\n|"
	firstPrint "10"
	echo -n " END "
	firstPrint "11"
}

sortDir() {		# function to get directory from all current directory and files
	declare -a dirArr
	declare -i j=0
	arr=("${!1}")

	for (( i=0; i<${#arr[@]}; i++ ))
	do
		if [ -d "${arr[i]}" ]
		then
			dirArr[j]=${arr[i]}				
			j=${j}+1
		fi
	done
	files=("${dirArr[@]}")
}

sortFile() {		# function to get files from all current directory and files
	declare -a fileArr
	declare -i j=0
	arr=("${!1}")

	for (( i=0; i<${#arr[@]}; i++ ))
	do
		if [ -f ${arr[i]} ]
		then
			fileArr[j]=${arr[i]}
			j=${j}+1
		fi
	done
	files=("${files[@]}" "${fileArr[@]}")
}

firstWindow_Exception() {	# function to deal exception (long directory and file name)
	tput cup ${y_print} 26
	echo -n "..."
	tput cup ${y_print} 29
	echo -n "|                            "
}	

printFirst_Window() {		# function to print ordered all current directory and files
	parr=("${!1}")
	y_print=2
	
	for (( i=0; i<${#parr[@]}; i++ ))
	do
		tput cup ${y_print} 1
		if [ ${#parr[$i]} -gt 27 ]
		then
			if [ -d ${parr[$i]} ]
			then
				echo [34m "${parr[$i]}" [0m
				firstWindow_Exception
			elif [ -f ${parr[$i]} ]
			then
				if [ -x ${parr[$i]} ]
				then
					echo [32m "${piarr[$i]}" [0m
					firstWindow_Exception
	
				elif [ ${parr[$i]} = ${zip} ] || [ ${parr[$i]} = ${gz} ]
				then
					echo [31m "${parr[$i]}" [0m
					firstWindow_Exception
				else
				tput cup ${y_print} 2
				echo "${parr[$i]}"
				firstWindow_Exception
				fi
			fi
		else	
			if [ -d ${parr[$i]} ]
			then
				if [ ${parr[$i]} = ${trashbin} ]	# add 2nd project
				then
					echo [33m "${parr[$i]}" [0m
				else
					echo [34m "${parr[$i]}" [0m
				fi
			elif [ -f ${parr[$i]} ]
			then
				if [ -x ${parr[$i]} ]
				then
					echo [32m "${parr[$i]}" [0m
				elif [ ${parr[$i]} = ${zip} ] || [ ${parr[$i]} = ${gz} ]
				then
					echo [31m "${parr[$i]}" [0m
				else
					tput cup ${y_print} 2
					echo "${parr[$i]}"
				fi
			fi
		fi		
		if [ ${y_print} -gt 29 ]	# to deal exception (too many directories and files)
		then
			tput cup 29 2
			echo -n "                       "
			tput cup 29 2
			echo -n "..."
			echo 
			tput cup 30 0
			echo -n "============================="
			break
		fi
		y_print=${y_print}+1
	done
}

getcurrentTreeDir() {
	declare -a arr
	declare -i i=1

	for var in *
	do
		arr[i]=$var
		i=$i+1	
	done
	
	sort_TreeDir arr[@]
	sort_TreeFile arr[@]
}

getcurrentDir() {	# function to get unordered all current directory and files
	declare -a arr[0]=".."
	declare -i i=1

	for var in *
	do
		arr[i]=$var
		i=${i}+1
	done
	
	files=(${arr[@]})
#	sortDir arr[@]
#	sortFile arr[@]
}

secondWindow_Exception() {	# function to deal exception (about long width)
	x_print=76
	y_print=2
	
	for (( i=0; i<28; i++ ))
	do
		tput cup ${y_print} ${x_print}
		echo "|                                          "
		y_print=${y_print}+1
	done
}

printSecond_Window() {	# function to print file content
	x_print=30
	y_print=2
	f_lenght=`cat ${files[$INDEX]} | wc -l`

	tput cup ${y_print} ${x_print}
	for (( i=0; i<f_lenght; i++ ))
	do
		if [ $i -gt 27 ] 	# to deal exception (about long lenght)
		then 
			break 
		fi
		more +`expr ${i} + 1` ${files[$INDEX]} | head -n 1
		y_print=${y_print}+1
		tput cup ${y_print} ${x_print}
	done
	secondWindow_Exception
}

search_Tree(){
	x_print=77
	y_print=${y_print}+1
	tput cup ${y_print} ${x_print}

	local name=$1		# define local variable, because it is recursive function
	local path=$2		# define local variavle, because it is recursive function
	declare -i depth=$3		
	declare -i depth_min=4*depth	# all varialbe at bottom declared for treat exception
	declare -i max=38-${depth_min}
#	declare -i max="39-4*depth"
	declare -i lenght=${#name}
	declare -i result=${max}-${lenght}	
	declare -i f_result=${max}-${lenght}+3

	print_tree_cnt=${print_tree_cnt}+1
	if [ "${print_tree_cnt}" -ge "29" ]	# to deal exception (too long tree <long lenght>) 29
	then
		return
	fi

	if [ ${depth} -eq 6 ]			# to print 5 depth tree 
	then
		depth=0
		y_print=${y_print}-1
		return
	fi

	for (( i=0; i<${depth}; i++ ))		# to print tree structure
	do
		echo -n "...."		
	done

	if [ -d "${path}/${name}" ]
	then
		if [ ${result} -lt 1 ]
		then
			echo -n " -" [34m "   ..." [0m	# to treat exception (too long width)
			return
		fi
	elif [ -f "${path}/${name}" ]
	then
		if [ ${f_result} -lt 1 ]
		then
			if [ -x "${path}/${name}" ]
			then
				echo -n [32m "     ..." [0m
			elif [ ${name} = ${zip} ] || [ ${name} = ${gz} ]
			then
				echo -n [31m "     ..." [0m
			else
				echo -n "       ..."
			fi
			return
		fi
	fi
	
	if [ -d "${path}/${name}" ]
	then
		echo -n " -" [34m "${name}" [0m
	elif [ -f "${path}/${name}" ]
	then
		if [ -x "${path}/${name}" ]
		then
			echo -n [32m "${name}" [0m
		elif [ ${name} = ${zip} ] || [ ${name} = ${gz} ]
		then
			echo -n [31m "${name}" [0m
		else
			echo -n " ${name}"
		fi
	fi
	if [ -d "${path}/${name}" ]		# recursive call to print tree directory structure
	then
		for next in `ls ${path}/${name}`
		do
			search_Tree "${next}" "${path}/${name}" "${depth}+1"
		done
	fi
}

printAccessTime(){
	year=`stat -c %x ${files[$INDEX]} | cut -c 1-4` 	# to print year
	month=`stat -c %x ${files[$INDEX]} | cut -c 6-7`	# to print month
	day=`stat -c %x ${files[$INDEX]} | cut -c 9-10`		# to print day
	time=`stat -c %x ${files[$INDEX]} | cut -c 12-19`	# to print time
	

	case "${month}"
	in
		01) month="Jan";;
		02) month="Feb";;
		03) month="Mar";;
		04) month="Apr";;
		05) month="May";;
		06) month="Jun";;
		07) month="Jul";;
		08) month="Aug";;
		09) month="Sep";;
		10) month="Oct";;
		11) month="Nov";;
		12) month="Dec";;
	esac

	echo "Access time: ${month} ${day} ${time} ${year}"
}

printFourth_Window() {	# function to print directory or file's information
	y_print=31

	tput cup ${y_print} 1
	echo "file name : ${files[$INDEX]}"
	y_print=${y_print}+1	

	tput cup ${y_print} 1
	if [ -d ${files[$INDEX]} ]
	then
		if [ ${files[$INDEX]} = ${trashbin} ]
		then
			echo "File type :" [33m "TrashBin" [0m
		else
			echo "File type :" [34m "Directory" [0m 	# change for 2nd project (upper alpabet)
		fi
	elif [ -f ${files[$INDEX]} ]
	then
		if [ -x ${files[$INDEX]} ]
		then
			echo "File type :" [32m "Execute file" [0m
		elif [ ${files[$INDEX]} = ${zip} ] || [ ${files[$INDEX]} = ${gz} ]
		then
			echo "File type :" [31m "Compressed file" [0m
		else
			echo "file type : Normal file"
		fi
	fi
	y_print=${y_print}+1

	tput cup ${y_print} 1
	echo "File size : `du -sh ${files[$INDEX]} | cut -f 1`"	# change for 2nd project (human readable size)
	y_print=${y_print}+1

	tput cup ${y_print} 1
	printAccessTime
	y_print=${y_print}+1

	tput cup ${y_print} 1
	echo "Permission : `stat -c %a ${files[$INDEX]}`"
	y_print=${y_print}+1

	tput cup ${y_print} 1
	echo "Absolute path : $PWD/${files[$INDEX]}"
	
	tput cup ${y_current} ${x_current}	# reset current x and y
}

printFifth_Window() {	# function to print current directory's total information
	x_print=20
	y_print=38
	declare -i cnt_total=`ls | wc -w`
	declare -i cnt_dir=`ls -lF | grep / | wc -l`
	declare -i cnt_sfile=0
	declare -i cnt_allfile=0
	declare -i cnt_file=0
	
	for (( i=0; i<${#files[@]}; i++ ))	# to count files and Sfiles
	do
		if [ -d ${files[$i]} ]
		then
			if [ ${files[$i]} = ${trashbin} ]	# add 2nd project
			then
				cnt_total=${cnt_total}-1
				cnt_dir=${cnt_dir}-1
			fi	
		elif [ -f ${files[$i]} ]
		then
			cnt_allfile=${cnt_allfile}+1
			if [ -x ${files[$i]} ] || [ ${files[$i]} = ${zip} ] || [ ${files[$i]} = ${gz} ]
			then
				cnt_sfile=${cnt_sfile}+1
			fi
		fi
	done
	cnt_file=${cnt_allfile}-${cnt_sfile}

	tput cup ${y_print} ${x_print}
	echo "Total: ${cnt_total}, Directory: ${cnt_dir}, SFile: ${cnt_sfile}, NFile: ${cnt_file}, Size: `du -sh | cut -f 1`"
	# change for 2nd project (upper alpabet and human readable size)
}

clearFirst_Window() {	# function to clear first window
	x_print=1
	y_print=2

	for (( i=0; i<28; i++ ))
	do
		for (( j=0; j<28; j++ ))
		do
			tput cup ${y_print} ${x_print}
			echo -n " "
			x_print=${x_print}+1
		done
			x_print=1
			y_print=${y_print}+1
	done
}

clearThird_Window() {	# function to clear third window
	x_print=77
	y_print=2

	for (( i=0; i<28; i++ ))
	do
		for (( j=0; j<42; j++ ))
		do
			tput cup ${y_print} ${x_print}
			echo -n " "
			x_print=${x_print}+1
		done
			x_print=77
			y_print=${y_print}+1
	done
}

clearSecond_Window() {	# function to clear second window
	x_print=30
	y_print=2
	
	for (( i=0; i<28; i++ ))
	do
		for (( j=0; j<46; j++ ))
		do
			tput cup ${y_print} ${x_print}		
			echo -n " "
			x_print=${x_print}+1
		done
			x_print=30
			y_print=${y_print}+1
	done
}

clearFourth_Window() {	# function to clear fourth window
	x_print=1
	y_print=31

	for (( i=0; i<6; i++ ))
	do
		for (( j=0; j<118; j++ ))
		do
			tput cup ${y_print} ${x_print}
			echo -n " "
			x_print=${x_print}+1
		done
			x_print=1
			y_print=${y_print}+1
	done	
}

clearFifth_Window() {	# function to clear fifth window
	x_print=1
	y_print=38

	for (( j=0; j<110; j++ ))
	do
		tput cup ${y_print} ${x_print}
		echo -n " "
		x_print=${x_print}+1
	done
}

remove_trash() {	# function to remove at trashbin
	if [ -d ${files[$INDEX]} ]
	then
		rm -r ${files[$INDEX]}
	else
		rm ${files[$INDEX]}
	fi
}

get_dir_file_path(){	# function to store all directory and file path
	local name=$1			# define local variable, because it is recursive function
	local path_origin=$2		# define local variable, because it is recursive function
	local path=$3			# define local variable, because it is recursive function
	
	if [ -d "${path_origin}/${name}" ]
	then
		dir_path=("${dir_path[@]}" "${path}/${name}")				# store path
	elif [ -f "${path_origin}/${name}" ]
	then
		file_path=("${file_path[@]}" "${path}/${name}")				# store path
		file_origin_path=("${file_origin_path[@]}" "${path_origin}/${name}")	# store absoulte path
	fi

	if [ -d "${path_origin}/${name}" ]
	then
		for next in `ls ${path_origin}/${name}`
		do
			get_dir_file_path "${next}" "${path_origin}/${name}" "${path}/${name}"	# recursively call
		done
	fi

}

remove_to_trash(){	# function to remove to trashbin
	if [ -d ${files[$INDEX]} ]	# mkdir to make all subdir and cat to copy all files
	then
		get_dir_file_path "${files[$INDEX]}" "${PWD}"
		for (( i=0; i<${#dir_path[@]}; i++ ))
		do
			mkdir -p ${trashbin_path}${dir_path[$i]}
		done
		for (( i=0; i<${#file_path[@]}; i++ ))
		do
			cat ${file_origin_path[$i]} > ${trashbin_path}${file_path[$i]}
		done
		dir_path=()			# reset directory path array
		file_path=()			# reset file path array
		file_origin_path=()		# reset file original path array
		rm -r ${files[$INDEX]}
	fi	
	if [ -f ${files[$INDEX]} ]
	then
		cat ${files[$INDEX]} > ${trashbin_path}/${files[$INDEX]}	# copy to trashbin
		rm ${files[$INDEX]}
	fi
}

remove() {		# function to remove file and directory
	if [ ${in_trash} = "true" ]
	then
		remove_trash
	else
		remove_to_trash
	fi
	clearFirst_Window	# clear first, fifth and print new first fifth window
	clearFifth_Window
	getcurrentDir
	printFirst_Window files[@]
	printFifth_Window
	INDEX=0
	x_current=2
	y_current=2
	tput cup ${y_current} ${x_current}
}

inputKey() {
	key_up="[A"
	key_down="[B"
	key_enter=""
	key_delete="d"
	key_tree="t"
#	key_space=" "
#	key_return="r"	

	getcurrentDir
	printFirst_Window files[@]
	printFifth_Window	# print current directory's information
	index_num=${#files[@]}-1
	while [ 1 ]
	do
		printFourth_Window		# print directory or file's information
		read -sn 1 key			# change for 2nd project (to get one key)
		if [ "${key}" = "" ]
		then
			read -sn 2 key_two
			key="${key}${key_two}"	# to treat three key
		fi
		if [ "${call_print_SecondWin}" = "true" ]	# optimize program
		then
			clearSecond_Window
			call_print_SecondWin="false"
		fi
		if [ "${call_print_ThirdWin}" = "true" ]	# optimize program
		then
			clearThird_Window
			call_print_ThirdWin="false"
		fi
		if [ "${key}" = "${key_up}" ]	# if input key is up direction
		then
			INDEX=${INDEX}-1
			y_current=${y_current}-1
		elif [ "${key}" = "${key_down}" ]	# if input key is down direction
		then
			if [ ${INDEX} -eq ${index_num} ]	# to deal exception (no more file)
			then
				INDEX=${INDEX}
				y_current=${y_current}
			else
				INDEX=${INDEX}+1
				y_current=${y_current}+1
			fi
		elif [ "${key}" = "${key_enter}" ]	# if input key is enter
		then
			if [ -d ${files[$INDEX]} ]
			then
				if [ "${files[$INDEX]}" = "${trashbin}" ]
				then
					in_trash="true"
				else
					in_trash="false"
				fi
				cd ${files[$INDEX]}
				clearFourth_Window
				clearFirst_Window
				clearFifth_Window
				x_current=2
				y_current=2
				INDEX=0
				tput cup ${y_current} ${x_current}
				inputKey
			elif [ -f ${files[$INDEX]} ]
			then
				if [ ${files[$INDEX]} != ${zip} ] && [ ${files[$INDEX]} != ${gz} ]
				then
					printSecond_Window
					call_print_SecondWin="true"				
				fi
			fi
		elif [ "${key}" = "${key_delete}" ]	# if input key is d
		then
			remove				# to remove file and directory
		elif [ "${key}" = "${key_tree}" ]	# if input key is t
		then
			if [ -d ${files[$INDEX]} ]
			then
				y_print=1
				search_Tree "${files[$INDEX]}" "${PWD}" "0"
				call_print_ThirdWin="true"	# to clean third window
				print_tree_cnt=0		# reset cnt

				x_print=77
				y_print=30
				tput cup ${y_print} ${x_print}
		
				echo -n "=============================="
				echo -n "============="
			fi
		fi
		if [ ${y_current} -eq 1 ]	# to deal exception (invade up area)
		then
			y_current=2
			INDEX=0
		fi
		if [ ${y_current} -eq 30 ] 	# to deal exception (invade down area)
		then
			y_current=29
			INDEX=${INDEX}-1
		fi
		clearFourth_Window
		tput cup ${y_current} ${x_current}
	done
}

main() {			# function to initialize first screen
	clear
	x_current=2
	y_current=2
	printBorder		# print border	
	tput cup ${y_current} ${x_current}
	inputKey
}

main
