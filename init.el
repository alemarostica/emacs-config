(package-initialize)

(setq-default indent-tabs-mode nil)
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

;; keybinds
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
(global-set-key (kbd "<f5>") 'compile)
(global-set-key (kbd "<f6>") 'recompile)

(add-to-list 'load-path "~/.emacs.d/local/")
