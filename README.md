# 2021-01-21 Update

The [KB article has been updated with known issues](https://support.microsoft.com/en-us/help/4578969/kb4578969-cumulative-update-for-net-framework#section-2) where this bug has been addressed.  
There is a workaround available:
> **Workaround**  
> Customers who observe new unexpected failures or functional issues can implement an application setting by adding (or merging) the following code to the application configuration file. Setting either “true” or “false” will avoid the issue. However, we recommend that you set this value to “true” for sites that do not rely on cookieless features.
> ```
> <?xml version="1.0" encoding="utf-8" ?>
> <configuration>
>      <appSettings>
>          <add key=”aspnet:DisableAppPathModifier” value=”true” />
>     </appSettings>
> </configuration>
> ```
>

# Reproduce issue introduced with KB4578969

This is a short minimum reproduceable example for an issue introduced with the latest .NET Framework Update [KB4578969](https://support.microsoft.com/en-us/help/4578969/kb4578969-cumulative-update-for-net-framework).

## Description of the issue

When publishing an ASP.NET site with pre-compile enabled and KB4578969 applied, there is an error when publishing the site.  
This only happens, if there is a `timeout` attribute with a non-standard value. (e.g. a string placeholder)  

## Introduced parsing error
`error ASPCONFIG: The value of the property 'timeout' cannot be parsed. The error is: Input string was not in a correct format.`

```
AspNetPreCompile:
  C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319\aspnet_compiler.exe -v / -p \AspNetWebConfigTransformIssueRepro\WebConfigTransformRepro\obj\Release\AspnetCompileMerge\Source -u -c \AspNetWebConfigTransformIssueRepro\WebConfigTransformRepro\obj\Release\AspnetCompileMerge\TempBuildDir
\AspNetWebConfigTransformIssueRepro\WebConfigTransformRepro\obj\Release\AspnetCompileMerge\Source\web.config(9): error ASPCONFIG: The value of the property 'timeout' cannot be parsed. The err
or is: Input string was not in a correct format. [\AspNetWebConfigTransformIssueRepro\WebConfigTransformRepro\WebConfigTransformRepro.csproj]
Done Building Project "\AspNetWebConfigTransformIssueRepro\WebConfigTransformRepro\WebConfigTransformRepro.csproj" (default targets) -- FAILED.

Done Building Project "\AspNetWebConfigTransformIssueRepro\WebConfigTransformRepro.sln" (default targets) -- FAILED.


Build FAILED.
```

## Repro instructions
### Prerequisites
 - Visual Studio 2019 with the **ASP.NET and web development** workload

### Steps to reproduce it with this repository
1. Clone this repository
2. Execute the powershell script [build.ps1](./build.ps1)

### Steps to reproduce it yourself

1. Create a new ASP.NET Framework 4.8 project
2. Add one of the following `web.config` configuration elements:  
   `configuration/system.web/sessionState` with a `timeout` attribute  
   `configuration/system.web/authentication/forms` with a `timeout` attribute
3. Change the value of `timeout` to any other value than integer, e.g. `{TIMEOUT}`
4. Add a publish profile for file system publish with pre-compiling enabled
5. Try to publish the site

> **Note**  
> This reproducable example uses a `web.config` transform instead to show the probably more suited use case for this issue. (Publish with placeholders and replace them in the deployment or update process)
