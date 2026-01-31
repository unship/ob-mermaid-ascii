;;; ob-mermaid-ascii.el --- Org Babel support for Mermaid diagrams as ASCII -*- lexical-binding: t; -*-

;; Copyright (C) 2025 ob-mermaid-ascii contributors
;; Author: ob-mermaid-ascii contributors
;; Keywords: org, babel, mermaid, ascii, diagrams
;; URL: https://github.com/vscode/ob-mermaid-ascii
;; Package-Requires: ((emacs "27.1") (org "9.0"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This package extends Org Babel with support for Mermaid diagrams,
;; rendering them as ASCII art in the results block using
;; mermaid-ascii (https://github.com/AlexanderGrooff/mermaid-ascii).
;;
;; Requirements:
;;   - mermaid-ascii binary must be installed and on PATH
;;   - Install from: https://github.com/AlexanderGrooff/mermaid-ascii/releases
;;
;; Usage:
;;
;;   #+begin_src mermaid
;;   graph LR
;;   A --> B
;;   B --> C
;;   #+end_src
;;
;;   #+begin_src mermaid :cmdline "--ascii -x 8"
;;   sequenceDiagram
;;   Alice->>Bob: Hello
;;   Bob-->>Alice: Hi
;;   #+end_src
;;
;; Supported header arguments:
;;   :cmdline  - Extra arguments for mermaid-ascii (e.g. "--ascii", "-x 8", "-p 2")

;;; Code:

(require 'org-macs)
(org-assert-version)
(require 'ob)
(require 'org-compat)

(defgroup org-babel-mermaid-ascii nil
  "Org Babel support for Mermaid diagrams as ASCII."
  :group 'org-babel)

(defcustom org-babel-mermaid-ascii-command "mermaid-ascii"
  "Command to run mermaid-ascii.
Can be the binary name if on PATH, or full path."
  :group 'org-babel-mermaid-ascii
  :type 'string)

(defvar org-babel-default-header-args:mermaid
  '((:results . "output")
    (:exports . "results"))
  "Default header arguments for mermaid source blocks.")

(defconst org-babel-header-args:mermaid
  '((cmdline . :any))
  "Mermaid-specific header arguments.")

(defvar org-babel-tangle-lang-exts)
(add-to-list 'org-babel-tangle-lang-exts '("mermaid" . "mermaid"))

;;;###autoload
(defun org-babel-execute:mermaid (body params)
  "Execute Mermaid BODY with org-babel, rendering as ASCII.
Uses mermaid-ascii (https://github.com/AlexanderGrooff/mermaid-ascii).
PARAMS may contain :cmdline for extra arguments."
  (let* ((cmdline (cdr (assq :cmdline params)))
         (in-file (org-babel-temp-file "mermaid-" ".mermaid"))
         (cmd (concat org-babel-mermaid-ascii-command
                     " -f " (shell-quote-argument (expand-file-name in-file))
                     (when cmdline (concat " " cmdline))
                     "")))
    (with-temp-file in-file
      (insert body))
    (let ((result (shell-command-to-string cmd)))
      (if (string-empty-p (string-trim result))
          (error "mermaid-ascii produced no output. Is it installed? Run: mermaid-ascii --help")
        (string-trim result)))))

(defun org-babel-prep-session:mermaid (_session _params)
  "Mermaid does not support sessions."
  (error "Mermaid does not support sessions"))

(provide 'ob-mermaid-ascii)

;;; ob-mermaid-ascii.el ends here
