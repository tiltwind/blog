
function markindex_parse_categories(){
	grep "categories: " $1 |cut -c 13- |sed 's/,/ /g'
}

function markindex_parse_tags(){
	grep "tags: " $1 |cut -c 7- |sed 's/,/ /g'
}

mkdir -p category
rm -f category/*.md
echo "" > categories.md

mkdir -p tags 
rm -f tags/*.md
echo "" > tags.md

find . -maxdepth 1 -type d -name "20*" |sort -r|awk -F '/' '{if($2!="") {print " ["$2"](/"$2"/)"}}' > _navbar.md

echo "# 望哥的博客" > README.md
cat _navbar.md >> README.md
echo "" >> README.md
echo "" >> README.md

years=$(find . -maxdepth 1 -type d -name "20*" | sort -r | paste -sd " " -)
echo "years:$years"

for year in  $years
do
	echo "process dir $year"
	cp _navbar.md $year/_navbar.md

	readme=$year/README.md
	y=${year:2:100}
	
	cat README.md > $readme
	echo "## $y" >> $readme

	files=$(find $year -type f|grep -v navbar|grep -v README |sort -r)
	for file in $files
	do
		title=$(grep "title:" $file | awk -F ':' '{print $2}'|xargs)
		date=$(grep "date:" $file | awk -F ':' '{print $2}'|xargs)
		filename="${file##*/}"
		extension="${filename##*.}"
		filename="${filename%.*}"
		echo "* [$title](/$y/$filename),$date" >> $readme

		
		# ----> parse categories	
		categories=$(markindex_parse_categories $file)
		for cate in $categories
		do
			cate=(${cate,,})
			if [ ! -f category/$cate.md ]
			then
				cat README.md > category/$cate.md
				echo "# $cate" >> category/$cate.md
				echo " [$cate](/category/$cate)" >> categories.md
			fi

			echo "* [$title](/$y/$filename),$date" >> category/$cate.md
		done

		# ----> parse tags	
		tags=$(markindex_parse_tags $file)
		for tag in $tags
		do
			tag=(${tag,,}) # to lowercase
			if [ ! -f tags/$tag.md ]
			then
				echo "# $tag" >> tags/$tag.md
				echo " [$tag](/tags/$tag)" >> tags.md
			fi

			echo "* [$title](/$y/$filename),$date" >> tags/$tag.md
		done

		# change file extension markdown->md
		if [ "$extension" == "markdown" ]
		then
			mv $file $y/$filename.md
		fi
	done
done

echo "## Categories" >> README.md
cat categories.md >> README.md

echo "" >> README.md
echo "## Tags" >> README.md
cat tags.md >> README.md

echo "done!"
