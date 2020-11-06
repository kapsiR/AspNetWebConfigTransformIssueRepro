$msbuildBin = (Get-ChildItem "C:\Program Files (x86)\Microsoft Visual Studio\2019\" -Recurse -Filter "msbuild.exe" | Select-Object -First 1).FullName
& $msbuildBin .\WebConfigTransformRepro.sln /p:DeployOnBuild=true /p:Configuration=Release /p:PublishProfile=FolderProfile
