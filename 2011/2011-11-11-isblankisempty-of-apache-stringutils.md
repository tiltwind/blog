<!---
markmeta_author: wongoo
markmeta_date: 2011-11-11 08:41:19+00:00
slug: isblankisempty-of-apache-stringutils
markmeta_title: isBlank&isEmpty of Apache StringUtils
wordpress_id: 165
markmeta_categories: Experience
markmeta_tags: apache,java,string
-->

StringUtils.isBlank(null); => true
StringUtils.isBlank("");   => true
StringUtils.isBlank("   ");  => true
StringUtils.isEmpty(null);  => true
StringUtils.isEmpty("");    => true
StringUtils.isEmpty("   ");   => false
