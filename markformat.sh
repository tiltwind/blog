#!/bin/sh

#----------------
# see: https://unix.stackexchange.com/questions/26284/how-can-i-use-sed-to-replace-a-multi-line-string
#
#---------------

for n in {1..5}
do
  sed -i '/^categories:.*$/{$!{N;s/\n- /,/;ty;P;D;:y}}' **/*.md
done

sed -i 's/categories: ,/categories: /g' **/*.md
sed -i 's/categories:,/categories: /g' **/*.md


for m in {1..5}
do
  sed -i '/^tags:.*$/{$!{N;s/\n- /,/;ty;P;D;:y}}' **/*.md
done

sed -i 's/tags: ,/tags: /g' **/*.md
sed -i 's/tags:,/tags: /g' **/*.md

