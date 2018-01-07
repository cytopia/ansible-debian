# Contributing

If you want to contribute to this repository, please stick to the following best-practicses.


### roles/ROLE_NAME/vars/main.yml

Every role should include a `<role_name>` variable which is set to `ignore` by default, but being able to take `install` and `remove` as values. The role will only be installed in case of a value of `install` and only removed in case of a value of `remove`.

All other variables that allow overwriting via group/host_vars should also go in there. Make sure to prefix each variable with the role name.

### roles/ROLE_NAME/tasks/main.yml

This file should look like this:
```yml
---

- include_tasks: install.yml
  when: <ROLE_NAME> == 'install'

- include_tasks: uninstall.yml
  when: <ROLE_NAME> == 'remove'
```

You can of course add some asserts and validation at the very top of the file.

### roles/ROLE_NAME/vars/defaults.yml

Any variable that should not be overwritten must go here and not in `defaults/main.yml`.


**Naming convention:**

| Variable                   | Type   | Description |
|----------------------------|--------|-------------|
| `<role_name>_package_name` | String | Holds the main package name that can also be uninstalled safely |
| `<role_name>_shared_packages` | List | Array of required packages that might also be required by other applications - will not be uninstalled |
| `<role_name>_exclusive_packages` | List | Array of required packages only to this tool. Can be safely uninstalled when this role is uninstalled |
