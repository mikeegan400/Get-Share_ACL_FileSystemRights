<# 
.NAME
Get-Share_ACL_FileSystemRights.ps1

.SYNOPSIS
Pulls the share information and lists the ACL for the share, as well as the NTFS rights for each user/group

.DESCRIPTION

.PARAMETERS
no parameters are needed

.EXAMPLE
Get-Share_ACL_FileSystemRights.ps1

.INPUTS
none

.OUTPUTS
IdentityReference                                                                                              FileSystemRights
-----------------                                                                                              ----------------
NT AUTHORITY\SYSTEM                                                                                         Modify, Synchronize
BUILTIN\Administrators                                                                                      Modify, Synchronize
BUILTIN\Users                                                                                       ReadAndExecute, Synchronize


.NOTES
 AUTHOR: Mike Egan
 LASTEDIT: 11/10/2022
 KEYWORDS: ACL, SMB, permissions
 This script should be run as Administrator

.Link
none

#> 

# retrieve the path for all shares on the C: drive not include the default C:\ share
$shares = get-smbshare | where-object {$_.Path -like "*C:\*" -and $_.Path -ne "C:\"} | select-object Path
foreach ($share in $shares)
{
	write-output $share.Path 
  # get the IdentityReference and File System Rights for each share excluding any FileSystemRight starting with "2" or "-1"
  # NOTE: rights starting with "2" or "-1" are generic values and can, in most cases, be deemed redundant
  (get-acl -path $share.path).access | select-object IdentityReference,FileSystemRights | where-object {$_.FileSystemRights -notlike "2*" -and $_.FileSystemRights -notlike "-1*"}

  write-output "`r"
}