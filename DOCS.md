# DOCS - Neovim Configuration

## Plugins Instalados

### UI/Visual
- **noice.nvim** - UI moderna para comandos y notificaciones centradas
- **dressing.nvim** - Diálogos y selectores visuales
- **nvim-notify** - Notificaciones flotantes
- **bufferline.nvim** - Barra de pestañas (como VS Code)
- **indent-blankline.nvim** - Guías visuales de indentación
- **nvim-navic** - Breadcrumbs de ubicación en código (clase > función > método)
- **lualine.nvim** - Barra de estado inferior mejorada

### Editor & Productivity
- **conform.nvim** - Formateador de código
- **treesitter** - Syntax highlighting (manejado por Nix)
- **mini.pairs** - Auto-cierre de paréntesis y llaves
- **mini.surround** - Cambiar caracteres que rodean al texto
- **mini.comment** - Comentar bloques de código
- **todo-comments.nvim** - Gestión visual de TODOs/FIXMEs

### Navigation
- **neo-tree.nvim** - Explorador de archivos
- **oil.nvim** - Editar filesystem como buffer (crear/renombrar/borrar rápido)
- **telescope.nvim** - Búsqueda de archivos y contenido
- **harpoon** - Marcadores rápidos de archivos

### LSP & Completion
- **nvim-lspconfig** - Configuración de lenguajes
- **nvim-cmp** - Autocompletar
- **LuaSnip** - Snippets
- **fidget.nvim** - Indicador de LSP status

### Language Support
- **nvim-jdtls** - Java support
- **rustaceanvim** - Rust support
- **crates.nvim** - Rust crates helper

### Debugging
- **nvim-dap** - Debugger
- **nvim-dap-ui** - UI para debugging

### Git
- **gitsigns.nvim** - Indicators de cambios en archivos
- **vim-fugitive** - Comandos git integrados

### Other
- **which-key.nvim** - Mostrador de keybindings
- **tokyonight.nvim** - Color scheme
- **99** (ThePrimeagen) - AI assistant integration

---

## Keybindings

### General
| Key | Action |
|-----|--------|
| `<C-s>` | Guardar archivo (modo Normal e Insert) |
| `<S-h>` | Ir a pestaña anterior |
| `<S-l>` | Ir a pestaña siguiente |
| `<leader>bd` | Cerrar buffer/pestaña |

### Navigation & Search
| Key | Action |
|-----|--------|
| `<C-f>` | Find files (git o all) |
| `<C-o>` | Find project files (filtered by language) |
| `<C-g>` | Live grep (buscar en contenido) |
| `<C-e>` | Harpoon menu (archivos marcados) |
| `<M-1>` | Jump to harpoon file 1 |
| `<M-2>` | Jump to harpoon file 2 |
| `<M-3>` | Jump to harpoon file 3 |
| `<M-4>` | Jump to harpoon file 4 |
| `<leader>a` | Marcar archivo en harpoon |

### File Explorer
| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>E` | Reveal current file in explorer |
| `<leader>ge` | Git status (float) |

### LSP & Code
| Key | Action |
|-----|--------|
| `K` | Hover documentation |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `go` | Go to type definition |
| `gr` | Find references |
| `gs` | Signature help |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions (normal & visual) |
| `<leader>cd` | Show diagnostic |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>cf` | Format buffer |

### Git
| Key | Action |
|-----|--------|
| `<leader>gg` | Git status |
| `<leader>gl` | Git log (all) |
| `<leader>gL` | Git log (current buffer) |
| `<leader>gd` | Git diff split |
| `<leader>gD` | Git diff vs HEAD~1 |
| `<leader>gq` | Close diff |
| `<leader>gw` | Git add current file |
| `<leader>gr` | Git checkout current file |
| `<leader>gc` | Git commit |
| `<leader>gp` | Git push |
| `<leader>gf` | Git push --force-with-lease |
| `<leader>gP` | Git pull |
| `<leader>gb` | Git blame |

### Hunk Navigation (Git)
| Key | Action |
|-----|--------|
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage buffer |
| `<leader>hR` | Reset buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hd` | Diff this file |
| `<leader>hD` | Diff vs last commit |
| `<leader>tb` | Toggle line blame |
| `<leader>tB` | Show full blame |

### Debugging (DAP)
| Key | Action |
|-----|--------|
| `<leader>dc` | Continue / Start |
| `<leader>dq` | Terminate |
| `<leader>dR` | Restart |
| `<leader>dn` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dl` | Log point |
| `<leader>dC` | Clear breakpoints |
| `<leader>dg` | Run to cursor |
| `<leader>dx` | Exception breakpoints |
| `<leader>dh` | Hover value |
| `<leader>dp` | Preview |
| `<leader>du` | Toggle DAP UI |
| `<leader>de` | Evaluate expression (normal & visual) |

