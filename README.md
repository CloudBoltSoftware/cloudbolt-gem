<img src="https://www.cloudbolt.io/wp-content/uploads/CloudBolt_hlogo_blue_cloud_w_text2-1.png" width="500">

# Summary
This is a Ruby api client for CloudBolt.

## Build

```
$ gem build cloudbolt.gemspec
```

## Install

```
$ gem install cloudbolt-{VERSION}.gem
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
--deploy-items '[]' \
--wait \
--wait-time 5
```

### Decommission a Server

```
$ cb_decom_blueprint --proto https \
--host 'cloudbolt.example.com' \
--port 443 \
--user cloudbolt \
--pass 'password' \
--group-id 12 \
--decom-items '[]' \
--wait \
--wait-time 5
```

## LICENSE
This project is licensed under the terms of the MIT license located in LICENSE.md.

## CONTRIBUTING

By contributing to this project, you are agreeing to release your contributions under the MIT License.
