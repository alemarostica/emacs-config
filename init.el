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

;;; Environment
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
(global-hl-line-mode 1)

;;; QOL stuff
(recentf-mode 1)
(setq recentf-max-saved-items 200)
(save-place-mode 1)
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)
(delete-selection-mode 1)
(setq read-process-output-max (* 1024 1024))
(setq gc-cons-threshold (* 64 1024 1024))

(load-theme 'modus-vivendi-tritanopia t)
;; (use-package badger-theme
;;   :config
;;   (load-theme 'badger t))
;; (use-package borland-blue-theme
;;   :config
;;   (load-theme 'borland-blue t))

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package which-key
  :init (which-key-mode))

;; Good diff lines
(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         (text-mode . diff-hl-mode)
         (dired-mode . diff-hl-dired-mode)
         (magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (diff-hl-flydiff-mode 1)
  (unless (display-graphic-p)
    (diff-hl-margin-mode 1)))
;; decent colors
(custom-set-faces
 '(diff-hl-insert ((t (:foreground "#83C092" :background "#83C092"))))
 '(diff-hl-delete ((t (:foreground "#E67E80" :background "#E67E80"))))
 '(diff-hl-change ((t (:foreground "#DBBC7F" :background "#DBBC7F")))))

(use-package pulsar
  :bind
  ( :map global-map
    ("C-x l" . pulsar-pulse-line) ; overrides `count-lines-page'
    ("C-x L" . pulsar-highlight-permanently-dwim)) ; or use `pulsar-highlight-temporarily'
  :init
  (pulsar-global-mode 1)
  :config
  (setq pulsar-delay 0.055)
  (setq pulsar-iterations 5)
  (setq pulsar-face 'pulsar-green)
  (setq pulsar-region-face 'pulsar-yellow)
  (setq pulsar-highlight-face 'pulsar-magenta))

;; Boh non si può bindare differentemente?
(setq winum-keymap
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "C-`") 'winum-select-window-by-number)
      (define-key map (kbd "M-0") 'winum-select-window-0-or-10)
      (define-key map (kbd "M-1") 'winum-select-window-1)
      (define-key map (kbd "M-2") 'winum-select-window-2)
      (define-key map (kbd "M-3") 'winum-select-window-3)
      (define-key map (kbd "M-4") 'winum-select-window-4)
      (define-key map (kbd "M-5") 'winum-select-window-5)
      (define-key map (kbd "M-6") 'winum-select-window-6)
      (define-key map (kbd "M-7") 'winum-select-window-7)
      (define-key map (kbd "M-8") 'winum-select-window-8)
      map))

(use-package winum
  :init (winum-mode))

;;; Scrolling, smooth-scrolling package was computationaly heavy
;;; and had lag spikes on fast key repetitions
(setq scroll-conservatively 101
      scroll-preserve-screen-position t
      auto-window-vscroll nil
      fast-but-imprecise-scrolling t)
(setq-default scroll-margin 8)

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

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("C-c M-x" . consult-mode-command)
         ("C-c f" . consult-find)
         ("C-x C-r" . consult-recent-file)
         ("M-y" . consult-yank-pop)
         ("M-s r" . consult-ripgrep)))

(keymap-global-set "M-g g" #'consult-goto-line)
(keymap-global-set "M-g i" #'consult-imenu)
(keymap-global-set "M-g e" #'consult-flymake)

;; Grow/shrink selection by syntactic units
(use-package expreg
  :bind (("C-=" . expreg-expand)
         ("C--" . expreg-contract)))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings)))

;; Move lines or regions with M-up / M-down
(use-package move-text
  :config (move-text-default-bindings))

(use-package vundo
  :bind ("C-x u" . vundo))

;; Duplicate line/region
(keymap-global-set "C-c d" #'duplicate-dwim)

(use-package savehist
  :init (savehist-mode))

(use-package avy
  :bind ("C-x j" . avy-goto-char-timer))

;;; General programming tools
;; Almost all coding languages
(use-package smartparens
  :hook ((prog-mode LaTeX-mode) . smartparens-mode)
  :custom
  (sp-highlight-pair-overlay nil)
  (sp-highlight-wrap-overlay nil)
  (sp-highlight-wrap-tag-overlay nil)
  :config (require 'smartparens-config))

(use-package company
  :hook ((prog-mode LaTeX-mode) . company-mode)
  :custom
  (company-idle-delay 0.1)
  (company-echo-delay 0.1)
  (company-minimum-prefix-length 2)
  (company-backends '((company-capf :with company-dabbrev-code))))

(use-package indent-bars
  :hook (prog-mode . indent-bars-mode)
  :custom
  (indent-bars-color '(highlight :face-bg t :blend 0.2))
  (indent-bars-color-by-depth nil)
  (indent-bars-highlight-current-depth '(:blend 0.6))
  (indent-bars-width-frac 0.15)
  (indent-bars-pad-frac 0.2)
  (indent-bars-display-on-blank-lines t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
;; (custom-set-faces
;;  '(rainbow-delimiters-depth-1-face ((t (:foreground "#E67E80")))) ; Soft Red
;;  '(rainbow-delimiters-depth-2-face ((t (:foreground "#7FBBB3")))) ; Soft Teal
;;  '(rainbow-delimiters-depth-3-face ((t (:foreground "#DBBC7F")))) ; Soft Gold
;;  '(rainbow-delimiters-depth-4-face ((t (:foreground "#D699B6")))) ; Soft Purple
;;  '(rainbow-delimiters-depth-5-face ((t (:foreground "#83C092")))) ; Soft Green
;;  '(rainbow-delimiters-depth-6-face ((t (:foreground "#E69875")))) ; Soft Orange
;;  '(rainbow-delimiters-depth-7-face ((t (:foreground "#7A8478")))) ; Soft Gray/Green
;;  '(rainbow-delimiters-depth-8-face ((t (:foreground "#A7C080")))) ; Lime
;;  '(rainbow-delimiters-depth-9-face ((t (:foreground "#D3C6AA"))))) ; Beige

(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :config (yas-reload-all))

(use-package yasnippet-snippets
  :after yasnippet)

(use-package eglot
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-config '(:size 0 :format full))
  (eglot-send-changes-idle-time 0.3)
  :bind (:map eglot-mode-map
              ("<f7>" . eglot-format-buffer)
              ("C-c a" . eglot-code-actions)
              ("C-c r" . eglot-rename))
  :hook ((c-mode c++-mode) . (lambda ()
                               (add-hook 'before-save-hook #'eglot-format-buffer nil t))))
(with-eval-after-load 'eglot
  (set-face-attribute 'eglot-highlight-symbol-face nil
                      :inherit 'highlight
                      ))

;; Fuzzy search symbols across the whole project
(use-package consult-eglot
  :after (consult eglot)
  :bind (:map eglot-mode-map ("C-c s" . consult-eglot-symbols)))

(with-eval-after-load 'flymake
  (keymap-set flymake-mode-map "M-n" #'flymake-goto-next-error)
  (keymap-set flymake-mode-map "M-p" #'flymake-goto-prev-error))

;; Highlight TODO / FIXME / NOTE
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :custom
  (hl-todo-keyword-faces
      '(("TODO" . "#00FF95")
        ("FIXME" . "#FF9500")
        ("NOTE" . "#9500FF")
        ("DEBUG" . "#0066FF")
        ("HACK" . "#FF0000"))))

(use-package magit-todos
  :after (magit)
  :custom
  (magit-todos-ignored-keywords nil)
  :config (magit-todos-mode 1))

(use-package consult-todo
  :after (consult hl-todo))
(keymap-global-set "C-c t" #'consult-todo)

(use-package sideline
  :custom
  (sideline-delay 0.2)
  (sideline-backends-right '(sideline-eglot sideline-flymake))
  (sideline-flymake-display-mode 'line)
  :init
  (add-hook 'eglot-managed-mode-hook
            (lambda () (sideline-mode (if (eglot-managed-p) 1 -1)))))

(use-package sideline-eglot :after sideline)
(use-package sideline-flymake :after sideline)

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
(add-to-list 'load-path "/home/alessandro/Programs/textui")
(require 'md-mode)

(use-package lua-mode
  :mode ("\\.lua\\'" . lua-mode)
  :hook (lua-mode . eglot-ensure))

;; Rust
(use-package rust-mode
  :hook (rust-mode . eglot-ensure))

(use-package cc-mode
  :hook ((c-mode c++-mode) . eglot-ensure)
  :config
  (setq-default c-basic-offset 4)
  (add-hook 'c-mode-common-hook
            (lambda ()
              (c-set-style "stroustrup")
              (setq c-basic-offset 4))))

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
