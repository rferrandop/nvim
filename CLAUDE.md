# CLAUDE.md

Configuración de Neovim (lazy.nvim). Este fichero recoge **decisiones y convenciones**
del setup; la lista de plugins está en `DOCS.md`.

## Entorno

- Se usa en **macOS en el trabajo**. Los JDK se gestionan con **SDKMAN**
  (`~/.sdkman/candidates/java/*`, activo vía el symlink `current`).
- Flujo con **git worktrees**: varios checkouts del mismo proyecto abiertos a la vez.
- El `flake.nix` de este repo es un placeholder vacío; el toolchain de Java
  (`JAVA_DEBUG_EXTENSION`, `JAVA_TEST_EXTENSION`, JDKs) lo provee el devShell/SDKMAN
  de cada proyecto, no esta config.

## Java / jdtls (`lua/raulf/plugins/jdtls.lua`)

- **Workspace aislado por worktree**: `workspace_dir` incluye un hash del `root_dir`
  absoluto (`project_name .. "-" .. sha256(root_dir)`). Sin esto, dos worktrees del
  mismo proyecto comparten `artifactId` → mismo `.metadata` → corrupción de índice.
- **Runtimes desde SDKMAN**: `java_runtimes()` descubre los JDK de
  `~/.sdkman/candidates/java/*`, los mapea a execution environments de Eclipse
  (`8→JavaSE-1.8`, `17→JavaSE-17`, ...), deduplica por versión y marca `default` el
  que apunta `current`. Se inyectan en `settings.java.configuration.runtimes`.

## Debug (`lua/raulf/plugins/dap.lua`)

- Perfiles de lanzamiento por proyecto/worktree vía **`.vscode/launch.json`**
  (auto-cargado del cwd; recargar con `<leader>dL`). Elegir perfil con `<leader>dc`.
- Convención de secretos: commitear `launch.json` (estructura no sensible) +
  `.env.example`; gitignorar `.env.*`. Los secretos van en un env file referenciado
  con `envFile`, nunca en `launch.json`.
- Perfiles de Spring vía `-Dspring.profiles.active=...` en `vmArgs`. Los perfiles de
  build de Maven (`-P`) son de compilación, no de ejecución: jdtls/DAP no invocan
  Maven al lanzar.

## Explorer (`lua/raulf/plugins/explorer.lua`)

- neo-tree agrupa directorios vacíos (`group_empty_dirs`, paquetes Java
  `com/example/app`) **solo en proyectos Java**: cuando jdtls está activo o el cwd
  cuelga de una raíz Maven/Gradle. Un autocmd `LspAttach` lo activa en caliente si
  jdtls se engancha con el árbol ya abierto.

## Buffers / UI

- `<leader>bd` usa `mini.bufremove` (no `:bdelete`) para no arrastrar el cierre de
  la ventana / salida de nvim al borrar el último buffer.
- La barra superior la gestiona **bufferline** en modo `buffers`; lualine no define
  `tabline` para que no peleen por `showtabline`.
