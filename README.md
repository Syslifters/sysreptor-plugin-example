# SysReptor Plugin Example

This repository serves as a starting point for developing custom [SysReptor](https://docs.sysreptor.com/) plugins.
With plugins, you can extend SysReptor's functionality without modifying the core code.

## Documentation

For comprehensive documentation on SysReptor plugins, please refer to the official documentation:
- [SysReptor Plugin Documentation](https://docs.sysreptor.com/setup/plugins)

## Getting Started

### 1. Prerequisites

- A working SysReptor installation
- Docker and Docker Compose


### 2. Integration with SysReptor

To integrate your custom plugins with SysReptor, follow these steps:

#### Step 1: Configure docker-compose.yml

Edit the `docker-compose.yml` file in your SysReptor installation (located at `sysreptor/deploy/docker-compose.yml`) to include the path to this plugin repository's override file:

```yaml
name: sysreptor
include:
  - path:
    - sysreptor/docker-compose.yml
    # Path to sysreptor.docker-compose.override.yml in your plugin repository
    # Note: Path is relative to sysreptor/deploy/docker-compose.yml (or an absolute path)
    - /path/to/sysreptor-plugin-example/sysreptor.docker-compose.override.yml
```

#### Step 2: Update context path in override file

Edit the `sysreptor.docker-compose.override.yml` file in this repository to set the correct path to your plugin directory:

```yaml
services:
  app:
    # Override the docker image
    image: !reset null
    build:
      # Note: Path is relative to sysreptor/deploy/docker-compose.yml (or an absolute path)
      context: /absolute/path/to/sysreptor-plugin-example
      args:
        SYSREPTOR_VERSION: ${SYSREPTOR_VERSION:-latest}
```

Replace `/absolute/path/to/sysreptor-plugin-example` with the absolute path to this repository on your system.

#### Step 3: Enable the plugins

Add the plugin names to the `ENABLED_PLUGINS` environment variable in your `app.env` file (located at `sysreptor/deploy/app.env`):

```
ENABLED_PLUGINS=myplugin1,myplugin2
```

#### Step 4: Rebuild and restart SysReptor

```bash
cd /path/to/sysreptor/deploy
docker compose up -d --build
```


## ⚠️ Compatibility Warning

**Important:** SysReptor updates may break compatibility with custom plugins. Internal APIs and structures can change without notice between versions.

- **Always test plugins in a staging environment** before updating your production instance
- After SysReptor updates, verify that all plugins work correctly before deploying to production
- Be prepared to update your plugins when SysReptor is updated


## Developing Custom Plugins

Each plugin should be placed in the `custom_plugins` directory and must follow the SysReptor plugin structure:

- Each plugin must have a unique `plugin_id` defined in its `apps.py`
- At minimum, each plugin needs `__init__.py` and `apps.py` files
- The [demoplugin](https://github.com/Syslifters/sysreptor/tree/main/plugins/demoplugin) is a good reference
- See https://docs.sysreptor.com/setup/plugins/ for more details


### Frontend Development

Frontend plugins require a `plugin.js` file to register hooks and pages. The actual pages are loaded in `iframes`, so you can use any frontend framework you prefer.

SysReptor provides some Vue/Nuxt UI components to be reused in plugins. To use them, follow these steps:

1. Place your code in the `frontend/` directory
2. Build assets to the `static/` directory
3. Use the SysReptor provided `@sysreptor/plugin-base-layer` for UI components
    * This package is located in the `sysreptor-src` submodule.
    * If you don't need a frontend plugin, you can remove the submodule.
4. For more details see https://docs.sysreptor.com/setup/plugins/#frontend-plugin


### Testing

Run tests for your plugin:

```bash
# Test a single plugin
docker compose run --rm -e ENABLED_PLUGINS=myplugin1 app pytest sysreptor_plugins/myplugin1
```


