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
$ cb_deploy_blueprint --proto https \
--host 'cloudbolt.example.com' \
--port 443 \
--user cloudbolt \
--pass 'password' \
--group-id 12 \
--deploy-item '{}' \
--wait
```

### Decommission a Server

```
$ cb_decom_blueprint --proto https \
--host 'cloudbolt.example.com' \
--port 443 \
--user cloudbolt \
--pass 'password' \
--env-id 29 \
--group-id 12 \
--decom-item '{}' \
--wait
```

## LICENSE
This project is licensed under the terms of the MIT license located in LICENSE.md.

## CONTRIBUTING

By contributing to this project, you are agreeing to release your contributions under the MIT License.
