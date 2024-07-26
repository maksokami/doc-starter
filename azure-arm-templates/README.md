## Azure ARM Templates

- **[Internet exposed VMs behind a load-balancer](./arm-internet-exposed-lb-vms.json)**: Basic setup of a publicly exposed Azure Firewall, Load-Balancer, VNet, NSG, Bastion, DNAT. Not suited for web applications (No WAF). Ideal for cloud deployments of various log collectors/brokers. Ready for VMs to be deployed under vnet: "vnet-vms" -> subnet: "VMs". The template is configured to deploy in the same region as the resource group. Two example application rules added for access to Docker and Ubuntu related resources.

### How to deploy
- Azure Portal: "Deploy a custom template" -> "Build your own template in the editor" -> "Load File"
