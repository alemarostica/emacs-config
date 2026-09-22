;;; tui-theme.el --- A theme that looks like a classic ncurses dialog TUI -*- lexical-binding: t; -*-

;; Author: You
;; Version: 1.0
;; Package-Requires: ((emacs "24.1"))
;; Keywords: faces, theme

;;; Commentary:

;; Recreates the look of classic ncurses TUI apps built with `dialog` /
;; `whiptail` / Turbo Vision (think Debian installer, `nmtui`, old BIOS
;; setup screens): a blue dialog box floating on a gray desktop, white
;; title text, and a dark drop-shadow offset beneath every panel.
;;
;; To use:
;;   1. Put this file somewhere on your `custom-theme-load-path',
;;      e.g. ~/.emacs.d/themes/tui-theme.el
;;   2. Add to your init file:
;;        (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;;        (load-theme 'tui t)

;;; Code:

(deftheme tui
  "A theme reminiscent of classic ncurses dialog/whiptail TUI apps.")

(let* ((tui-desktop      "#AAAAAA")  ; the gray "desktop" behind dialogs
       (tui-box-bg       "#0000AA")  ; the classic dialog blue
       (tui-box-bg-alt   "#0000CC")  ; slightly lighter blue panel
       (tui-fg           "#FFFFFF")  ; dialog body text, bright white
       (tui-fg-dim       "#AAAAAA")  ; secondary/label text
       (tui-title        "#FFFF55")  ; yellow dialog titles
       (tui-highlight-bg "#AAAAAA")  ; selected menu item / button (gray)
       (tui-highlight-fg "#000000")  ; black text on selected item
       (tui-button-bg    "#AAAAAA")
       (tui-button-fg    "#000000")
       (tui-accent-cyan  "#55FFFF")
       (tui-accent-green "#55FF55")
       (tui-accent-red   "#FF5555")
       (tui-shadow       "#000000")  ; drop-shadow black
       (tui-shadow-dim   "#555555")  ; softer shadow gray
       (tui-border       "#FFFFFF")
       (tui-black        "#000000"))

  (custom-theme-set-faces
   'tui

   ;; --- Core: the buffer is the dialog box itself ---
   `(default ((t (:background ,tui-box-bg :foreground ,tui-fg))))
   `(cursor ((t (:background ,tui-title))))
   `(fringe ((t (:background ,tui-desktop :foreground ,tui-shadow))))
   `(region ((t (:background ,tui-highlight-bg :foreground ,tui-highlight-fg))))
   `(highlight ((t (:background ,tui-highlight-bg :foreground ,tui-highlight-fg))))
   `(shadow ((t (:foreground ,tui-shadow-dim))))
   `(secondary-selection ((t (:background ,tui-box-bg-alt :foreground ,tui-fg))))
   `(minibuffer-prompt ((t (:foreground ,tui-title :weight bold))))
   `(vertical-border ((t (:foreground ,tui-shadow :background ,tui-desktop))))
   `(fill-column-indicator ((t (:foreground ,tui-box-bg-alt))))
   `(trailing-whitespace ((t (:background ,tui-accent-red))))

   ;; --- Mode line: reads like the dialog's title bar / button row ---
   `(mode-line ((t (:background ,tui-desktop :foreground ,tui-black
                                 :box (:line-width 1 :color ,tui-shadow :style released-button)))))
   `(mode-line-inactive ((t (:background ,tui-shadow-dim :foreground ,tui-desktop
                                          :box (:line-width 1 :color ,tui-shadow)))))
   `(mode-line-buffer-id ((t (:foreground ,tui-box-bg :weight bold))))
   `(mode-line-highlight ((t (:foreground ,tui-accent-red))))
   `(header-line ((t (:background ,tui-box-bg :foreground ,tui-title :weight bold))))

   ;; --- Menus / popups: gray highlighted item, like a dialog menu list ---
   `(tooltip ((t (:background ,tui-desktop :foreground ,tui-black))))
   `(tool-bar ((t (:background ,tui-desktop :foreground ,tui-black))))
   `(menu ((t (:background ,tui-box-bg :foreground ,tui-fg))))

   ;; --- "Shadow" effect: window dividers/scroll bars read as drop shadow ---
   `(window-divider ((t (:foreground ,tui-shadow))))
   `(window-divider-first-pixel ((t (:foreground ,tui-shadow))))
   `(window-divider-last-pixel ((t (:foreground ,tui-shadow))))
   `(scroll-bar ((t (:background ,tui-shadow-dim :foreground ,tui-desktop))))
   `(internal-border ((t (:background ,tui-shadow))))

   ;; --- Line numbers ---
   `(line-number ((t (:background ,tui-box-bg :foreground ,tui-box-bg-alt))))
   `(line-number-current-line ((t (:background ,tui-box-bg :foreground ,tui-title
                                                :weight bold))))

   ;; --- Font lock (syntax highlighting) ---
   `(font-lock-comment-face ((t (:foreground ,tui-accent-cyan :slant italic))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,tui-accent-cyan))))
   `(font-lock-string-face ((t (:foreground ,tui-accent-green))))
   `(font-lock-doc-face ((t (:foreground ,tui-accent-green))))
   `(font-lock-keyword-face ((t (:foreground ,tui-title :weight bold))))
   `(font-lock-builtin-face ((t (:foreground ,tui-accent-cyan :weight bold))))
   `(font-lock-function-name-face ((t (:foreground ,tui-fg :weight bold))))
   `(font-lock-variable-name-face ((t (:foreground ,tui-fg-dim))))
   `(font-lock-type-face ((t (:foreground ,tui-accent-cyan :weight bold))))
   `(font-lock-constant-face ((t (:foreground ,tui-accent-green :weight bold))))
   `(font-lock-warning-face ((t (:foreground ,tui-fg :background ,tui-accent-red :weight bold))))
   `(font-lock-negation-char-face ((t (:foreground ,tui-accent-red))))
   `(font-lock-preprocessor-face ((t (:foreground ,tui-title))))
   `(font-lock-regexp-grouping-backslash ((t (:foreground ,tui-title))))
   `(font-lock-regexp-grouping-construct ((t (:foreground ,tui-title))))

   ;; --- Search / isearch ---
   `(isearch ((t (:background ,tui-title :foreground ,tui-black :weight bold))))
   `(isearch-fail ((t (:background ,tui-accent-red :foreground ,tui-fg))))
   `(lazy-highlight ((t (:background ,tui-accent-cyan :foreground ,tui-black))))
   `(match ((t (:background ,tui-accent-green :foreground ,tui-black))))

   ;; --- Parens ---
   `(show-paren-match ((t (:background ,tui-title :foreground ,tui-black :weight bold))))
   `(show-paren-mismatch ((t (:background ,tui-accent-red :foreground ,tui-fg :weight bold))))

   ;; --- Links / buttons: like the [ OK ] / [ Cancel ] dialog buttons ---
   `(link ((t (:foreground ,tui-accent-cyan :underline t))))
   `(link-visited ((t (:foreground ,tui-fg-dim :underline t))))
   `(button ((t (:background ,tui-button-bg :foreground ,tui-button-fg
                             :box (:line-width 1 :style released-button)))))

   ;; --- Errors / warnings / success ---
   `(error ((t (:foreground ,tui-accent-red :weight bold))))
   `(warning ((t (:foreground ,tui-title :weight bold))))
   `(success ((t (:foreground ,tui-accent-green :weight bold))))

   ;; --- Dired ---
   `(dired-directory ((t (:foreground ,tui-accent-cyan :weight bold))))
   `(dired-symlink ((t (:foreground ,tui-fg-dim))))
   `(dired-marked ((t (:background ,tui-title :foreground ,tui-black))))

   ;; --- Company / completion popups (menu-list look with gray highlight) ---
   `(company-tooltip ((t (:background ,tui-box-bg-alt :foreground ,tui-fg))))
   `(company-tooltip-selection ((t (:background ,tui-highlight-bg :foreground ,tui-highlight-fg))))
   `(company-tooltip-common ((t (:foreground ,tui-accent-red :weight bold))))
   `(company-scrollbar-bg ((t (:background ,tui-shadow-dim))))
   `(company-scrollbar-fg ((t (:background ,tui-desktop))))

   ;; --- Org mode ---
   `(org-level-1 ((t (:foreground ,tui-title :weight bold))))
   `(org-level-2 ((t (:foreground ,tui-accent-cyan :weight bold))))
   `(org-level-3 ((t (:foreground ,tui-accent-green :weight bold))))
   `(org-todo ((t (:foreground ,tui-accent-red :weight bold))))
   `(org-done ((t (:foreground ,tui-accent-green :weight bold))))
   `(org-code ((t (:foreground ,tui-accent-cyan))))
   `(org-block ((t (:background ,tui-box-bg-alt))))

   ;; --- Diff / magit-ish ---
   `(diff-added ((t (:foreground ,tui-accent-green))))
   `(diff-removed ((t (:foreground ,tui-accent-red))))
   `(diff-changed ((t (:foreground ,tui-title))))
   `(diff-header ((t (:background ,tui-box-bg-alt))))
   `(diff-file-header ((t (:foreground ,tui-fg :weight bold))))))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'tui)

;;; tui-theme.el ends here
