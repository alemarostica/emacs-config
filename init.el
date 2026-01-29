(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(setq-default indent-tabs-mode nil)
(setq custom-file "~/.emacs.d/.emacs.custom.el")
;;(setq warning-minimum-level :error)
(setq backup-directory-alist
      '(("." . "~/.emacs.d/backups"))
      auto-save-file-name-transforms
      '((".*" "~/.emacs.d/auto-save-list/" t)))

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-widen t)
(setq display-line-numbers-type 'relative)

(load-file custom-file)

;; packages

;; use PATH from shell
(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns x))
  :config
  (exec-path-from-shell-initialize))

(use-package multiple-cursors
  :ensure t
  :bind
  ;; Add a new cursor to the next line
  ("C-<" . mc/mark-next-like-this)
  ;; Add a new cursor to the previous line
  ("C->" . mc/mark-previous-like-this))

(use-package ample-theme
  :ensure t
  :config
  (load-theme 'ample))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;; (load-theme 'temple-dark t)

(use-package magit
  :ensure t)

;; Completion style: Orderless (recommended for Vertico)
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Vertico: minimalistic vertical completion UI
(use-package vertico
  :ensure t
  :init
  (vertico-mode))

;; Save completion history across sessions
(use-package savehist
  :ensure t
  :init
  (savehist-mode))

;; Marginalia: rich annotations in the minibuffer
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;; Consult: enhanced commands (search, switch buffers, recent files, etc.)
(use-package consult
  :ensure t
  :bind
  (("C-s" . consult-line)
   ("C-c M-x" . consult-mode-command)
   ("C-c f" . consult-find)
   ("M-s r" . consult-ripgrep)
   ("C-x b" . consult-buffer)
   ("C-x C-r" . consult-recent-file)
   ("M-y" . consult-yank-pop)))

(use-package highlight-indent-guides
  :ensure t
  :hook (prog-mode . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-method 'character)
  (highlight-indent-guides-auto-enabled nil))

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 2)
  (setq company-echo-delay 0.1))

;; Eglot is fire
(use-package eglot
  :demand t
  :bind (:map eglot-mode-map
	      ("<f7>" . eglot-format-buffer)
	      ("C-c a" . eglot-code-actions)))

;; fuck rust-ts-mode, it doesn't work
(add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))
(use-package rust-mode
  :mode ("\\.rs" . rust-mode)
  :hook ((rust-mode . eglot-ensure)
	 (rust-mode . company-mode))
  :config
  (add-to-list 'eglot-server-programs '(rust-mode . ("rust-analyzer"))))

;; I hate python, but I have to use it
(use-package pyvenv
  :ensure t
  :config
  (setenv "WORKON_HOME" "~/.venv"))

(use-package python-mode
  :mode ("\\.py" . python-mode)
  :hook ((python-mode . eglot-ensure)
         (python-mode . company-mode))
  :config
  (add-to-list 'eglot-server-programs '(python-mode . ("pyright-langserver" "-m" "--stdio"))))

;; Se si attiva un venv dopo aver aperto un file da un altro venv
;; il language server non si setta giusto, bisogna riavviarlo
(defun my/eglot-restart-after-venv ()
  "Restart Eglot after activating a new Python virtual environment."
  (when (and (bound-and-true-p eglot--managed-mode)
             (let ((client (eglot-current-server)))
               (when client
                 (eglot-reconnect client))))))
             
(add-hook 'pyvenv-post-activate-hooks #'my/eglot-restart-after-venv)
(add-hook 'pyvenv-post-deactivate-hooks #'my/eglot-restart-after-venv)

;; projectile
(use-package projectile
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1)
  :ensure t)

;; c-mode and c++-mode eglot
(use-package c-mode
  :mode ("\\.c$" . c-mode)
  :mode ("\\.h$" . c-mode)
  :hook ((c-mode . eglot-ensure)
         (c-mode . company-mode))
  :config
  (add-to-list 'eglot-server-programs '(c-mode . ("clangd"))))

(use-package c++-mode
  :mode ("\\.cc$" . c++-mode)
  :mode ("\\.cpp$" . c++-mode)
  :mode ("\\.cxx$" . c++-mode)
  :hook ((c++-mode . eglot-ensure)
         (c++-mode . company-mode))
  :config
  (add-to-list 'eglot-server-programs '(c++-mode . ("clangd"))))

;; Fuck, Java è speciale, gotta fix this up
(use-package java-mode
  :mode ("\\.java$" . java-mode)
  :hook ((java-mode . eglot-ensure)
        (java-mode . company-mode))
  :config
  (add-to-list 'eglot-server-programs '(java-mode . ("jdtls"))))

(use-package go-mode
  :ensure t
  :mode ("\\.go\\" . go-mode)
  :hook ((go-mode . eglot-ensure)
         (go-mode . company-mode))
  :config
  ;; Go stuff is installed in go dir so I think it needs the whole path
  (add-to-list 'eglot-server-programs '(go-mode . ("gopls")))
  (before-save . (lambda () (when (derived-moed-p 'go-mode) (eglot-format-buffer))))))

;; keybinds
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
(global-set-key (kbd "<f5>") 'compile)
(global-set-key (kbd "<f6>") 'recompile)

(add-to-list 'load-path "~/.emacs.d/local/")
