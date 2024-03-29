(when (not (string= system-type "darwin"))
  (add-to-list 'exec-path "/home/cafebabe/.local/bin"))

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s seconds with %d garbage collections."
                     (emacs-init-time "%.2f")
                     gcs-done)))

(load-file "~/.emacs.d/sensible-defaults.el")
(sensible-defaults/use-all-settings)
(sensible-defaults/use-all-keybindings)
(sensible-defaults/backup-to-temp-directory)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("org" . "https://orgmode.org/elpa") t)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(column-number-mode)
(global-display-line-numbers-mode t)

(use-package ivy
  :ensure t
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package diminish)

(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 10)
  (setq doom-modeline-bar-width 6)
  (setq doom-modeline-lsp t)
  (setq doom-modeline-github t)
  (setq doom-modeline-irc t)
  (setq doom-modeline-minor-modes nil)
  (setq doom-modeline-persp-name nil)
  (setq doom-modeline-evil-state-icon nil)
  (setq doom-modeline-unicode-fallback nil)
  (setq doom-modeline-buffer-file-name-style 'truncate-except-project)
  (setq doom-modeline-major-mode-icon nil)
  :custom ((doom-modeline-height 1))
  :custom-face
  (mode-line ((t (:height 0.95))))
  (mode-line-inactive ((t (:height 0.95)))))

(use-package doom-themes
  :ensure t
  :init
  (load-theme 'doom-palenight t)
  (doom-themes-visual-bell-config))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
(show-paren-mode 1)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package drag-stuff
  :ensure t
  :config
  (drag-stuff-global-mode 1)
  (drag-stuff-define-keys))

(defun gb/generate-scratch-buffer ()
  "Create and switch to a temporary scratch buffer with a random
       name."
  (interactive)
  (switch-to-buffer (make-temp-name "scratch-")))
