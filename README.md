
# Zitadel Docker Build Template

This repo contains a template to build a pre-configured [Zitadel](https://github.com/zitadel/zitadel) v2 docker image.  
Please ensure that you follow the configuration in this readme, before running
the build.

## What is this and why would I use it?

Zitadel is an OIDC identity provider.  
This repo provides the steps for building a pre-configured docker image that
will work on a production system.

This image is intended to be used with a separately hosted cockroach DB
instance. For example, a [cloud hosted instance](https://www.cockroachlabs.com/product/).

## Prerequisites

* git
* docker
* go
* goreleaser

## Steps

1. Clone this repo
2. Setup your cockroachdb database
   1. If using a secured connection on a public network, download the cert file.
   2. Place the cert file into the [image](./image) folder and name it: `auth-ca.crt`
3. Setup your DNS and (if applicable) load balancer.
4. Configure [config.yaml](./image/config.yaml)
5. Configure [steps.yaml](./image/steps.yaml)
6. `$ ./build.sh`
7. Test out the image: `docker run --rm -it ghcr.io/zitadel/zitadel:configured-latest-amd64 --help`

### Configuration

`config.yaml` contains a number of suggested settings that you'll want to
configure for most setups. There are more options available in:
[default.yaml](https://github.com/zitadel/zitadel/blob/v2-alpha/cmd/defaults.yaml)

|Configuration                 |Description                                                                                                                                                             |
|==============================|========================================================================================================================================================================|
|`ExternalDomain`              |The root domain to host the zitadel service under, for example `zitadel.ch`.                                                                                            |
|`DefaultInstance`             |Zitadel is multi-tenant. This setting configures the default tenant.                                                                                                    |
|`DefaultInstance.InstanceName`|The name of the default instance.                                                                                                                                       |
|`DefaultInstance.CustomDomain`|The domain name of the custom instance, for example `auth.zitadel.ch`. If this domain was used, the console would be available as `https://auth.zitadel.ch/ui/console`. |
|`Database`                    |The settings needed to connect to your database.                                                                                                                        |
|`AdminUser`                   |Database admin access user, to use to create the zitadel database.                                                                                                      |
|`Machine`                     |Only needed if you are hosting in an environment where the private IP address of the machine cannot be used to identify it uniquely.                                    |
|`Projections`                 |Can be set to reduce idle DB usage, but comes with the penalty of increasing the time for data to become consistent.                                                    |

`steps.yaml` contains setup steps run when zitadel first starts. You'll need to
copy the settings for `DefaultInstance` to this file, with the configuration
instead named `S3DefaultInstance` (as shown in the file in this repo).

## Using the image

To run the image, pass the command:  
`admin --config /.zitadel/config.yaml --steps /.zitadel/steps.yaml start-from-init --masterkey <32-char-key>`

For healthchecks, curl is included on the image and you can use:  
`curl -f http://localhost:8080/debug`
