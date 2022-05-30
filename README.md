# Overview
*aks-auditd* provides you with an easy and highly configurable way to gain visibility into your AKS worker node and container kernel level activity. If you are running a multi-tenant cluster, having visibility into your AKS worker node activity is critical and the Kubernetes API server logs aren't always be enough. [`auditd`](https://linux.die.net/man/8/auditd) provides a good solution to this. 

By default, *aks-auditd* configures your `auditd` logging, using syslog as the default event forwarder to send `auditd` logs to your Log Analytics workspace. It uses a lightweight container deployed as a `Daemonset`, to setup and configure your `auditd` and `oms` rules. This container has two primary functions:
* Install `auditd` onto the VMSS.
* Configure audit rules and apply any changes made to your audit configuration. Each type of audit configuration (`oms` and `auditd`) has it's own `ConfigMap`.

At a high-level, *aks-auditd* enables and configures the following pipeline:

![AKS Audit Logging Pipeline](https://user-images.githubusercontent.com/43414276/166338930-2c19291b-f273-4d47-9dab-a36cc0359faa.png)


# Usage
## Enable the OMSAgent (auoms)
Before deploying the DaemonSet, you must first enable the OMSAgent (auoms) on your AKS cluster to ensure the OMSAgent sends the telemetry to your Log Analytics workspace.

```
az vmss extension set --resource-group MC_aks-simuland_aks-simuland_northeurope --vmss-name aks-agentpool-49591645-vmss --name OmsAgentForLinux --publisher Microsoft.EnterpriseCloud.Monitoring --protected-settings '{\"workspaceKey\":\"...\"}' --settings '{\"workspaceId\":\"d421160f-40fa-4fbf-a198-780c7c881408\",\"skipDockerProviderInstall\":true}'

```

## Specify your Log Analytics Workspace (if needed)
 Update the `LOG_ANALYTICS_WORKSPACE_ID` environment variable within `daemonset.yaml` to specify your [Log Analytics workspace ID](https://docs.microsoft.com/en-us/bonsai/cookbook/get-law-id).

## Configure additional auditd and auoms logging
Update the following ConfigMaps to update your `auditd` and `oms` configuration.

### audisp-plugins
These correspond to audisp/plugins.d/ files and are intended to be used to send audit logs to remote systems. By default, we use Syslog as the event forwarder.

### auditd-rule
These configuration files are placed in your worker node's /etc/audit/rules.d/ and determine what the audit daemon will record and send to your remote server (Syslog by default). By default, `aks-auditd` creates a ruleset for auditing process execution on your VMSS and pods ([`10-procmon.rules`](https://secopsmonkey.com/monitoring-process-execution-with-auditd.html)).

### oms-config
These configuration files are placed in your /etc/opt/microsoft/omsagent/<workspace id>/conf/omsagent.d/ and are used to configure the collection of events by the OMS agent on your host. By default teh OMS agent comes configured with syslog support. Available configurations can be found at https://github.com/microsoft/OMS-Agent-for-Linux/tree/master/installer/conf/omsagent.d. 




## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
