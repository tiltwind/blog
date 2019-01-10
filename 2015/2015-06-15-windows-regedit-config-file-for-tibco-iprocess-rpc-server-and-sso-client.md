<!---
markmeta_author: wongoo
markmeta_date: 2015-06-15 03:16:49
slug: windows-regedit-config-file-for-tibco-iprocess-rpc-server-and-sso-client
markmeta_title: Windows regedit config file for Tibco iProcess RPC Server and SSO Client
wordpress_id: 846
markmeta_categories: Experience
markmeta_tags: iProcess,regedit,Tibco
-->


    Windows Registry Editor Version 5.00
    
    [HKEY_CURRENT_USER\Software\Staffware plc\Staffware Client\Default\RPC Servers]
    "Server1"="IPEHOST,391875,1,IPE SERVER"
    
    [HKEY_LOCAL_MACHINE\SOFTWARE\Staffware plc\Staffware SSO Client]
    "TISOMultiChar"=hex(b):01,00,00,00,00,00,00,00
    "TISOUnicodeConverterName"="UTF-8"

