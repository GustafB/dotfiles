
(load-file "~/.emacs.d/sensible-defaults.el")
(sensible-defaults/use-all-settings)
(sensible-defaults/use-all-keybindings)
(sensible-defaults/backup-to-temp-directory)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package auto-compile
  :config (auto-compile-on-load-mode))
(setq load-prefer-newer t)

(defun generate-scratch-buffer ()
  "Create and switch to a temporary scratch buffer with a random
     name."
  (interactive)
  (switch-to-buffer (make-temp-name "scratch-")))

(defun add-auto-mode (mode &rest patterns)
  "Add entries to `auto-mode-alist' to use `MODE' for all given file `PATTERNS'."
  (dolist (pattern patterns)
    (add-to-list 'auto-mode-alist (cons pattern mode))))

(defun kill-current-buffer ()
  "Kill the current buffer without prompting."
  (interactive)
  (kill-buffer (current-buffer)))

(defun iterm-goto-filedir-or-home ()
  "Go to present working dir and focus iterm"
  (interactive)
  (do-applescript
   (concat
    " tell application \"iTerm2\"\n"
    "   tell the current session of current window\n"
    (format "     write text \"cd %s\" \n"
            ;; string escaping madness for applescript
            (replace-regexp-in-string "\\\\" "\\\\\\\\"
                                      (shell-quote-argument (or default-directory "~"))))
    "   end tell\n"
    " end tell\n"
    " do shell script \"open -a iTerm\"\n"
    ))
  )
;; Opens iterm
(defun iterm-focus ()
  (interactive)
  (do-applescript
   " do shell script \"open -a iTerm\"\n"
   ))


(defun split-window-below-and-switch ()
  "Split the window horizontally, then switch to the new pane."
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))

(defun split-window-right-and-switch ()
  "Split the window vertically, then switch to the new pane."
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))

(tool-bar-mode 0)
(menu-bar-mode 0)
(when window-system
  (scroll-bar-mode -1))

;;(setq evil-want-abbrev-expand-on-insert-exit nil)
;;(evil-mode 0)
;;(add-to-list'evil-emacs-state-modes 'eshell)

(setq inhibit-startup-message t)

(setq ring-bell-function 'ignore)

(setq scroll-conservatively 100)

(when window-system
    (global-hl-line-mode))
;;  (set-face-background 'hl-line "#778184")

(use-package all-the-icons
 :ensure t)

(defun my/load-theme (frame)
  (select-frame frame)
  (load-theme 'zerodark t))
(if (daemonp)
    (add-hook 'after-make-frame-functions #'my/load-theme)
  (load-theme 'zerodark t))
;;        (use-package zerodark-theme
  ;;        :ensure t
    ;;      :config
      ;;    (load-theme 'zerodark 'no-confirm))
;;          :hook 'zerodark-setup-modeline-format)
 (use-package zerodark-theme
    :ensure t
    :config
    :hook ('my/load-theme))

(use-package rainbow-mode
  :ensure t
  :commands rainbow-mode)

(setq default-font "Menlo")
(setq default-font-size 14)
(setq current-font-size default-font-size)

(setq font-change-increment 1.1)

(defun font-code ()
  (concat default-font "-" (number-to-string current-font-size)))

(defun set-font-size ()
  "Set the font to `default-font' at `current-font-size'.
Set that for the current frame, and also make it the default for
other, future frames."
  (let ((font-code (font-code)))
    (add-to-list 'default-frame-alist (cons 'font font-code))
    (set-frame-font font-code)))

(defun reset-font-size ()
  "Change font size back to `default-font-size'."
  (interactive)
  (setq current-font-size default-font-size)
  (set-font-size))

(defun increase-font-size ()
  "Increase current font size by a factor of `font-change-increment'."
  (interactive)
  (setq current-font-size
        (ceiling (* current-font-size font-change-increment)))
  (set-font-size))

(defun decrease-font-size ()
  "Decrease current font size by a factor of `font-change-increment', down to a minimum size of 1."
  (interactive)
  (setq current-font-size
        (max 1
             (floor (/ current-font-size font-change-increment))))
  (set-font-size))

(define-key global-map (kbd "C-)") 'reset-font-size)
(define-key global-map (kbd "C-+") 'increase-font-size)
(define-key global-map (kbd "C-=") 'increase-font-size)
(define-key global-map (kbd "C-_") 'decrease-font-size)
(define-key global-map (kbd "C--") 'decrease-font-size)

(reset-font-size)

(use-package origami
        :ensure t
        :bind (:map origami-mode-map
                    ("C-c C-o" . 'origami-toggle-node)
                    ("C-c C-f" . 'origami-toggle-all-nodes)))
      (add-hook 'global-origami-mode #'origami-mode)
;;        :hook global-origami-mode)

(use-package expand-region
  :ensure t
  :commands (er/expand-region er/contract-region)
  :bind (
         ("M-=" . er/expand-region)
         ("M--" . er/contract-region)))

(use-package flycheck
  :ensure t)

(defun adjust-syntax-spellcheck-timer ()
  "Adjust how often we check for errors based on if there are any.
  This lets us fix any errors as quickly as possible, but in a
  clean buffer we're an order of magnitude laxer about checking."
  (setq flycheck-idle-change-delay
        (if flycheck-current-errors 0.5 30.0)))

;; Each buffer gets its own idle-change-delay because of the
;; buffer-sensitive adjustment above.
(make-variable-buffer-local 'flycheck-idle-change-delay)

(add-hook 'flycheck-after-syntax-check-hook
          'adjust-syntax-spellcheck-timer)

;; Remove newline checks, since they would trigger an immediate check
;; when we want the idle-change-delay to be in effect while editing.
(setq flycheck-check-syntax-automatically '(save
                                            idle-change
                                            mode-enabled))

(eval-after-load 'flycheck
  '(custom-set-variables
    '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages)))

(provide 'setup-flycheck)
(add-hook 'c-mode-common-hook #'flycheck-mode)

(use-package ivy
  :ensure t
  :diminish
  :bind (("C-x b" . ivy-switch-buffer)
         ("C-x B" . ivy-switch-buffer-other-window)
         ("M-H"   . ivy-resume))

  :bind (:map ivy-minibuffer-map
              ("<tab>" . ivy-alt-done)
              ("SPC"   . ivy-alt-done-or-space)
              ("C-d"   . ivy-done-or-delete-char)
              ("C-i"   . ivy-partial-or-done)
              ("C-r"   . ivy-previous-line-or-history)
              ("M-r"   . ivy-reverse-i-search))

  :bind (:map ivy-switch-buffer-map
              ("C-k" . ivy-switch-buffer-kill))

  :custom
  (ivy-dynamic-exhibit-delay-ms 200)
  (ivy-height 10)
  (ivy-initial-inputs-alist nil t)
  (ivy-magic-tilde nil)
  (ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
  (ivy-use-virtual-buffers t)
  (ivy-wrap t)

  :preface
  (defun ivy-done-or-delete-char ()
    (interactive)
    (call-interactively
     (if (eolp)
         #'ivy-immediate-done
       #'ivy-delete-char)))

  (defun ivy-alt-done-or-space ()
    (interactive)
    (call-interactively
     (if (= ivy--length 1)
         #'ivy-alt-done
       #'self-insert-command)))

  (defun ivy-switch-buffer-kill ()
    (interactive)
    (debug)
    (let ((bn (ivy-state-current ivy-last)))
      (when (get-buffer bn)
        (kill-buffer bn))
      (unless (buffer-live-p (ivy-state-buffer ivy-last))
        (setf (ivy-state-buffer ivy-last)
              (with-ivy-window (current-buffer))))
      (setq ivy--all-candidates (delete bn ivy--all-candidates))
      (ivy--exhibit)))

  ;; This is the value of `magit-completing-read-function', so that we see
  ;; Magit's own sorting choices.
  (defun my-ivy-completing-read (&rest args)
    (let ((ivy-sort-functions-alist '((t . nil))))
      (apply 'ivy-completing-read args)))

  :config
  (ivy-mode 1)
  (ivy-set-occur 'ivy-switch-buffer 'ivy-switch-buffer-occur))

(use-package ace-window
  :ensure t
  :init
  (progn
    (global-set-key [remap other-window] 'ace-window)
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0)))))
    ))

(use-package counsel
  :ensure t)

(use-package swiper
  :ensure try
  :bind (("C-s" . swiper)
   ("C-r" . swiper)
   ("C-c C-r" . ivy-resume)
   ("M-x" . counsel-M-x)
   ("C-x C-f" . counsel-find-file))
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (setq ivy-display-style 'fancy)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
    ))

(use-package dired
  :ensure nil
  :bind ("C-c j" . dired-two-pane)
  :bind (:map dired-mode-map
              ("j"     . dired)
              ("z"     . pop-window-configuration)
              ("e"     . ora-ediff-files)
              ("l"     . dired-up-directory)
              ("q"     . dired-up-directory)
              ("Y"     . ora-dired-rsync)
              ("M-!"   . async-shell-command)
              ("<tab>" . dired-next-window)
              ("M-G")
              ("M-s f"))
  :diminish dired-omit-mode
  :hook (dired-mode . dired-hide-details-mode)
  :preface
  (defun dired-two-pane ()
    (interactive)
    (push-window-configuration)
    (let ((here default-directory))
      (delete-other-windows)
      (dired "~/dl")
      (split-window-horizontally)
      (dired here)))

  (defun dired-next-window ()
    (interactive)
    (let ((next (car (cl-remove-if-not #'(lambda (wind)
                                           (with-current-buffer (window-buffer wind)
                                             (eq major-mode 'dired-mode)))
                                       (cdr (window-list))))))
      (when next
        (select-window next))))

  (defvar mark-files-cache (make-hash-table :test #'equal))

  (defun mark-similar-versions (name)
    (let ((pat name))
      (if (string-match "^\\(.+?\\)-[0-9._-]+$" pat)
          (setq pat (match-string 1 pat)))
      (or (gethash pat mark-files-cache)
          (ignore (puthash pat t mark-files-cache)))))

  (defun dired-mark-similar-version ()
    (interactive)
    (setq mark-files-cache (make-hash-table :test #'equal))
    (dired-mark-sexp '(mark-similar-versions name)))

  (defun ora-dired-rsync (dest)
    (interactive
     (list
      (expand-file-name
       (read-file-name "Rsync to: " (dired-dwim-target-directory)))))
    (let ((files (dired-get-marked-files
                  nil current-prefix-arg))
          (tmtxt/rsync-command "rsync -aP "))
      (dolist (file files)
        (setq tmtxt/rsync-command
              (concat tmtxt/rsync-command
                      (shell-quote-argument file)
                      " ")))
      (setq tmtxt/rsync-command
            (concat tmtxt/rsync-command
                    (shell-quote-argument dest)))
      (async-shell-command tmtxt/rsync-command "*rsync*")
      (other-window 1)))

  (defun ora-ediff-files ()
    (interactive)
    (let ((files (dired-get-marked-files))
          (wnd (current-window-configuration)))
      (if (<= (length files) 2)
          (let ((file1 (car files))
                (file2 (if (cdr files)
                           (cadr files)
                         (read-file-name
                          "file: "
                          (dired-dwim-target-directory)))))
            (if (file-newer-than-file-p file1 file2)
                (ediff-files file2 file1)
              (ediff-files file1 file2))
            (add-hook 'ediff-after-quit-hook-internal
                      `(lambda ()
                         (setq ediff-after-quit-hook-internal nil)
                         (set-window-configuration ,wnd))))
        (error "no more than 2 files should be marked"))))

  :config
  (defvar dired-omit-regexp-orig (symbol-function 'dired-omit-regexp))

  ;; Omit files that Git would ignore
  (defun dired-omit-regexp ()
    (let ((file (expand-file-name ".git"))
          parent-dir)
      (while (and (not (file-exists-p file))
                  (progn
                    (setq parent-dir
                          (file-name-directory
                           (directory-file-name
                            (file-name-directory file))))
                    ;; Give up if we are already at the root dir.
                    (not (string= (file-name-directory file)
                                  parent-dir))))
        ;; Move up to the parent dir and try again.
        (setq file (expand-file-name ".git" parent-dir)))
      ;; If we found a change log in a parent, use that.
      (if (file-exists-p file)
          (let ((regexp (funcall dired-omit-regexp-orig))
                (omitted-files
                 (shell-command-to-string "git clean -d -x -n")))
            (if (= 0 (length omitted-files))
                regexp
              (concat
               regexp
               (if (> (length regexp) 0)
                   "\\|" "")
               "\\("
               (mapconcat
                #'(lambda (str)
                    (concat
                     "^"
                     (regexp-quote
                      (substring str 13
                                 (if (= ?/ (aref str (1- (length str))))
                                     (1- (length str))
                                   nil)))
                     "$"))
                (split-string omitted-files "\n" t)
                "\\|")
               "\\)")))
        (funcall dired-omit-regexp-orig)))))

(use-package dired-toggle
  :ensure nil
  :bind ("C-c ~" . dired-toggle)
  :preface
  (defun my-dired-toggle-mode-hook ()
    (interactive)
    (visual-line-mode 1)
    (setq-local visual-line-fringe-indicators '(nil right-curly-arrow))
    (setq-local word-wrap nil))
  :hook (dired-toggle-mode . my-dired-toggle-mode-hook))

(use-package company
  :ensure t
  :init (progn
          (add-hook 'prog-mode-hook 'company-mode))
  :config (progn
            (setq company-idle-delay 0.5)
            (setq company-tooltip-limit 10)
            (setq company-minimum-prefix-length 2)
            (setq company-tooltip-flip-when-above t)))

(use-package company-dabbrev
  :ensure nil
  :config (progn
            (setq company-dabbrev-ignore-case t)
            (setq company-dabbrev-downcase nil)))
(add-hook 'after-init-hook 'global-company-mode)

(use-package google-this
  :ensure t
  :bind-keymap ("C-c /" . google-this-mode-submap)
  :bind* ("M-SPC" . google-this-search)
  :bind (:map google-this-mode-map
              ("/" . google-this-search)))

(use-package indent-shift
  :ensure nil
  :bind (("C-c <" . indent-shift-left)
         ("C-c >" . indent-shift-right)))

(use-package drag-stuff
 :ensure t)
(drag-stuff-global-mode 1)
(drag-stuff-define-keys)

(use-package multiple-cursors
  :ensure t)
;; Edit all selected lines
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-M-g") 'mc/mark-all-like-this)

(use-package ido
  :ensure t)
(use-package flx-ido
  :ensure t)
(use-package ido-vertical-mode
  :ensure t)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(flx-ido-mode 1) ; better/faster matching
(setq ido-create-new-buffer 'always) ; don't confirm to create new buffers
(ido-vertical-mode 1)
(setq ido-vertical-define-keys 'C-n-and-C-p-only)

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
         ("C-x G" . magit-status-with-prefix))
  :bind (:map magit-mode-map
              ("U" . magit-unstage-all)
              ("M-h") ("M-s") ("M-m") ("M-w"))
  :bind (:map magit-file-section-map ("<C-return>"))
  :bind (:map magit-hunk-section-map ("<C-return>"))
  :preface
  (defun magit-monitor (&optional no-display)
    "Start git-monitor in the current directory."
    (interactive)
    (let* ((path (file-truename
                  (directory-file-name
                   (expand-file-name default-directory))))
           (name (format "*git-monitor: %s*"
                         (file-name-nondirectory path))))
      (unless (and (get-buffer name)
                   (with-current-buffer (get-buffer name)
                     (string= path (directory-file-name default-directory))))
        (with-current-buffer (get-buffer-create name)
          (cd path)
          (ignore-errors
            (start-process "*git-monitor*" (current-buffer)
                           "git-monitor" "-d" path))))))

  (defun magit-status-with-prefix ()
    (interactive)
    (let ((current-prefix-arg '(4)))
      (call-interactively 'magit-status)))

  :hook (magit-mode . hl-line-mode)
  :config
  (use-package magit-commit
    :config
    (use-package git-commit))

  (use-package magit-files
    :config
    (global-magit-file-mode))

  (add-hook 'magit-status-mode-hook #'(lambda () (magit-monitor t)))

  (eval-after-load 'magit-remote
    '(progn
       (magit-define-popup-action 'magit-fetch-popup
         ?f 'magit-get-remote #'magit-fetch-from-upstream ?u t)
       (magit-define-popup-action 'magit-pull-popup
         ?F 'magit-get-upstream-branch #'magit-pull-from-upstream ?u t)
       (magit-define-popup-action 'magit-push-popup
         ?P 'magit--push-current-to-upstream-desc
         #'magit-push-current-to-upstream ?u t))))

(use-package magit-popup
  :defer t)

(use-package magit-imerge
  ;; jww (2017-12-10): Need to configure.
  :disabled t
  :after magit)

(use-package magithub
  :disabled t
  :after magit
  :config
  (magithub-feature-autoinject t)

  (require 'auth-source-pass)
  (defvar my-ghub-token-cache nil)

  (advice-add
   'ghub--token :around
   #'(lambda (orig-func host username package &optional nocreate forge)
       (or my-ghub-token-cache
           (setq my-ghub-token-cache
                 (funcall orig-func host username package nocreate forge))))))

(use-package magithub-completion
  :commands magithub-completion-enable)

(use-package projectile
;;    :defer 5
    :diminish
    :bind* ("C-c TAB" . projectile-find-other-file)
    :bind-keymap ("C-c p" . projectile-command-map)
    :config
    (projectile-global-mode))

(use-package helm
  :defer t
  :bind (:map helm-map
              ("<tab>" . helm-execute-persistent-action)
              ("C-i"   . helm-execute-persistent-action)
              ("C-z"   . helm-select-action)
              ("A-v"   . helm-previous-page))
  :config
  (helm-autoresize-mode 1))
(global-set-key (kbd "C-x b") 'helm-buffers-list)

(use-package web-mode
  :ensure t)
(add-hook 'web-mode-hook
          (lambda ()
            (rainbow-mode)
            (setq web-mode-markup-indent-offset 2)))
(add-auto-mode
 'web-mode
 "\\.blade$"
 "\\.phtml$"
 "\\.erb$"
 "\\.html$"
 "\\.php$"
 "\\.rhtml$")

(use-package js2-mode
    :ensure t
    :config
    (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)))
(add-hook 'j2-mode-hook (lambda () (setq js2-basic-offset 2)))

(use-package json-mode
  :ensure t)

(use-package js2-refactor
  :ensure t)
(use-package xref-js2
  :ensure t)
(setq js2-highlight-level 3)
(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-r")
(define-key js2-mode-map (kbd "C-k") #'js2r-kill)
(add-hook 'js2-mode-hook
  (lambda ()
    (linum-mode 1)))

;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
;; unbind it.
(define-key js-mode-map (kbd "M-.") nil)

(add-hook 'js2-mode-hook (lambda ()
  (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

(use-package markdown-mode
  :ensure t
  :mode (("\\`README\\.md\\'" . gfm-mode)
         ("\\.md\\'"          . markdown-mode)
         ("\\.markdown\\'"    . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package markdown-preview-mode
  :after markdown-mode
  :config
  (setq markdown-preview-stylesheets
        (list (concat "https://github.com/dmarcotte/github-markdown-preview/"
                      "blob/master/data/css/github.css"))))

(use-package company-restclient
  :ensure t
  :after (company restclient))

(use-package restclient
  :ensure t
  :mode ("\\.rest\\'" . restclient-mode))

(use-package css-mode
  :ensure t
  :config
  :hook rainbow-mode
  :config
  (setq css-indent-offset 2))

(use-package scss-mode
  :ensure t
  :config
  (setq scss-compile-at-save nil))

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda() (org-bullets-mode 1))))

;; Set default path
(setq org-journal-dir (concat "~/Dropbox/org/journal/" (format-time-string "%Y/%m/")))
;; Define naming convention
(setq org-journal-file-format "%Y-%m-%d.org")
;; Carry-over incomplete todos
(setq org-journal-carryover-items "TODO=\"TODO\"|TODO=\"STARTED\"")

(use-package org-journal
  :ensure t)

(setq org-ellipsis "⤵")
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-src-window-setup 'current-window)

(setq org-directory "~/Dropbox/org")

(defun org-file-path (filename)
  "Return the absolute address of an org file, given its relative name."
  (concat (file-name-as-directory org-directory) filename))

;;(setq org-inbox-file "~/Dropbox/inbox.org")
(setq org-index-file (org-file-path "index.org"))
(setq org-archive-location
      (concat (org-file-path "archive.org") "::* From %s"))

(setq org-agenda-files (list org-index-file))

(defun open-index-file ()
  "Open the master org TODO list."
  (interactive)
  (find-file org-index-file)
  (flycheck-mode -1)
  (end-of-buffer))

(global-set-key (kbd "C-c i") 'open-index-file)

(defun mark-done-and-archive ()
  "Mark the state of an org-mode item as DONE and archive it."
  (interactive)
  (org-todo 'done)
  (org-archive-subtree))

(define-key org-mode-map (kbd "C-c C-x C-s") 'mark-done-and-archive)

(setq org-log-done 'time)

(global-set-key (kbd "C-x 2") 'split-window-below-and-switch)
(global-set-key (kbd "C-x 3") 'split-window-right-and-switch)
(global-set-key (kbd "C-x C-t") 'iterm-goto-filedir-or-home)
(global-set-key (kbd "C-x k") 'kill-current-buffer)

(setq-default indent-tabs-mode nil)

(setq-default tab-width 2)

(setq global-hl-line-mode +1)

(add-to-list 'exec-path "/usr/local/bin")
(use-package exec-path-from-shell
  :ensure t
  :config (when (memq window-system '(mac ns))
            (exec-path-from-shell-initialize)))

;; I want an easy command for opening new shells:
(defun new-shell (name)
  "Opens a new shell buffer with the given name in
asterisks (*name*) in the current directory and changes the
prompt to 'name>'."
  (interactive "sName: ")
  (pop-to-buffer (concat "*" name "*"))
  (unless (eq major-mode 'shell-mode)
    (shell (current-buffer))
    (sleep-for 0 200)
    (delete-region (point-min) (point-max))
    (comint-simple-send (get-buffer-process (current-buffer))
                        (concat "export PS1=\"\033[33m" name "\033[0m:\033[35m\\W\033[0m>\""))))
(global-set-key (kbd "C-c s") 'new-shell)

;; Remove case sensitivity for auto-completion
(setq pcomplete-ignore-case t)

;; Load ansi colors
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(setq ansi-color-names-vector ["white" "orange red" "green" "yellow" "pale blue" "magenta" "cyan" "tan"])

(find-file "~/Dropbox/org/index.org")
