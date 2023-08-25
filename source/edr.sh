############################################
##      Installing cloudendure
############################################

##installer_linux
wget -O ./installer_linux.py https://console.cloudendure.com/installer_linux.py
sudo python ./installer_linux.py -t 2D3F-DC9F-91E8-8201-81A6-4B47-5874-7390-CE3B-AC35-D385-3943-0BEB-FFB2-2FD0-694C --no-prompt


##windows
mkdir temp;cd temp
$url= "https://console.cloudendure.com/installer_win.exe"
Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile installer_win.exe
& "C:\temp\installer_win.exe" -t 2D3F-DC9F-91E8-8201-81A6-4B47-5874-7390-CE3B-AC35-D385-3943-0BEB-FFB2-2FD0-694C --no-prompt







############################################
##      Upgrade to Elastic DR
############################################
##run assessment 
.\cloudendure_to_drs_upgrade_assessment_tool.exe --api-token 92D2-925D-3FEF-149A-06F8-1370-261E-57DF-8BA9-1280-F200-8EAE-B6DF-4AFD-3EB9-AD90 --project-id 734b3d4b-cb7f-44e9-a84f-1b165ad0d6a5

##start-upgrade for Linux
sudo python3 cloudendure_to_drs_upgrade_tool.py start-upgrade --api-token 92D2-925D-3FEF-149A-06F8-1370-261E-57DF-8BA9-1280-F200-8EAE-B6DF-4AFD-3EB9-AD90 --project-id a530d90a-3d82-45a2-a7d1-69485e39e75e --aws-access-key-id AKIAYTQE5TWEHSVKJBHG --aws-secret-access-key xxxxxxxxxxxxxxxx --import-blueprint --import-replication-configuration --import-test-snapshot

sudo python3 cloudendure_to_drs_upgrade_tool.py finalize-upgrade --api-token 92D2-925D-3FEF-149A-06F8-1370-261E-57DF-8BA9-1280-F200-8EAE-B6DF-4AFD-3EB9-AD90 --project-id a530d90a-3d82-45a2-a7d1-69485e39e75e --aws-access-key-id AKIAYTQE5TWEHSVKJBHG --aws-secret-access-key xxxxxxxxxxxxxxxx 



##start-upgrade for Windows
mkdir temp;cd temp
$url= "https://cedr-to-drs-upgrade-tool.cloudendure.com/latest/cloudendure_to_drs_upgrade_tool.exe"
Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile cloudendure_to_drs_upgrade_tool.exe
.\cloudendure_to_drs_upgrade_tool.exe start-upgrade --api-token 92D2-925D-3FEF-149A-06F8-1370-261E-57DF-8BA9-1280-F200-8EAE-B6DF-4AFD-3EB9-AD90 --project-id a530d90a-3d82-45a2-a7d1-69485e39e75e --aws-access-key-id AKIAYTQE5TWEHSVKJBHG --aws-secret-access-key xxxxxxxxxxxxxxxx --import-blueprint --import-replication-configuration --import-test-snapshot


.\cloudendure_to_drs_upgrade_tool.exe finalize-upgrad e--api-token 92D2-925D-3FEF-149A-06F8-1370-261E-57DF-8BA9-1280-F200-8EAE-B6DF-4AFD-3EB9-AD90 --project-id a530d90a-3d82-45a2-a7d1-69485e39e75e --aws-access-key-id AKIAYTQE5TWEHSVKJBHG --aws-secret-access-key xxxxxxxxxxxxxxxx 

AKIAYTQE5TWEHSVKJBHG
xxxxxxxxxxxxxxxx


############################################
##      Installing EDR agent
############################################
$url= "https://aws-elastic-disaster-recovery-us-east-2.s3.us-east-2.amazonaws.com/latest/windows/AwsReplicationWindowsInstaller.exe"
Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile AwsReplicationWindowsInstaller.exe
& "C:\temp\AwsReplicationWindowsInstaller.exe" --region us-east-1


sudo dnf install libxcrypt-compat
sudo curl -o aws-replication-installer-init https://aws-elastic-disaster-recovery-us-east-1.s3.us-east-1.amazonaws.com/latest/linux/aws-replication-installer-init
sudo chmod +x aws-replication-installer-init; sudo ./aws-replication-installer-init --region us-east-1