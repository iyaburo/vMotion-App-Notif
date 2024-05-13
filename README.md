# vMotion-App-Notif
Supporting Scripts for Enabling vMotion Application Notification in a VMware vSphere Environment

To help you get started on testing the feature described above, we are have made a zipped package of Sample Scripts available for download here. These Sample Scripts are intended to help you jumpstart your review and evaluation of the vMotion Application Notification feature in your environment. The package contains the following individual files:

setHostTimeout.py – Run this Script on an ESXi Host (setHostTimeout.py <timeout_value>) to enable and set a timeout value for “vMotion Application Notification” on the Host. The Timeout value is how long you want the Host to wait for an acknowledgement from a VM before performing a vMotion operation when invoked.
        Example: setHostTimeout.py 90 (will cause vMotion operation to wait for 90 seconds before starting)

Enable-App-Notif-on-VM-from-Host.py – Run this Script on the Host (Enable-App-Notif-on-VM-from-Host.py <vm_name> timeout=<vm_side_timeout_value> to enable and set a timeout value for vMotion Application Notification on a  VM. This Script must be run on the Host on which the VM at the time you are enabling this feature on the VM. This Script needs to be run only once. In this initial release, you must inspect a VM’s configuration (.vmx) if you need to verify whether or not it has this feature enabled.
        Example: Enable-App-Notif-on-VM-from-Host.py MySpecialVM timeout=60
        This command will write the following two entries into MySpecialVM’s .vmx file:
            vmx.vmOpNotificationToApp.Enabled = “TRUE”
            vmx.vmOpNotificationToApp.timeout = “60”
Please note that, for vMotion Application Notification to work, it must be enabled on both a VM and the Host on which the VM is running at the time of the vMotion operation. So, if MySpecialVM is migrated from Host-A (which has the feature enabled) to Host-B (which does not), the feature will work. However, when the VM needs to be migrated from Host-B, the feature will fail because Host-B doesn’t have the feature enabled. For this reason, it is recommended that the feature be enabled on all Hosts in a given vSphere Cluster.

WSFC-vMotion-App-Notification-Script.ps1 – This is a Windows Guest-side PowerShell Script which we are using to:
        Register this VM with vMotion Application Notification
        Ensure that Windows is always listening for notifications
        Cause Windows to respond to the notification when received
        Cause Windows to perform the necessary pre-vMotion house-cleaning we desire
        Cause Windows to inform vMotion Notification that it is done with it house cleaning
        Cause Windows to listen for when the vMotion operation completes
        Cause Windows to perform any post-vMotion clean-up we desire
        Goes back to listening for vMotion Application Notification events
We configured this Script to run every time Windows starts by adding it to Task Scheduler as a Machine Startup script. This way, our VM will always register an application with vMotion Application Notification so it can always listen for any vMotion event notification.

WSFC-vMotion-App-Notification-Script.ps1 is intentionally (over)commented. We have described every important task completed by the script to ensure that you understand what is happening, and why. Our goal is to provide a reference-able template to show a real-world implementation of the new vMotion Application Notification feature for a real application and use case. The verbose comments are intended to fully describe the flow and (thereby) encourage the Reader to build a more comprehensive, elegant and suitable adaptation for their own specific situation and needs. While we have focused solely on clustered Microsoft SQL Server workloads in this demonstration, there is, of course, a vast universe of applicability and usage scenarios for this new iteration of continuous improvements to one of the most prominent and indispensable VMware vSphere features. We earnestly hope that, with this short demonstration, vSphere and Application Administrators will be able to take a closer look at this enhancement and adapt it for their own unique purposes.

Migrate-VM-Script.ps1 - This is a simple script to automate the migration of the target VM

LEGALESE: There is no warranty (implied or otherwise) whatsoever that the sample scripts, steps or actions provided in this post is fit for purpose. It is purely for demonstration purposes. Customers are highly encouraged to please refrain from relying on its suitability for their own environments without a thorough review and understanding.
