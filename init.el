;; ---------------------------------------------------
;; Sample emacs config focusing on clojure development
;; ---------------------------------------------------

;; installed packages
;; - exec-path-from-shell (not from stable!)
;; - hl-sexp
;; - paredit
;; - clojure-mode
;; - cider
;; - company
;; - flycheck (not from stable!)
;; - flycheck-clojure
;; - clj-refactor

;; Add .emacs.d/lisp to load-path
(setq dotfiles-lisp-dir
      (file-name-as-directory
       (concat (file-name-directory
                (or (buffer-file-name) load-file-name))
               "lisp")))
(add-to-list 'load-path dotfiles-lisp-dir)

;; don't use tabs for indent
(setq-default indent-tabs-mode nil)

;; emacs package management
;; use MELPA stable
(require 'package)

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(setq package-user-dir (concat user-emacs-directory "elpa"))
(add-to-list 'load-path (concat user-emacs-directory "site-lisp"))

(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (package-install package)
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))

(setq package-enable-at-startup nil) ; Don't initialize later as well

(package-initialize)

;; show opening, closing parens
(show-paren-mode)

(require-package 'epl)

(require-package 'exec-path-from-shell)
;; Sort out the $PATH for OSX
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(dolist (file '("cfg-paredit.el"
		"cfg-flycheck.el"
		"cfg-hlsexp.el"
		"cfg-cider.el"
                "cfg-cljrefactor.el"))
  (load (concat dotfiles-lisp-dir file)))


;;;;
;; Customization
;;;;
(require-package 'better-defaults)
(require 'better-defaults)

;; Color Themes
;; Read http://batsov.com/articles/2012/02/19/color-theming-in-emacs-reloaded/
;; for a great explanation of emacs color themes.
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Custom-Themes.html
;; for a more technical explanation.
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(add-to-list 'load-path "~/.emacs.d/themes")
(load-theme 'tomorrow-night-bright t)

;; increase font size for better readability
;(set-face-attribute 'default nil :height 140)

;; no bell
(setq ring-bell-function 'ignore)

;; Evil mode
(require-package 'evil)
(require-package 'evil-leader)
(require 'evil)
(evil-mode t)
(setq evil-leader/in-all-states 1)
(global-evil-leader-mode)
(evil-leader/set-leader "\\")

(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))

;; helm settings (TAB in helm window for actions over selected items,
;; C-SPC to select items)
(require-package 'helm)
(require-package 'helm-projectile)
(require 'helm-config)
(require 'helm-misc)
(require 'helm-projectile)
(require 'helm-locate)
(setq helm-quick-update t)
(setq helm-bookmark-show-location t)
(setq helm-buffers-fuzzy-matching t)
(global-set-key (kbd "M-x") 'helm-M-x)
(evil-leader/set-key "h" 'helm-M-x)
(evil-leader/set-key "f" 'projectile-find-file)
(evil-leader/set-key "b" 'helm-buffers-list)
(evil-leader/set-key "u" 'undo-tree-visualize)

(defun helm-my-buffers ()
  (interactive)
  (let ((helm-ff-transformer-show-only-basename nil))
  (helm-other-buffer '(helm-c-source-buffers-list
                       helm-c-source-elscreen
                       helm-c-source-projectile-files-list
                       helm-c-source-ctags
                       helm-c-source-recentf
                       helm-c-source-locate)
                     "*helm-my-buffers*")))

(require-package 'powerline-evil)
(require 'powerline-evil)
(powerline-evil-vim-color-theme)
(display-time-mode t)

(define-key global-map (kbd "RET") 'newline-and-indent)
(setenv "PATH" (concat (getenv "PATH") ":~/.bin"))
(setq exec-path (append exec-path '("~/.bin")))

