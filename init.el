;; -*- lexical-binding: t; -*-

;;; Bootstrapping
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(package-initialize)

;;; use-package if not present
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
;; ensure packages installed by default
(setq use-package-always-ensure t)

;;; Evironment
(let ((my-paths '("~/go/bin" "~/.local/bin" "~/.cargo/bin" "/usr/local/go/bin")))
  (dolist (path my-paths)
    (let ((expanded (expand-file-name path)))
      (add-to-list 'exec-path expanded)
      (setenv "PATH" (concat expanded path-separator (getenv "PATH"))))))

;;; Global settings
(setq-default
 indent-tabs-mode nil
 tab-width 4
 custom-file (expand-file-name ".emacs.custom.el" user-emacs-directory))

;;; Clean UI
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

;; (use-package badger-theme
;;   :config
;;   (load-theme 'modus-vivendi-tritanopia t))
(use-package borland-blue-theme
  :config
  (load-theme 'borland-blue t))

;;; Smooth scrolling wiht margin
(use-package smooth-scrolling
  :hook
  (prog-mode . smooth-scrolling-mode)
  :custom
  (smooth-scroll-margin 5))

;;; Backups and autosave
(setq backup-directory-alist `(("." . ,(expand-file-name "backups" user-emacs-directory)))
      auto-save-file-name-transforms `((".*",(expand-file-name "auto-save-list/" user-emacs-directory) t)))

;;; Line numbers
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative
      display-line-numbers-widen t)

;;; Completion stack
(use-package vertico
  :init (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("C-c M-x" . consult-mode-command)
         ("C-c f" . consult-find)
         ("C-x C-r" . consult-recent-file)
         ("M-y" . consult-yank-pop)
         ("M-s r" . consult-ripgrep)))

(use-package savehist
  :init (savehist-mode))

(use-package avy
  :bind ("C-x g" . avy-goto-char-timer))

;;; General programming tools
;; Almost all coding languages
(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :config (require 'smartparens-config))

(use-package company
  :hook (prog-mode . company-mode)
  :custom
  (company-idle-delay 0.1)
  (company-echo-delay 0.1)
  (company-minimum-prefix-length 2)
  (company-backends '((company-capf :with company-dabbrev-code))))

(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (set-face-background 'highlight-indent-guides-odd-face "darkgray")
  (set-face-background 'highlight-indent-guides-even-face "dimgray")
  (set-face-foreground 'highlight-indent-guides-character-face "dimgray")
  :custom
  (highlight-indent-guides-method 'character)
  (highlight-indent-guides-auto-enabled nil)
  (highlight-indent-guides-responsive 'top))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(custom-set-faces
 '(rainbow-delimiters-depth-1-face ((t (:foreground "#E67E80")))) ; Soft Red
 '(rainbow-delimiters-depth-2-face ((t (:foreground "#7FBBB3")))) ; Soft Teal
 '(rainbow-delimiters-depth-3-face ((t (:foreground "#DBBC7F")))) ; Soft Gold
 '(rainbow-delimiters-depth-4-face ((t (:foreground "#D699B6")))) ; Soft Purple
 '(rainbow-delimiters-depth-5-face ((t (:foreground "#83C092")))) ; Soft Green
 '(rainbow-delimiters-depth-6-face ((t (:foreground "#E69875")))) ; Soft Orange
 '(rainbow-delimiters-depth-7-face ((t (:foreground "#7A8478")))) ; Soft Gray/Green
 '(rainbow-delimiters-depth-8-face ((t (:foreground "#A7C080")))) ; Lime
 '(rainbow-delimiters-depth-9-face ((t (:foreground "#D3C6AA"))))) ; Beige

(use-package eglot
  :bind (:map eglot-mode-map
              ("<f7>" . eglot-format-buffer)
              ("C-c a" . eglot-code-actions)))
(with-eval-after-load 'eglot
  (set-face-attribute 'eglot-highlight-symbol-face nil
                      :inherit 'highlight
                      ))

(use-package projectile
  :init (projectile-mode +1)
  :bind (:map projectile-mode-map ("C-c p" . projectile-command-map))
  :custom (projectile-ignored-projects '("~/" "/tmp")))

(use-package multiple-cursors
  :bind (("C-<" . mc/mark-next-like-this)
         ("C->" . mc/mark-previous-like-this)))

;;; Language Specifics

;; Python
(use-package pyvenv
  :config
  (setenv "WORKON_HOME" "~/.venv")
  ;; Fix for venv + eglot
  (defun my/eglot-restart-after-venv ()
    (when (bound-and-true-p eglot--managed-mode)
      (eglot-reconnect (eglot-current-server))))
  (add-hook 'pyvenv-post-activate-hooks #'my/eglot-restart-after-venv))

(use-package python
  :mode ("\\.py\\'" . python-mode)
  :hook (python-base-mode . eglot-ensure)
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs '(python-base-mode . ("ty" "server")))))

;; md-mode (https://github.com/yibie/md-mode)
;; Download and put in path
(add-to-list 'load-path "/home/alessandro/Programs/md-mode")
(require 'md-mode)

(use-package lua-mode
  :mode ("\\.lua\\'" . lua-mode)
  :hook (lua-mode . eglot-ensure))

;; Rust
(use-package rust-mode
  :hook (rust-mode . eglot-ensure))

(use-package cc-mode
  :hook ((c-mode c++-mode) . eglot-ensure))

(use-package cuda-mode
  :mode ("\\.cu\\'" . cuda-mode)
  :hook (cuda-mode . eglot-ensure)
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs '(cuda-mode . ("clangd")))))

;; Go
(use-package go-mode
  :hook (go-mode . (lambda ()
                     ;; avoid home indexing
                     (let ((project (project-current)))
                       (when (and project
                                  (not (string= (expand-file-name (project-root project))
                                                (expand-file-name "~/"))))
                         (eglot-ensure))))))

;; Java and Gradle
(use-package gradle-mode
  :custom
  (gradle-use-gradlew t)
  (gradle-gradlew-executable "./gradlew"))

(use-package java-mode
  :ensure nil
  :mode "\\.java\\'"
  :hook (java-mode . (lambda ()
                       (eglot-ensure)
                       (gradle-mode 1)
                       (setq tab-width 4))))

;; Latex
(use-package tex
  :ensure auctex
  :mode ("\\.tex\\'" . LaTeX-mode)
  :hook (LaTeX-mode . eglot-ensure))

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (setq-local company-backends '(company-capf))
            (setq-local company-minimum-prefix-length 1)))

;;; Keybinds and other
(global-set-key (kbd "<f5>") 'compile)
(global-set-key (kbd "<f6>") 'recompile)
(keymap-global-set "C-c c" 'comment-or-uncomment-region)

(when (file-exists-p custom-file)
  (load custom-file))

(add-to-list 'load-path "~/.emacs.d/local/")