### Java-specific
| Key | Action |
|-----|--------|
| `<leader>oi` | Organize imports |
| `<leader>js` | Download sources |
| `<leader>rv` | Extract variable (normal & visual) |
| `<leader>rc` | Extract constant (normal & visual) |
| `<leader>rm` | Extract method (visual) |
| `<leader>jt` | Test nearest method |
| `<leader>jT` | Test class |
| `<leader>jp` | Pick test |
| `<leader>jd` | Debug main class |
| `<leader>jc` | Generate constructors |
| `<leader>jg` | Generate getters/setters |
| `<leader>je` | Generate equals & hashCode |
| `<leader>jS` | Generate toString |
| `<leader>jD` | Generate delegate methods |

### Rust
| Key | Action |
|-----|--------|
| `<leader>cR` | Code action (rust-specific) |
| `<leader>dr` | Rust debuggables |

### AI (99 plugin)
| Key | Action |
|-----|--------|
| `<leader>9s` | AI search |
| `<leader>9vv` | AI visual (with context) |
| `<leader>9vp` | AI visual with prompt |
| `<leader>9x` | Stop all AI requests |
| `<leader>9i` | AI info |
| `<leader>9l` | View AI logs |
| `<leader>9n` | Next request logs |
| `<leader>9p` | Previous request logs |

### Editing (mini.pairs, mini.surround, mini.comment)
| Key | Action |
|-----|--------|
| `gc` | Toggle comment (línea o selección) |
| `gcc` | Toggle comment de línea |
| `cs<old><new>` | Change surrounding (ej: `cs"'` cambia "text" a 'text') |
| `ds<char>` | Delete surrounding (ej: `ds"` remove quotes) |
| `ys<motion><char>` | Add surrounding (ej: `ysiw"` añade quotes alrededor palabra) |

### TODO Management
| Key | Action |
|-----|--------|
| `[t` | Previous TODO/FIXME comment |
| `]t` | Next TODO/FIXME comment |
| `<leader>tl` | List all TODOs |
| `<leader>tt` | Find TODOs (telescope) |

---

## Leader Key Groups

```
<leader>b   → buffer operations
<leader>c   → code/LSP operations (rn=rename, a=actions, d=diagnostic, f=format)
<leader>d   → debugging (DAP)
<leader>g   → git operations
<leader>h   → hunk/git changes
<leader>j   → java specific
<leader>o   → organize (imports)
<leader>r   → refactor (rv=extract var, rc=extract const, rm=extract method)
<leader>t   → toggle (b=blame, B=full blame, l=list todos, t=find todos)
<leader>9   → AI (99 plugin)
<leader>e   → explorer (e=toggle, E=reveal)
<leader>a   → harpoon add
```

---

## Editor Settings

```lua
-- Display
vim.opt.nu = true                    -- Line numbers
vim.opt.relativenumber = true        -- Relative line numbers
vim.opt.guicursor = ""               -- Block cursor in all modes
vim.opt.scrolloff = 8                -- Keep 8 lines above/below cursor

-- Indentation
vim.opt.tabstop = 4                  -- Tab width
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true             -- Use spaces instead of tabs
vim.opt.smartindent = true

-- Behavior
vim.opt.wrap = false                 -- Don't wrap long lines
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.hlsearch = false             -- Don't highlight all search matches
vim.opt.incsearch = true             -- Incremental search
vim.opt.updatetime = 50              -- Faster updates for diagnostics

-- Visual
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"           -- Always show sign column
```

---

## Features by Plugin

### UI Enhancements
- **Modern command palette** - Commands open in centered dialog instead of bottom line
- **Floating notifications** - Status updates as elegant floating windows
- **Tab bar** - All open files visible with icons and error indicators
- **Indent guides** - Visual lines showing code structure
- **Breadcrumbs** - See current location (class > function > method) in status bar
- **Enhanced status line** - Mode, branch, diagnostics, encoding, position

### Code Completion
- Press `<C-Space>` in insert mode to trigger suggestions
- `<C-p>` / `<C-n>` to navigate completions
- `<C-y>` to accept completion
- `<C-l>` / `<C-h>` to jump through snippet placeholders

### Formatting
- `<leader>cf` to format buffer
- Supported: javascript, typescript, nix, lua, xml, yaml

### Diagnostics
- Errors shown inline and in status bar
- `[d` / `]d` to navigate diagnostics
- `<leader>cd` to see detailed diagnostic

### Git Integration
- File changes shown with colors in line numbers
- Press `<leader>h*` for hunk operations
- Full git command support via `:G` or `<leader>g*`

### Debugging
- Set breakpoints with `<leader>db`
- Start with `<leader>dc`
- Step with `<leader>dn/di/do`
- DAP UI shows automatically

