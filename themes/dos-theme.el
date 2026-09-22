;;; dos-theme.el --- A theme that looks like the classic MS-DOS editor -*- lexical-binding: t; -*-

;; Author: You
;; Version: 1.0
;; Package-Requires: ((emacs "24.1"))
;; Keywords: faces, theme

;;; Commentary:

;; Recreates the look of the old MS-DOS Editor (EDIT.COM) / Turbo Pascal
;; IDE: navy-blue background, light gray text, bright cyan/yellow/white
;; accents, and a blocky, no-nonsense CGA-style 16-color palette.
;;
;; To use:
;;   1. Put this file somewhere on your `custom-theme-load-path',
;;      e.g. ~/.emacs.d/themes/dos-theme.el
;;   2. Add to your init file:
;;        (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;;        (load-theme 'dos t)

;;; Code:

(deftheme dos
  "A theme reminiscent of the classic MS-DOS EDIT.COM / Turbo Pascal look.")

(let* ((dos-bg           "#0000AA")  ; classic DOS navy blue
       (dos-bg-alt       "#000088")  ; slightly darker blue for panels
       (dos-fg            "#AAAAAA") ; light gray text
       (dos-fg-bright     "#FFFFFF") ; bright white text
       (dos-cyan          "#00AAAA")
       (dos-bright-cyan   "#55FFFF")
       (dos-yellow        "#FFFF55")
       (dos-bright-green  "#55FF55")
       (dos-green         "#00AA00")
       (dos-red           "#AA0000")
       (dos-bright-red    "#FF5555")
       (dos-magenta       "#AA00AA")
       (dos-bright-magenta "#FF55FF")
       (dos-gray          "#555555")
       (dos-black         "#000000")
       (dos-select-bg     "#AAAAAA") ; inverted-style selection block
       (dos-select-fg     "#0000AA")
       (dos-border        dos-fg))

  (custom-theme-set-faces
   'dos

   ;; --- Core ---
   `(default ((t (:background ,dos-bg :foreground ,dos-fg))))
   `(cursor ((t (:background ,dos-bright-cyan))))
   `(fringe ((t (:background ,dos-bg :foreground ,dos-fg))))
   `(region ((t (:background ,dos-select-bg :foreground ,dos-select-fg))))
   `(highlight ((t (:background ,dos-bg-alt :foreground ,dos-yellow))))
   `(shadow ((t (:foreground ,dos-gray))))
   `(secondary-selection ((t (:background ,dos-magenta :foreground ,dos-fg-bright))))
   `(minibuffer-prompt ((t (:foreground ,dos-yellow :weight bold))))
   `(vertical-border ((t (:foreground ,dos-border))))
   `(fill-column-indicator ((t (:foreground ,dos-bg-alt))))
   `(trailing-whitespace ((t (:background ,dos-red))))

   ;; --- Mode line: looks like the DOS Editor's gray/cyan status bar ---
   `(mode-line ((t (:background ,dos-select-bg :foreground ,dos-select-fg
                                 :box nil))))
   `(mode-line-inactive ((t (:background ,dos-gray :foreground ,dos-fg-bright
                                          :box nil))))
   `(mode-line-buffer-id ((t (:foreground ,dos-bg :weight bold))))
   `(mode-line-highlight ((t (:foreground ,dos-red))))
   `(header-line ((t (:background ,dos-select-bg :foreground ,dos-select-fg))))

   ;; --- Menus / popups: the yellow-on-blue "F10 menu" look ---
   `(tooltip ((t (:background ,dos-select-bg :foreground ,dos-select-fg))))
   `(tool-bar ((t (:background ,dos-select-bg :foreground ,dos-select-fg))))
   `(menu ((t (:background ,dos-select-bg :foreground ,dos-select-fg))))

   ;; --- Line numbers ---
   `(line-number ((t (:background ,dos-bg :foreground ,dos-gray))))
   `(line-number-current-line ((t (:background ,dos-bg :foreground ,dos-yellow
                                                :weight bold))))

   ;; --- Font lock (syntax highlighting), CGA-flavored ---
   `(font-lock-comment-face ((t (:foreground ,dos-green :slant italic))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,dos-green))))
   `(font-lock-string-face ((t (:foreground ,dos-bright-cyan))))
   `(font-lock-doc-face ((t (:foreground ,dos-cyan))))
   `(font-lock-keyword-face ((t (:foreground ,dos-yellow :weight bold))))
   `(font-lock-builtin-face ((t (:foreground ,dos-bright-magenta))))
   `(font-lock-function-name-face ((t (:foreground ,dos-fg-bright :weight bold))))
   `(font-lock-variable-name-face ((t (:foreground ,dos-bright-green))))
   `(font-lock-type-face ((t (:foreground ,dos-bright-cyan :weight bold))))
   `(font-lock-constant-face ((t (:foreground ,dos-bright-magenta))))
   `(font-lock-warning-face ((t (:foreground ,dos-fg-bright :background ,dos-red :weight bold))))
   `(font-lock-negation-char-face ((t (:foreground ,dos-bright-red))))
   `(font-lock-preprocessor-face ((t (:foreground ,dos-magenta))))
   `(font-lock-regexp-grouping-backslash ((t (:foreground ,dos-yellow))))
   `(font-lock-regexp-grouping-construct ((t (:foreground ,dos-yellow))))

   ;; --- Search / isearch ---
   `(isearch ((t (:background ,dos-yellow :foreground ,dos-bg :weight bold))))
   `(isearch-fail ((t (:background ,dos-red :foreground ,dos-fg-bright))))
   `(lazy-highlight ((t (:background ,dos-cyan :foreground ,dos-bg))))
   `(match ((t (:background ,dos-green :foreground ,dos-bg))))

   ;; --- Parens ---
   `(show-paren-match ((t (:background ,dos-yellow :foreground ,dos-bg :weight bold))))
   `(show-paren-mismatch ((t (:background ,dos-red :foreground ,dos-fg-bright :weight bold))))

   ;; --- Links / buttons ---
   `(link ((t (:foreground ,dos-bright-cyan :underline t))))
   `(link-visited ((t (:foreground ,dos-magenta :underline t))))
   `(button ((t (:foreground ,dos-bright-cyan :underline t))))

   ;; --- Errors / warnings / success ---
   `(error ((t (:foreground ,dos-bright-red :weight bold))))
   `(warning ((t (:foreground ,dos-yellow :weight bold))))
   `(success ((t (:foreground ,dos-bright-green :weight bold))))

   ;; --- Dired ---
   `(dired-directory ((t (:foreground ,dos-bright-cyan :weight bold))))
   `(dired-symlink ((t (:foreground ,dos-bright-magenta))))
   `(dired-marked ((t (:background ,dos-yellow :foreground ,dos-bg))))

   ;; --- Company / completion popups ---
   `(company-tooltip ((t (:background ,dos-select-bg :foreground ,dos-select-fg))))
   `(company-tooltip-selection ((t (:background ,dos-cyan :foreground ,dos-bg))))
   `(company-tooltip-common ((t (:foreground ,dos-red :weight bold))))
   `(company-scrollbar-bg ((t (:background ,dos-gray))))
   `(company-scrollbar-fg ((t (:background ,dos-fg-bright))))

   ;; --- Org mode ---
   `(org-level-1 ((t (:foreground ,dos-yellow :weight bold))))
   `(org-level-2 ((t (:foreground ,dos-bright-cyan :weight bold))))
   `(org-level-3 ((t (:foreground ,dos-bright-green :weight bold))))
   `(org-todo ((t (:foreground ,dos-bright-red :weight bold))))
   `(org-done ((t (:foreground ,dos-bright-green :weight bold))))
   `(org-code ((t (:foreground ,dos-bright-cyan))))
   `(org-block ((t (:background ,dos-bg-alt))))

   ;; --- Diff / magit-ish ---
   `(diff-added ((t (:foreground ,dos-bright-green))))
   `(diff-removed ((t (:foreground ,dos-bright-red))))
   `(diff-changed ((t (:foreground ,dos-yellow))))
   `(diff-header ((t (:background ,dos-bg-alt))))
   `(diff-file-header ((t (:foreground ,dos-fg-bright :weight bold))))))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'dos)

;;; dos-theme.el ends here
