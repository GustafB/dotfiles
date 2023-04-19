(package-initialize)

(org-babel-load-file "~/.emacs.d/literate_init.org")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("1704976a1797342a1b4ea7a75bdbb3be1569f4619134341bd5a4c1cfb16abad4" "7eea50883f10e5c6ad6f81e153c640b3a288cd8dc1d26e4696f7d40f754cc703" "709b3fef0cb6059b416dfbc34ca798316833c860b68f9e41e2f172c636674a21" "eecacf3fb8efc90e6f7478f6143fd168342bbfa261654a754c7d47761cec07c8" default))
 '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages)
 '(ivy-dynamic-exhibit-delay-ms 200)
 '(ivy-height 7)
 '(ivy-initial-inputs-alist nil)
 '(ivy-magic-tilde nil)
 '(ivy-re-builders-alist '((t . ivy--regex-ignore-order)) t)
 '(ivy-use-virtual-buffers t)
 '(ivy-wrap t)
 '(markdown-command "/usr/local/bin/markdown")
 '(package-selected-packages
   '(diminish no-littering pyenv-mode dap-mode forge all-the-icons-dired dired-hide-dotfiles dired-open dired-single eshell-git-prompt eterm-256color evil-nerd-commenter company-box lsp-ivy lsp-treemacs lsp-ui counsel-projectile general helpful ivy-rich rainbow-delimiters doom-themes doom-modeline evil-commentary yaml-mode evil-tutor evil-org evil-surround evil-collection tramp graphviz-dot-mode flymd lsp-python-ms lsp-mode cmake-mode slime racket-mode yasnippet with-editor quelpa-use-package multiple-cursors js2-mode biblio-core biblio all-the-icons helm-gtags company-c-headers rtags tablist swiper smartparens quelpa pdf-tools parsebib org-ref magit-popup magit ivy hydra helm-core helm-bibtex helm git-commit ghub flycheck f dash company avy async ace-window flycheck-rtags company-rtags helm-rtags hungry-delete expand-region origami company-restclient restclient evil dired-du markdown-preview-mode markdown-mode magithub-completion magit-files magit-commit zerodark-theme xref-js2 which-key web-mode vue-mode use-package try treemacs scss-mode rjsx-mode rainbow-mode projectile org-journal org-bullets org-babel-eval-in-repl lorem-ipsum json-mode js2-refactor indium ido-vertical-mode helmp google-this flx-ido exec-path-from-shell drag-stuff dracula-theme counsel company-web color-theme auto-compile ag ac-js2)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0)))))
(put 'narrow-to-page 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
