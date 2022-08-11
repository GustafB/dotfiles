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
(global-set-key (kbd "C-x o") #'gb/other-window)
