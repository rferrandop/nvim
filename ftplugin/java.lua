local jdtls = require "jdtls"

-- Determine OS
local home = vim.env.HOME
local launcher_path =
  vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
if #launcher_path == 0 then
  launcher_path =
    vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar", 1, 1)[1]
end

if vim.fn.has "mac" == 1 then
  WORKSPACE_PATH = home .. "/.cache/jdtls/workspace/"
  CONFIG = "mac"
elseif vim.fn.has "unix" == 1 then
  WORKSPACE_PATH = home .. "/.cache/jdtls/workspace/"
  CONFIG = "linux"
else
  print "Unsupported system"
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local workspace_dir = WORKSPACE_PATH .. project_name

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
  return
end

local bundles = vim.fn.glob(home .. "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)
local extra_bundles = vim.fn.glob(home .. "/.local/share/nvim/mason/packages/java-test/extension/server/*.jar", true, true)
vim.list_extend(bundles, extra_bundles)


local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    launcher_path,
    "-configuration",
    home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. CONFIG,
    "-data",
    workspace_dir,
  },
  root_dir = root_dir,
  settings = {
    java = {
      eclipse = {
        downloadSources = true
      },
      maven = {
        downloadSources = true
      },
      autobuild = {
        enabled = true,
      },
      format = {
        enabled = true,
        settings = {
          profile = "JavaPalantir Style",
          url = "https://github.com/apache/iceberg/blob/main/.baseline/idea/intellij-java-palantir-style.xml"
        }
      }
    },
  },
  init_options = {
    bundles = bundles
  }
}

jdtls.start_or_attach(config)
