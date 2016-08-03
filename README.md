<img src="https://www.cloudbolt.io/wp-content/uploads/CloudBolt_hlogo_blue_cloud_w_text2-1.png" width="500">

# Summary
This is the Ruby api client for CloudBolt. It contains the src and gem file.

## Build

```
$ gem build cloudbolt.gemspec
```

## Install

```
$ get install cloudbolt-{VERSION}.gem
```

## Executables

### Provision a Server

```
$ cb_prov --proto https \
--host 'cloudbolt.example.com' \
--port 443 \
--user cloudbolt \
--pass 'password' \
--group-id 12 \
--env-id 29 \
--owner-id 2 \
--osbuild-id 1 \
--cf vmware_disk_type="Thin Provision",sc_nic_0="VLAN 27 (DHCP)",mem_size="1 GB",vmware_datastore="NAS-NFS",cpu_cnt="1",vmware_cluster="C01",expiration_date="2016-07-27",link_clone="True" \
--hostname "rubyapi007" \
--wait
```

### Decommission a Server

```
$ cb_decom --proto https \
--host 'cloudbolt.example.com' \
--port 443 \
--user cloudbolt \
--pass 'password' \
--env-id 29 \
--group-id 12 \
--server-ids 434 \
--wait
```

## LICENSE
This project is licensed under the terms of the MIT license located in LICENSE.md.

## CONTRIBUTING

By contributing to this project, you are agreeing to release your contributions under the MIT License.
