(package-initialize)

(setq-default indent-tabs-mode nil)
(setq c-basic-offset 4)
(setq custom-file "~/.emacs.d/.emacs.custom.el")
;;(setq warning-minimum-level :error)
(setq backup-directory-alist
      '(("." . "~/.emacs.d/backups"))
      auto-save-file-name-transforms
      '((".*" "~/.emacs.d/auto-save-list/" t)))

(add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(ido-mode 1)
(ido-everywhere 1)
(global-display-line-numbers-mode 1)

(load-file custom-file)
(load-file "~/.emacs.d/rc/rc.el")

;; packages

(rc/require-theme 'gruvbox)
(rc/require 'smex)

(use-package magit
  :ensure t)

(use-package markdown-mode
  :ensure t)

(use-package company
  :ensure t)

;; Eglot is fire
(use-package eglot
  :demand t
  :bind (:map eglot-mode-map
	      ("<f7>" . eglot-format-buffer)
	      ("C-c a" . eglot-code-actions)))

;; fuck rust-ts-mode, it doesn't work
(use-package rust-mode
  :mode ("\\.rs" . rust-mode)
  :hook ((rust-mode . eglot-ensure)
	 (rust-mode . company-mode))
  :config
  (add-to-list 'eglot-server-programs '(rust-mode . ("rust-analyzer"))))

;; I hate python, but I have to use it
(use-package python-mode
  :mode ("\\.py" . python-mode)
  :hook ((python-mode . eglot-ensure)
         (python-mode . company-mode))
  :config
  (add-to-list 'eglot-server-programs '(python-mode . ("pyright-langserver"))))

;; projectile
(use-package projectile
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1)
  :ensure t)

;; c-mode and c++-mode eglot
(use-package c-mode
  :mode ("\\.c" . c-mode)
  :mode ("\\.h" . c-mode)
  :hook ((c-mode . eglot-ensure)
         (c-mode . company-mode))
  :config
  (add-to-list 'eglot-server-programs '(c-mode . ("clangd"))))

(use-package c++-mode
  :mode ("\\.cc" . c++-mode)
  :mode ("\\.cpp" . c++-mode)
  :mode ("\\.cxx" . c++-mode)
  :hook ((c++-mode . eglot-ensure)
         (c++-mode . company-mode))
  :config
  (add-to-list 'eglot-server-programs '(c++-mode . ("clangd"))))

;; keybinds
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
(global-set-key (kbd "<f5>") 'compile)
(global-set-key (kbd "<f6>") 'recompile)

(add-to-list 'load-path "~/.emacs.d/local/")