### File Finding
- `<C-f>` finds files (auto uses git if in repo)
- `<C-o>` finds files filtered by language
- `<C-g>` searches file contents
- `<C-e>` shows harpoon menu for quick jump

---

## Language-Specific Setup

### Java
- **LSP**: JDTLS with automatic setup
- **Debug**: Support for Spring Boot and main classes
- **Test**: Run tests with `<leader>jt`
- **Refactor**: Extract variable/method/constant
- **Generators**: Generate constructors, getters, toString, etc.

### Rust
- **LSP**: rust-analyzer with all features enabled
- **Crates**: Inline crate version suggestions
- **Debug**: Rust debuggables support
- **CodeActions**: Rust-specific code actions

### TypeScript/JavaScript
- **LSP**: TypeScript language server
- **Format**: prettier/prettierd
- **Completion**: Full TS/JS support

### Nix
- **LSP**: nil_ls with alejandra formatter
- **Format**: Automatic with `<leader>cf`

### Lua
- **LSP**: lua_ls with Neovim API support
- **Format**: stylua

---

## Performance

All plugins use **lazy loading**, meaning they only load when needed:
- LSP plugins load only when a supported file is opened
- DAP loads only when debugging starts
- UI plugins load after startup completes
- Zero impact on startup time

---

## Troubleshooting

```bash
# Reload config
:source ~/.config/nvim/init.lua

# Check LSP status
:LspInfo

# View plugin logs
:Lazy log

# Full health check
:checkhealth
```

If plugins don't load:
```bash
rm -rf ~/.local/share/nvim/lazy/
nvim  # Will reinstall all plugins
```

---

## Editing Features (mini.*)

### auto-close pairs (mini.pairs)
Automatically closes brackets, braces, quotes:
- Type `(` → becomes `()`
- Type `"text` → becomes `"text"`
- Works with: `()`, `[]`, `{}`, `""`, `''`, `` ` ``
- **No keybindings needed** - automatic in insert mode

### Change/Delete/Add Surrounding (mini.surround)

**Change surrounding:** `cs<old><new>`
```vim
"hello" with cs"'  →  'hello'
(text) with cs)]  →  [text]
```

**Delete surrounding:** `ds<char>`
```vim
"hello" with ds"  →  hello
(text) with ds(   →  text
```

**Add surrounding:** `ys<motion><char>`
```vim
hello with ysiw"  →  "hello"  (surround inner word with quotes)
```

### Comment Toggle (mini.comment)

**In normal mode:**
- `gc` + motion → toggle comment (ej: `gcip` = comment inner paragraph)
- `gcc` → toggle comment of line
- `gcc` → toggle uncomment of line

**In visual mode:**
- Select text and press `gc` → toggle comment

Auto-detects language and uses correct comment syntax.

### TODO Comments

In your code, write:
```
-- TODO: fix this later
// FIXME: broken functionality  
/* HACK: temporary solution */
-- WARN: be careful here
```

Navigate with `[t` and `]t`, search with `<leader>tt`

---

## File Browser - Oil (oil.nvim)

Edit your filesystem like a buffer. Opens in your current directory.

**Opening:**
- `<leader>o` - Open oil file browser

**Navigation & Editing:**
- `<CR>` - Enter directory or open file
- `<C-s>` - Open in vertical split
- `<C-h>` - Open in horizontal split
- `<C-t>` - Open in new tab
- `-` - Go to parent directory
- `_` - Open current working directory
- `g.` - Toggle hidden files
- `gs` - Change sort order
- `:w` - Save changes (creates/deletes/renames files)

**Example workflow:**
```
:Oil                    Open current dir as buffer
# Now you can:
dd                      Delete file/dir
yy                      Copy file/dir
p                       Paste
Enter                   Edit filename
:w                      Save all changes
```

---

## Which-Key Improvements (Fase 3)

Which-key now shows all keybindings organized by group:
- Press `<space>` (leader) and wait 400ms
- See all available commands grouped logically
- Descriptions for each keybinding

Groups:
- `<leader>b` - buffer
- `<leader>c` - code
- `<leader>d` - debug
- `<leader>g` - git
- `<leader>h` - hunk
- `<leader>j` - java
- `<leader>o` - oil/organize
- `<leader>r` - refactor
- `<leader>t` - toggle/todo
- `<leader>9` - AI

---

## Telescope Optimizations (Fase 3)

Telescope now has better defaults:
- **Horizontal layout** with preview on the right
- **Hidden files** included by default
- **File exclusions** for node_modules, target, build, dist, .git
- **Better sizing** and performance

Same keybindings:
```
<C-f>    Find all files
<C-o>    Find project files (language filtered)
<C-g>    Live grep (search content)
```

---

## Fase 3 Summary

✓ **oil.nvim** - Filesystem editing
✓ **which-key** - Better organization and descriptions
✓ **telescope** - Improved layout and performance


