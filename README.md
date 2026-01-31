# ob-mermaid-ascii

An Emacs package that extends Org Babel with Mermaid diagram support, rendering
diagrams as ASCII art in the results block using
[mermaid-ascii](https://github.com/AlexanderGrooff/mermaid-ascii).

## Requirements

- **mermaid-ascii** binary must be installed and on your PATH
- Emacs 27.1+
- Org mode 9.0+

### Installing mermaid-ascii

Download from [GitHub
releases](https://github.com/AlexanderGrooff/mermaid-ascii/releases):

```shell
# Get the latest release (macOS example)
curl -sL https://github.com/AlexanderGrooff/mermaid-ascii/releases/latest/download/mermaid-ascii_Darwin_$(uname -m).tar.gz | tar xz
sudo mv mermaid-ascii /usr/local/bin/
```

Or build from source:

```shell
git clone https://github.com/AlexanderGrooff/mermaid-ascii
cd mermaid-ascii
go build
sudo mv mermaid-ascii /usr/local/bin/
```

## Installation

### Manual

1. Clone or copy this repository
2. Add to your `load-path`:
   ```elisp
   (add-to-list 'load-path "/path/to/ob-mermaid-ascii")
   (require 'ob-mermaid-ascii)
   ```
3. Enable mermaid in Org Babel (if not auto-enabled):
   ```elisp
   (org-babel-do-load-languages
    'org-babel-load-languages
    '((mermaid . t)))
   ```

### use-package

```elisp
(use-package ob-mermaid-ascii
  :ensure nil
  :load-path "path/to/ob-mermaid-ascii"
  :after org
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((mermaid . t)))
  (setq org-babel-mermaid-ascii-command "mermaid-ascii"))
```

## Usage

### Basic flowchart

```org
#+begin_src mermaid
graph LR
A --> B
B --> C
C --> A
#+end_src
```

Execute with `C-c C-c` on the source block. Result:

```
┌───┐     ┌───┐     ┌───┐
│   │     │   │     │   │
│ A ├────►│ B ├────►│ C │
│   │     │   │     │   │
└───┘     └───┘     └─┬─┘
                     │
                     │
                     ▼
                   ┌───┐
                   │   │
                   │ A │
                   │   │
                   └───┘
```

### Sequence diagram

```org
#+begin_src mermaid
sequenceDiagram
Alice->>Bob: Hello Bob!
Bob-->>Alice: Hi Alice!
#+end_src
```

### With options (pure ASCII, extra padding)

```org
#+begin_src mermaid :cmdline "--ascii -x 8"
graph TD
A --> B
A --> C
B --> C
#+end_src
```

### Header arguments

| Argument | Description |
|----------|-------------|
| `:cmdline` | Extra arguments for mermaid-ascii (e.g. `"--ascii"`, `"-x 8"`, `"-p 2"`) |

### mermaid-ascii options

- `--ascii` - Use pure ASCII characters (no Unicode box-drawing)
- `-x, --paddingX` - Horizontal space between nodes (default: 5)
- `-y, --paddingY` - Vertical space between nodes (default: 5)
- `-p, --borderPadding` - Padding between text and border (default: 1)
- `-c, --coords` - Show coordinates (debug)

## Supported diagram types

mermaid-ascii supports:

- **Graphs/Flowcharts** - `graph LR`, `graph TD`, subgraphs, labeled edges,
  `classDef`
- **Sequence diagrams** - `sequenceDiagram`, participants, solid/dotted arrows

## Customization

- `org-babel-mermaid-ascii-command` - Command to run (default:
  `"mermaid-ascii"`). Set to full path if not on PATH.

## License

GPL-3.0-or-later
