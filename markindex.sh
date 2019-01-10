markconf_title="望哥的博客"
markconf_url=http://blog.sisopipo.com
markconf_ignore_dirs=("category" "tags" "media" "static")

markproj_dir=$1
if [ "$markproj_dir" == "" ]; then
	markproj_dir=$(pwd)
fi

markproj_dir_len=${#markproj_dir} 
markproj_sub_dirs=()

function markindex_is_ignore_dir(){
	is_ignore="false"
	for idir in "${markconf_ignore_dirs[@]}"
	do
		if [[ $1 == $idir* ]] || [[ $1 == */$idir* ]]
		then
			is_ignore="true"
			break
		fi
	done
	
	echo $is_ignore
}

function markindex_all_dirs(){
	previous_dir=$(pwd)
	cd $markproj_dir
	dirs=$(find * -type d)
	for dir in $dirs
	do
		ignore=$(markindex_is_ignore_dir $dir)
		if [[ "$ignore" == "true" ]]
		then
			continue
		fi
		level=$(echo $dir |tr "/" "\n" |wc -l)
		numlevel=$((100-$level))
		markproj_sub_dirs+=("$numlevel-$dir")
	done
	cd $previous_dir
}

function markindex_parse_categories(){
	grep -m1 "markmeta_categories: " $1 |cut -c 22- |sed 's/,/ /g'
}

function markindex_parse_tags(){
	grep -m1 "markmeta_tags: " $1 |cut -c 16- |sed 's/,/ /g'
}

function markindex_pre_process(){
	mkdir -p $markproj_dir/category
	rm -f $markproj_dir/category/*.md
	echo "" > $markproj_dir/categories.md
	
	mkdir -p $markproj_dir/tags 
	rm -f $markproj_dir/tags/*.md
	echo "" > $markproj_dir/tags.md
	
	echo "# [$markconf_title]($markconf_url)" > $markproj_dir/README.md
	echo "" >> $markproj_dir/README.md
}

function markindex_process_dir(){
	dir_url_path="/"$1
	if [[ "$1" == "" ]]
	then
		dir_url_path=""
	fi
	process_dir=$markproj_dir$dir_url_path
	process_dir_name="${process_dir##*/}"

	echo "process dir $process_dir"

	parent_dir=${process_dir%/*}
	readme=$process_dir/README.md
	
	# ------------> start process files
	if [ "$dir_url_path" != "" ]; then
		echo "# [$markconf_title]($markconf_url)" > $readme
		echo "" >> $readme
	fi
	
	echo "## $process_dir_name" >> $readme

	files=$(find $process_dir -type f -name "*.md" -maxdepth 1|grep -v navbar|grep -v README|grep -v categories |grep -v tags |sort -r)
	for file in $files
	do
		title=$(grep -m1 "markmeta_title:" $file | sed 's/[^:]*://' |xargs)
		date=$(grep -m1 "markmeta_date:" $file | sed 's/[^:]*://' |xargs)
		author=$(grep -m1 "markmeta_author:" $file | sed 's/[^:]*://' |xargs)

		filename="${file##*/}"
		file_extension="${filename##*.}"
		filename="${filename%.*}"

		if [ "$author" == "" ]; then
			author="noname"
	        fi	

		echo "* [$title]($dir_url_path/$filename), $author, $date" >> $readme

		
		# ----> parse categories	
		categories=$(markindex_parse_categories $file)
		for cate in $categories
		do
			cate=$(echo $cate | tr '[:upper:]' '[:lower:]') # to lowercase
			if [ "$cate" != "" ] && [ ! -f  $markproj_dir/category/$cate.md ]
			then
				cat $markproj_dir/README.md >  $markproj_dir/category/$cate.md
				echo "# $cate" >>  $markproj_dir/category/$cate.md
				echo " [$cate](/category/$cate)" >> $markproj_dir/categories.md
			fi

			echo "* [$title]($dir_url_path/$filename),$date" >> $markproj_dir/category/$cate.md
		done
	
		# ----> parse tags	
		tags=$(markindex_parse_tags $file)
		for tag in $tags
		do
			tag=$(echo $tag | tr '[:upper:]' '[:lower:]') # to lowercase
			if [ "$tag" != "" ] && [ ! -f  $markproj_dir/tags/$tag.md ]
			then
				echo "# $tag" >>  $markproj_dir/tags/$tag.md
				echo " [$tag](/tags/$tag)" >>  $markproj_dir/tags.md
			fi

			echo "* [$title]($dir_url_path/$filename),$date" >> $markproj_dir/tags/$tag.md
		done
	done

	# -------> start process navbar
	rm -f $process_dir/_navbar.md
	if [[ "$dir_url_path" != "" ]]
	then
		echo "[$process_dir_name]($dir_url_path)" >> $parent_dir/_navbar.md
	fi
}

function markindex_post_process(){
	echo "" >> $markproj_dir/README.md
	cat $markproj_dir/_navbar.md >> $markproj_dir/README.md
	echo "" >> $markproj_dir/README.md

	echo "## Categories" >> $markproj_dir/README.md
	cat $markproj_dir/categories.md >> $markproj_dir/README.md
	
	echo "" >> $markproj_dir/README.md
	echo "## Tags" >> $markproj_dir/README.md
	cat $markproj_dir/tags.md >> $markproj_dir/README.md

	for dir in $(echo "${markproj_sub_dirs[@]}"|tr " " "\n" |grep "-"|sort -r|sed 's/^[^-]*-//')
	do 
		process_dir=$markproj_dir/$dir
		parent_dir=${process_dir%/*}
		if [ ! -f $process_dir/_navbar.md ]
		then
			cp $parent_dir/_navbar.md $process_dir/_navbar.md
		fi
	done

}

function markindex_process(){
	markindex_pre_process 
	markindex_all_dirs
	markindex_process_dir
	for dir in $(echo "${markproj_sub_dirs[@]}"|tr " " "\n" |grep "-"|sort -r|sed 's/^[^-]*-//')
	do 
		markindex_process_dir $dir
	done

	markindex_post_process 
}

markindex_process

echo "done!"

