# PKS Lazy Scripts
The simple linux scripts to reduce complex operations when deploy the Pivotal Container Service (PKS) on VMware environment.

Official document - [https://docs.pivotal.io/runtimes/pks/1-3/](https://docs.pivotal.io/runtimes/pks/1-3/)

## Requirement
These scripts must to executed on the `Ubuntu` host which can access to the PCF Ops Manager/BOSH/PKS/NSX-T.

## Environment
* NSX-T 2.3.0
* Ops Manager 2.4-build.171
* BOSH 2.4-build.171
* PKS 1.3.5-build.3

## BOSH
#### BOSH CLI Authentication.
```{bash}
$ cd pks-lazy-scripts
$ source bosh/bosh_cli_auth.sh
```
> This script will automatically set the BOSH environment variables after complete.
>
You can also manually set the BOSH environment variables.
```{bash}
$ source set_bosh_env.sh
```
#### BOSH SSH
```{bash}
$ cd pks-lazy-scripts
$ source bosh/bosh_ssh.sh
```

#### BOSH Operator
The easy way to operate BOSH functions.
```{bash}
$ cd pks-lazy-scripts
$ source bosh/bosh_operator.sh
```
<img src="https://i.imgur.com/5O9AdH9.gif" width="800" height="500">


## NSX-T

#### Setting the NSX-T Management-Cluster and Control-Cluster.
[https://docs.pivotal.io/runtimes/pks/1-3/nsxt-prepare-env.html#nsx-clusters](https://docs.pivotal.io/runtimes/pks/1-3/nsxt-prepare-env.html#nsx-clusters)
```{bash}
$ cd pks-lazy-scripts
$ source nsx_t/configure_nsx_t.sh
```

#### Get the NSX-T CA cert when BOSH installation.
[https://docs.pivotal.io/runtimes/pks/1-3/generate-nsx-ca-cert.html](https://docs.pivotal.io/runtimes/pks/1-3/generate-nsx-ca-cert.html)
```{bash}
$ cd pks-lazy-scripts
$ source nsx_t/get_nsx_ca_cert.sh
```
#### Import the superuser certificate into NSX-T when PKS installation.
[https://docs.pivotal.io/runtimes/pks/1-3/generate-nsx-pi-cert.html](https://docs.pivotal.io/runtimes/pks/1-3/generate-nsx-pi-cert.html)
```{bash}
$ cd pks-lazy-scripts
$ source nsx_t/nsx_superuser.sh
```
## UAAC
#### Create User
[https://docs.pivotal.io/runtimes/pks/1-3/manage-users.html#pks-access](https://docs.pivotal.io/runtimes/pks/1-3/manage-users.html#pks-access)
```{bash}
$ cd pks-lazy-scripts
$ source uaac/uaac_create_new_user.sh
```



