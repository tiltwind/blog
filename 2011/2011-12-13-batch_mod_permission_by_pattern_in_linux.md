<!---
markmeta_author: wongoo
markmeta_date: 2011-12-13 07:26:33
slug: batch_mod_permission_by_pattern_in_linux
markmeta_title: Linux批量修改符合某一条件文件权限
wordpress_id: 183
markmeta_categories: Experience
markmeta_tags: Linux,chmod
-->

Change the permission of files with 665 permission under /tmp/mydir to 664:

    find /tmp/mydir -type f -perm 665 -print -exec chmod 664 {} \;


Change the permission of directories with 2775 permission under /tmp/mydir to 777:

    find /tmp/mydir -type d -perm 2775 -print -exec chmod 777 {} \;


What a great command! 
