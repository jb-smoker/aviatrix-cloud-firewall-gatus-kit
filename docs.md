## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws"></a> [aws](#module\_aws) | ./modules/aws | n/a |
| <a name="module_azure"></a> [azure](#module\_azure) | ./modules/azure | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_regions.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_cidr"></a> [aws\_cidr](#input\_aws\_cidr) | Aws vpc cidr. | `string` | `"10.1.0.0/24"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region. | `string` | `null` | no |
| <a name="input_azure_cidr"></a> [azure\_cidr](#input\_azure\_cidr) | Azure vpc cidr. | `string` | `"10.2.0.0/24"` | no |
| <a name="input_azure_region"></a> [azure\_region](#input\_azure\_region) | Azure region. | `string` | `null` | no |
| <a name="input_clouds"></a> [clouds](#input\_clouds) | Deploy gatus workloads to these cloud provider(s). | `list(string)` | <pre>[<br/>  "aws",<br/>  "azure"<br/>]</pre> | no |
| <a name="input_dashboard"></a> [dashboard](#input\_dashboard) | Create a dashboard to expose gatus status to the Internet. | `bool` | `false` | no |
| <a name="input_dashboard_access_cidr"></a> [dashboard\_access\_cidr](#input\_dashboard\_access\_cidr) | CIDR that has http access to the dashboard(s). | `string` | `null` | no |
| <a name="input_gatus_endpoints"></a> [gatus\_endpoints](#input\_gatus\_endpoints) | Gatus endpoints to test. | `map(list(string))` | <pre>{<br/>  "http": [<br/>    "de.vu",<br/>    "69298.com",<br/>    "tiktock.com",<br/>    "acrilhacrancon.com",<br/>    "blockexplorer.com"<br/>  ],<br/>  "https": [<br/>    "aviatrix.com",<br/>    "aws.amazon.com",<br/>    "www.microsoft.com",<br/>    "cloud.google.com",<br/>    "github.com",<br/>    "thishabboforum.com",<br/>    "malware.net",<br/>    "go.dev",<br/>    "dk-metall.ru"<br/>  ],<br/>  "icmp": [],<br/>  "tcp": []<br/>}</pre> | no |
| <a name="input_gatus_interval"></a> [gatus\_interval](#input\_gatus\_interval) | Gatus polling interval. | `number` | `10` | no |
| <a name="input_gatus_version"></a> [gatus\_version](#input\_gatus\_version) | Gatus version. | `string` | `"5.12.1"` | no |
| <a name="input_local_user"></a> [local\_user](#input\_local\_user) | Local user to create on the gatus instances. | `string` | `"gatus"` | no |
| <a name="input_local_user_password"></a> [local\_user\_password](#input\_local\_user\_password) | Password for the local user on the gatus instances. | `string` | `null` | no |
| <a name="input_number_of_instances"></a> [number\_of\_instances](#input\_number\_of\_instances) | Number of gatus instances spread across subnets/azs to create. | `number` | `2` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_dashboard_public_ip"></a> [aws\_dashboard\_public\_ip](#output\_aws\_dashboard\_public\_ip) | Aws Gatus Dasboard Public IP |
| <a name="output_aws_local_user_password"></a> [aws\_local\_user\_password](#output\_aws\_local\_user\_password) | The generated random aws local\_user\_password |
| <a name="output_azure_dashboard_public_ip"></a> [azure\_dashboard\_public\_ip](#output\_azure\_dashboard\_public\_ip) | Azure Gatus Dasboard Public IP |
| <a name="output_azure_local_user_password"></a> [azure\_local\_user\_password](#output\_azure\_local\_user\_password) | The generated random azure local\_user\_password |