(define-key global-map (kbd "C-c g") 'generate-scratch-buffer)

(defun gb/kill-current-buffer ()
  "Kill the current buffer without prompting."
  (interactive)
  (kill-buffer (current-buffer)))

(defun gb/iterm-goto-filedir-or-home ()
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
(defun gb/iterm-focus ()
  (interactive)
  (do-applescript
   " do shell script \"open -a iTerm\"\n"
   ))


(defun gb/split-window-below-and-switch ()
  "Split the window horizontally, then switch to the new pane."
  (interactive)
  (split-window-below)
  (balance-windows)
  (gb/toggle-normal)
  (other-window 1))

(defun gb/split-window-right-and-switch ()
  "Split the window vertically, then switch to the new pane."
  (interactive)
  (split-window-right)
  (balance-windows)
  (gb/toggle-normal)
  (other-window 1))

(defun gb/toggle-normal (&optional arg)
  (evil-normal-state))

(defun gb/other-window ()
  (interactive)
  (ace-select-window)
  (gb/toggle-normal))

(defun gb/prev-window ()
  (interactive)
  (other-window -1)
  (gb/toggle-normal))

(defun gb/next-window ()
  (interactive)
  (other-window 1)

(defun gb/toggle-normal (&optional arg)
  (evil-normal-state))

(defun gb/other-window ()
  (interactive)
  (ace-select-window)
  (gb/toggle-normal))

(defun gb/prev-window ()
  (interactive)
  (other-window -1)
  (gb/toggle-normal))

(defun gb/next-window ()
  (interactive)
  (other-window 1)
  (gb/toggle-normal))

(global-set-key (kbd "s-]") #'gb/next-window)
(global-set-key (kbd "s-[") #'gb/prev-window)
(global-set-key (kbd "C-x o") #'gb/other-window)(gb/toggle-normal))

(global-set-key (kbd "s-]") #'gb/next-window)
(global-set-key (kbd "s-[") #'gb/prev-window)
(global-set-key (kbd "C-x o") #'gb/other-window)

(global-set-key (kbd "C-x 2") 'gb/split-window-below-and-switch)
(global-set-key (kbd "C-x 3") 'gb/split-window-right-and-switch)
(global-set-key (kbd "C-x C-t") 'gb/iterm-goto-filedir-or-home)
(global-set-key (kbd "C-x k") 'gb/kill-current-buffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-c g") 'gb/generate-scratch-buffer)

(setq-default indent-tabs-mode nil)
(setq vc-follow-symlinks t)
(setq-default tab-width 2)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode -1)
(setq inhibit-startup-message t)
(setq ring-bell-function 'ignore)
(setq scroll-conservatively 100)
(progn (global-hl-line-mode)
    (set-face-background 'hl-line "#2e3544"))
(global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
            term-mode-hook
            shell-mode-hook
            treemacs-mode-hook
            eshell-mode-hook))
(add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq default-font "JetBrains Mono")
(setq default-font-size 9)
(setq current-font-size default-font-size)

(setq font-change-increment 1.1)

(defun font-code ()
(concat default-font "-" (number-to-string current-font-size)))

(defun gb/set-font-size ()
  "Set the font to `default-font' at `current-font-size'.
Set that for the current frame, and also make it the default for
other, future frames."
  (let ((font-code (font-code)))
    (add-to-list 'default-frame-alist (cons 'font font-code))
    (set-frame-font font-code)))

(defun gb/reset-font-size ()
  "Change font size back to `default-font-size'."
  (interactive)
  (setq current-font-size default-font-size)
  (gb/set-font-size))

(defun gb/increase-font-size ()
  "Gb/Increase current font size by a factor of `font-change-increment'."
  (interactive)
  (setq current-font-size
        (ceiling (* current-font-size font-change-increment)))
  (gb/set-font-size))

(defun gb/decrease-font-size ()
  "Gb/Decrease current font size by a factor of `font-change-increment', down to a minimum size of 1."
  (interactive)
  (setq current-font-size
        (max 1
             (floor (/ current-font-size font-change-increment))))
  (gb/set-font-size))

(define-key global-map (kbd "C-)") 'gb/reset-font-size)
(define-key global-map (kbd "C-+") 'gb/increase-font-size)
(define-key global-map (kbd "C-=") 'gb/increase-font-size)
(define-key global-map (kbd "C-_") 'gb/decrease-font-size)
(define-key global-map (kbd "C--") 'gb/decrease-font-size)

(gb/reset-font-size)

(use-package no-littering)
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

;; Change the user-emacs-directory to keep unwanted things out of ~/.emacs.d
(setq user-emacs-directory (expand-file-name "~/.cache/emacs/")
      url-history-file (expand-file-name "url/history" user-emacs-directory))

;; Keep customization settings in a temporary file (thanks Ambrevar!)
(setq custom-file
      (if (boundp 'server-socket-dir)
          (expand-file-name "custom.el" server-socket-dir)
        (expand-file-name (format "emacs-custom-%s.el" (user-uid)) temporary-file-directory)))
(load custom-file t)

(use-package evil
  :init
    (setq evil-want-abbrev-expand-on-insert-exit nil
          evil-want-keybinding nil)
    (setq evil-want-integration t)
    (setq evil-want-keybinding nil)
    (setq evil-want-C-u-scroll t)
    (setq evil-want-C-i-jump nil)
  :config
  (add-hook 'after-save-hook #'evil-normal-state)
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
    ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package evil-org
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda () (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package evil-nerd-commenter
  :bind ("M-;" . evilnc-comment-or-uncomment-lines))

(add-hook 'c++-mode-hook (lambda ()
                           (push '(?< . ("< " . " >")) evil-surround-pairs-alist)))

;; (evil-set-undo-system 'undo-tree)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package general
  :config
  (general-create-definer gb/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (gb/leader-keys
    "c"  '(:ignore t :which-key "compilation")
    "cc" '(compile :which-key "compile project")
    "e"  '(:ignore t :which-key "emacs commands")
    "ei" '(package-install :which-key "package-install")
    "el" '(list-packages :which-key "list-packages")
    "eu" '(gb/package-upgrade-all :which-key "upgrade all packages")
    "ec" '(tramp-cleanup-all-connections :which-key "tramp cleanup connections")
    "ev" '(set-variable :which-key "set variable")
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(gb/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (setq projectile-switch-project-action #'projectile-dired)
  :config
  (projectile-global-mode))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  :bind ("C-x g" . magit-status))

;; (use-package forge)

;; (use-package evil-magit
  ;; :after magit)

(defun gb/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . gb/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t)
  (add-hook 'lsp-mode-hook #'lsp-headerline-breadcrumb-mode)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-clients-clangd-args '(
                                  ;; If set to true, code completion will include index symbols that are not defined in the scopes
                                  ;; (e.g. namespaces) visible from the code completion point. Such completions can insert scope qualifiers
                                  "--all-scopes-completion"
                                  ;; Index project code in the background and persist index on disk.
                                  "--background-index"
                                  ;; Enable clang-tidy diagnostics
                                  "--clang-tidy"
                                  ;; Whether the clang-parser is used for code-completion
                                  ;;   Use text-based completion if the parser is not ready (auto)
                                  "--completion-parse=auto"
                                  ;; Granularity of code completion suggestions
                                  ;;   One completion item for each semantically distinct completion, with full type information (detailed)
                                  "--completion-style=detailed"
                                  ;; clang-format style to apply by default when no .clang-format file is found
                                  "--fallback-style=Chromium"
                                  ;; When disabled, completions contain only parentheses for function calls.
                                  ;; When enabled, completions also contain placeholders for method parameters
                                  "--function-arg-placeholders"
                                  ;; Add #include directives when accepting code completions
                                  ;;   Include what you use. Insert the owning header for top-level symbols, unless the
                                  ;;   header is already directly included or the symbol is forward-declared
                                  "--header-insertion=iwyu"
                                  ;; Prepend a circular dot or space before the completion label, depending on whether an include line will be inserted or not
                                  "--header-insertion-decorators"
                                  ;; Enable index-based features. By default, clangd maintains an index built from symbols in opened files.
                                  ;; Global index support needs to enabled separatedly
                                  "--index"
                                  ;; Attempts to fix diagnostic errors caused by missing includes using index
                                  "--suggest-missing-includes"
                                  ;; Number of async workers used by clangd. Background index also uses this many workers.
                                  "-j=4"
                                  )))
(use-package ccls
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))

(gb/leader-keys
  "tl" '(lsp-headerline-breadcrumb-mode :which-key "toggle lsp-headerline")
  "cf" '(lsp-format-buffer :which-key "lsp-format buffer")
  "cl" '(lsp-find-definition :which-key "lsp find definition")
  "ck" '(lsp-find-references :which-key "lsp find references")
  "c;" '(lsp-ui-peek-find-references :which-key "lsp peek references"))

(use-package lsp-ui
  :after lsp-mode
  :custom
  (lsp-ui-doc-show-with-cursor nil)
  (lsp-ui-doc-show-with-mouse nil)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-sideline-delay 0.5)
  (lsp-ui-peek-always-show t)
  (lsp-ui-peek-fontify 'always)
  :custom-face
  (lsp-ui-peek-highlight ((t (:inherit nil :background nil :foreground nil :weight semi-bold :box (:line-width -1)))))
  :bind
  ( :map lsp-ui-mode-map
    ([remap xref-find-references] . lsp-ui-peek-find-references)
    ("C-M-l" . lsp-ui-peek-find-definitions)
    ("C-c C-d" . lsp-ui-doc-show))
  :config
    ;;;; LSP UI posframe ;;;;
  (defun lsp-ui-peek--peek-display (src1 src2)
    (-let* ((win-width (frame-width))
            (lsp-ui-peek-list-width (/ (frame-width) 2))
            (string (-some--> (-zip-fill "" src1 src2)
                      (--map (lsp-ui-peek--adjust win-width it) it)
                      (-map-indexed 'lsp-ui-peek--make-line it)
                      (-concat it (lsp-ui-peek--make-footer))))
            )
      (setq lsp-ui-peek--buffer (get-buffer-create " *lsp-peek--buffer*"))
      (posframe-show lsp-ui-peek--buffer
                     :string (mapconcat 'identity string "")
                     :min-width (frame-width)
                     :poshandler 'posframe-poshandler-frame-center)))

  (defun lsp-ui-peek--peek-destroy ()
    (when (bufferp lsp-ui-peek--buffer)
      (posframe-delete lsp-ui-peek--buffer))
    (setq lsp-ui-peek--buffer nil
          lsp-ui-peek--last-xref nil)
    (set-window-start (get-buffer-window) lsp-ui-peek--win-start))

  (advice-add 'lsp-ui-peek--peek-new :override 'lsp-ui-peek--peek-display)
  (advice-add 'lsp-ui-peek--peek-hide :override 'lsp-ui-peek--peek-destroy)
    ;;;; LSP UI posframe ;;;;
  )
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))
(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package treemacs)

(use-package lsp-treemacs
  :after (lsp treemacs))

(use-package lsp-ivy
  :after lsp)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.3))

(use-package company-box
  :after (company)
  :hook (company-mode . company-box-mode))

(use-package company-c-headers
  :after (company)
  :config
    (add-to-list 'company-backends 'company-c-headers)
    (add-to-list 'company-c-headers-path-system "/usr/local/include/"))

(use-package company-dabbrev
  :ensure nil
  :after (company)
  :config (progn
    (setq company-dabbrev-ignore-case t)
    (setq company-dabbrev-downcase nil)))
    (add-hook 'after-init-hook 'global-company-mode)

(use-package avy
  :config
  (global-set-key (kbd "s-r") 'avy-goto-char-timer))


(defun gb/pop-local-mark-ring ()
  (interactive)
  (set-mark-command t))

(defun gb/unpop-to-mark-command ()
  "Unpop off mark ring. Does nothing if mark ring is empty."
  (interactive)
      (when mark-ring
        (setq mark-ring (cons (copy-marker (mark-marker)) mark-ring))
        (set-marker (mark-marker) (car (last mark-ring)) (current-buffer))
        (when (null (mark t)) (ding))
        (setq mark-ring (nbutlast mark-ring))
        (goto-char (marker-position (car (last mark-ring))))))

(global-set-key (kbd "s-,") 'gb/pop-local-mark-ring)
(global-set-key (kbd "s-.") 'gb/unpop-to-mark-command)

(global-set-key (kbd "s-<") 'previous-buffer)
(global-set-key (kbd "s->") 'next-buffer)

(use-package term
  :ensure t
  :config
  (setq explicit-shell-file-name "zsh") ;; Change this to zsh, etc
  ;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

  ;; Match the default Bash shell prompt.  Update this if you have a custom prompt
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package vterm
  :commands vterm
  :config
  ;; (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
  (setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))

(gb/leader-keys
  "ct" '(vterm :which-key "open vterm"))

(when (eq system-type 'windows-nt)
  (setq explicit-shell-file-name "powershell.exe")
  (setq explicit-powershell.exe-args '()))

(defun gb/configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Bind some useful keys for evil-mode
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt)

(use-package eshell
  :hook (eshell-first-time-mode . gb/configure-eshell)
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "vim")))

  (eshell-git-prompt-use-theme 'powerline))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (when (string= system-type "darwin")
    (setq dired-use-ls-dired t
          insert-directory-program "gls"))
  (setq dired-clean-up-buffers-too t)
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'top)
  ;; (setq insert-directory-program "gls" dired-use-ls-dired t)
  (setq dired-listing-switches "-al --group-directories-first")
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-single)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :config
  ;; Doesn't work as expected!
  ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

(setq version-control t     ;; Use version numbers for backups.
    kept-new-versions 10  ;; Number of newest versions to keep.
    kept-old-versions 0   ;; Number of oldest versions to keep.
    delete-old-versions t ;; Don't ask to delete excess backup versions.
    backup-by-copying t)  ;; Copy all files, don't rename them.
(setq vc-make-backup-files t)
;; Default and per-save backups go here:
(setq backup-directory-alist '(("" . "~/.emacs.d/backup/per-save")))

(defun force-backup-of-buffer ()
;; Make a special "per session" backup at the first save of each
;; emacs session.
(when (not buffer-backed-up)
    ;; Override the default parameters for per-session backups.
    (let ((backup-directory-alist '(("" . "~/.emacs.d/backup/per-session")))
        (kept-new-versions 3))
    (backup-buffer)))
;; Make a "per save" backup on each save.  The first save results in
;; both a per-session and a per-save backup, to keep the numbering
;; of per-save backups consistent.
(let ((buffer-backed-up nil))
    (backup-buffer)))

(add-hook 'before-save-hook  'force-backup-of-buffer)

(defun gb/duplicate-line-or-region (&optional n)
  "Gb/Duplicate current line, or region if active"
  (interactive "*p")
  (let ((use-region (use-region-p)))
    (save-excursion
      (let ((text (if use-region
                      (buffer-substring (region-beginning) (region-end))
                    (prog1 (thing-at-point 'line)
                      (end-of-line)
                      (if (< 0 (forward-line 1))
                          (newline))))))
        (dotimes (i (abs (or n 1)))
          (insert text))))
    (if use-region nil
      (let ((pos (- (point) (line-beginning-position) (line-end-position)))
            (forward-line 1)
            (forward-char pos))))))

(defun gb/open-init-file ()
  "Open the init file."
  (interactive)
  (find-file "~/.emacs.d/literate_init.org"))

(gb/leader-keys
  "cd" '(gb/duplicate-line-or-region :which-key "duplicate line or region")
  "ee" '(gb/open-init-file :which-key "open init file"))

(global-set-key (kbd "C-c C-d") 'gb/duplicate-line-or-region)

(use-package tramp
  :ensure nil
  :config
  (setq tramp-default-method "toolkit")
  (tramp-set-completion-function "toolkit"
                                 '((tramp-parse-sconfig "~/.ssh/config")))
  (setq tramp-terminal-type "dumb")
  (setq tramp-inline-compress-start-size 10000000)
  (setq tramp-debug-buffer t)
  (setq tramp-verbose 10))

;; (setf tramp-ssh-controlmaster-options (concat "-o SendEnv TRAMP=yes " tramp-ssh-controlmaster-options))

(add-to-list 'tramp-methods  '("toolkit"
                               (tramp-login-program "ssh")
                               (tramp-login-args
                                (("-p" "%p")
                                 ("-t")
                                 ("-t")
                                 ("-o" "ControlPath=~/.ssh/%%u@v5devgateway.bdns.bloomberg.com:%%p")
                                 ("-o" "ControlMaster=auto")
                                 ("-o" "ControlPersist=yes")
                                 ;; ("-o" "SendEnv TRAMP=yes")
                                 ("-e" "none")
                                 ("v5devgateway.bdns.bloomberg.com")
                                 ("inline")
                                 ("%h")))
                               (tramp-async-args
                                (("-q")))
                               (tramp-remote-shell "/bin/sh")
                               (tramp-remote-shell-args
                                ("-c"))
                               (tramp-gw-args
                                (("-o" "GlobalKnownHostsFile=/dev/null")
                                 ("-o" "UserKnownHostsFile=/dev/null")
                                 ("-o" "StrictHostKeyChecking=no")
                                 ))
                               (tramp-default-port 22)))

(add-to-list 'tramp-remote-path "/opt/bb/bin")

(use-package dap-mode
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  :custom
  (lsp-enable-dap-auto-configure nil)
  :config
  (dap-ui-mode 1)

  :config
  ;; Set up Node debugging
  (require 'dap-node)
  (dap-node-setup) ;; Automatically installs Node debug adapter if needed
  (require 'dap-cpptools)
  (dap-cpptools-setup)
  ;; Bind `C-c l d` to `dap-hydra` for easy access
  (general-define-key
   :keymaps 'lsp-mode-map
   :prefix lsp-keymap-prefix
   "d" '(dap-hydra t :wk "debugger")))

(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  ;; NOTE: Set these if Python 3 is called "python3" on your system!
  ;; (python-shell-interpreter "python3")
  ;; (dap-python-executable "python3")
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))

(use-package python-black
  :demand t
  :after python)

(gb/leader-keys
  "cp" '(python-black-buffer :which-key "run black on buffer"))

(use-package ace-window
  :ensure t
  :init
  (progn
    (global-set-key [remap other-window] 'ace-window)
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0)))))
    ))

;; This is needed as of Org 9.2
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

;; (add-to-list 'load-path
;;               "~/.emacs.d/plugins/yasnippet")
;; (require 'yasnippet)
;; (yas-global-mode 1)
