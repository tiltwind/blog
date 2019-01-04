function parse_category(){
	a=$(cat $1)
	a=${a/*categories:/}
	a=${a:2:20}
	echo $a | head -n 1 | awk -F ' ' '{print $1}'
}

mkdir category
rm -f category/*.md
echo "" > categories.md

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
		filename="${filename%.*}"
		echo "* [$title](/$y/$filename),$date" >> $readme

		
		cate=$(parse_category $file)
		if [ ! -f category/$cate.md ]
		then
			cat README.md > category/$cate.md
			echo "# $cate" >> category/$cate.md
			echo " [$cate](/category/$cate)" >> categories.md
		fi

		echo "* [$title](/$y/$filename),$date" >> category/$cate.md
	done
done

cat categories.md >> README.md

echo "done!"

