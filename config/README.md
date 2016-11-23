Because yaml is easier to read, it is preferred to coding this with performance in mind

The config structure is

```
├── config
    ├── qemu.yaml
    ├── variables.yaml
    ├── vbox.yaml
    └── vmware.yaml
```

The various provider types are concatenated with the `variables.yaml` file into a template.json file that is utilized by the packer binary. It will place the artifacts into the `build` directory in the root of the project upon build (the contents of which are ignored in git).
