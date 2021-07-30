## Remove Built-in Apps
*A script to remove un-wanted Windows 8 or Windows 10 Applications*

This is a mirror of [the original by Michael Niehaus](https://techcommunity.microsoft.com/t5/windows-blog-archive/removing-windows-10-in-box-apps-during-a-task-sequence/ba-p/706582), with an updated [list of Windows Applications](https://docs.microsoft.com/en-us/windows/application-management/apps-in-windows-10) for Windows 10 21H1.

We use this as part of our build process in SCCM.

### How to use with Microsoft SCCM:

 1. List item
 2. Download both RemoveApps.ps1 and RemoveApps.xml.
	 - If you would prefer to customise the list of applications, download RemoveApps.Example.xml instead and re-name it RemoveApps.xml when saving your changes.
 3. Copy the files to your SCCM Distribution Share and create a package containing the source files.
 4. Distribute the package content to your SCCM Distribution Point(s).
 5. Ensure that your Boot Images have the following optional features enabled:
	 - Windows PowerShell (WinPE-DismCmdlets)
	 - Storage (WinPE-EnhancedStorage)
	 - Windows PowerShell (WinPE-StorageWMI)
	 - Microsoft .NET (WinPE-NetFx)
	 - Windows PowerShell (WinPE-PowerShell)
		 - If you are adding these features, be sure to reload the image and re-distribute before continuing.
 6. Edit your deployment task sequence and add a 'Run PowerShell Script' step to the post-install section (or after the Apply Network Settings step).
	 - Select the Package you created in Step 3.
	 - Set the Excecution Policy to ByPass (SCCM version 1803 and newer).
 7. Boot your target computer into the SCCM OSD Wizard and ensure that the step runs correctly.
 8. You're Done!
	 - Enjoy your new, less cluttered Windows 10 Image
