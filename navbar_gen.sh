
find . -type d -name "20*" |sort -r|awk -F '/' '{if($2!="") {print "* ["$2"](/"$2"/)"}}' > _navbar.md
cp _navbar.md README.md

years=$(find . -type d -name "20*" | sort -r | paste -sd " " -)
echo "years:$years"

for year in  $years
do
	echo "process dir $year"
	cp _navbar.md $year/_navbar.md

	readme=$year/README.md
	y=${year:2:100}

	echo "# $y" > $readme

	files=$(find $year -type f|grep -v navbar|grep -v README |sort -r)
	for file in $files
	do
		title=$(grep "title:" $file | awk -F ':' '{print $2}'|xargs)
		filename="${file##*/}"
		filename="${filename%.*}"
		echo "* [$title](/$y/$filename)" >> $readme
	done
done

echo "done!"

