# NEO Airlines Case Study 
This is a Iac terraform repository intended to provision the following:
- Kubernetes cluster on Google cloud.
- Two namespaces within that cluster ( dev and test ) to be used as environments platform for hosting the applicaiton.
- One namespace ( devops ) for hositng jenkins and other devops tools.
- Install Tiller to k8s cluster
- Deploy Jenkins helm chart a long with Prometheos and Grafana charts.
- Add new target within prometheos to pull metrics from jenkins

The Platform is then used to build and deploy the petclinic App using the installed jenkins and deploy it to the kubernetes cluster 
####[Spring Petclinic project]: https://github.com/case-study-neo-airlines/spring-petclinic


## Endpoints

Application URL - dev environemnt: http://35.239.44.251:8080/
Jenkins URL: http://35.202.17.65:8080/job/neo/
grafana jenkins dashboard: http://35.223.202.153/d/-y-jaPEmk/a-jenkins-performance-and-health-overview-for-jenkinsci-prometheus-plugin?orgId=1

## Usage
Usage 

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| a | b | c | d | e |

## Outputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| a | b | c | d | e |


## Requirements

Required:

1. Terraform 
2. The Servic

### Software Dependencies
#### Kubectl
- [kubectl](https://github.com/kubernetes/kubernetes/releases) 1.9.x
#### Terraform and Plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.12
- [Terraform Provider for GCP][terraform-provider-google] v2.9

