<!-- markdownlint-disable MD041 -->
<p align="center"><a href="https://github.com/fredrikhgrelland/vagrant-hashistack-template" alt="Built on"><img src="https://img.shields.io/badge/Built%20from%20template-Vagrant--hashistack--template-blue?style=for-the-badge&logo=github"/></a><p align="center"><a href="https://github.com/fredrikhgrelland/vagrant-hashistack" alt="Built on"><img src="https://img.shields.io/badge/Powered%20by%20-Vagrant--hashistack-orange?style=for-the-badge&logo=vagrant"/></a><p><a href="https://docs.dask.org/"><img src="https://docs.dask.org/en/latest/_images/dask_horizontal.svg" alt="Dask" width="300" height="150"></a> </p></p></p>

# Terraform-nomad-dask
This is a Hashicorp Terraform module to build and run a cluster of Dask workers connected to a Dask scheduler using Hashicorp Nomad. The cluster is secured using Consul Connect and will optionally establish a Connect Proxy connection to a named MinIO instance.

#TODO: Find relevant explanation of "hashistack" to link to


## Compatibility
#TODO: Vault, consul etc
1. Terraform 0.12.2 or newer
2. Nomad 0.12 or newer
3. vagrant-hashistack 0.5.0 or newer

## Usage
This module needs to be called from a Terraform plan. A functioning example has been included in examples/vagrant_box_example.
 
### Requirements
#### Required software
1. Terraform 0.12.2 or newer installed on your workstation
2. A running Nomad cluster OR
3. A local installation of Vagrant + Virtualbox [vagrant-hashistack](https://github.com/fredrikhgrelland/vagrant-hashistack#install-prerequisites)

#TODO: Everything below here
#### Other
Any other requirements. E.g. "This needs to be run on a Debian system"

### Providers
A description of the providers that the module uses. E.g. "This module uses the [Nomad](https://registry.terraform.io/providers/hashicorp/nomad/latest/docs) and [Vault](https://registry.terraform.io/providers/hashicorp/vault/latest/docs) providers"

## Inputs
|Name     |Description     |Type    |Default |Required  |
|:--|:--|:--|:-:|:-:|
|         |                |bool    |true    |yes        |

## Outputs
|Name     |Description     |Type    |Default |Required   |
|:--|:--|:--|:-:|:-:|
|         |                |bool    |true    |yes         |

### Example
Example-code that shows how to use the module, and, if applicable, its different use cases.
```hcl-terraform
module "example"{
  source = "./"
}
```

### Verifying setup
Description of expected end result and how to check it. E.g. "After a successful run Presto should be available at localhost:8080".

## Authors

## License
