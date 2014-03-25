(defconst emacsay-mode-version "0.1")
(defvar emacsay-mode-hook nil)

(defun emacsay-version()
  (interactive)
  (message "version %s : %s" emacsay-mode-version "moorekang@gmail.com"))

(defun say-this-string ()
  (interactive)
  (skip-chars-backward "^ \t\n\"\'\(\)\<\>\!\&\;\\\[\]")
  (setq low (point))
  (skip-chars-forward "^ \t\n\"\'\(\)\<\>\!\&\;\\\[\]")
  (setq high (point))
  (copy-region-as-kill low high)
  (setq cmd_str (buffer-substring low high))
  (start-process  "say" nil "say" cmd_str))

(defun emacsay-say-current-string()
  (interactive)
  (let ((pos (point)))
	(say-this-string)
	(goto-char pos)))

;;if last char is not blank, say last word you have just input
(defun emacsay-say-last-string()
  (interactive)
  (setq input_char (buffer-substring (- (point) 1) (point)))
  (setq prev_char (buffer-substring (- (point) 2) (- (point) 1)))
  ;;only when emacsay-mode is on , say this word
  (if (and emacsay-mode
	   (or
	    (string= input_char " ")
	    (string= input_char ".")
	    (string= input_char ",")
	    (string= input_char "!"))
	    (eq nil (string= prev_char " ")))
      (let ((prev_pos (point)))
       (backward-word 1)
       (say-this-string)
       (goto-char prev_pos))))

(defun emacsay-say-buffer()
  (interactive)
  (setq cmd_str (buffer-substring (point-min) (point-max)))
  (start-process "say" nil "say" cmd_str))

(defun emacsay-say-stop()
  (interactive)
  (shell-command "pkill -9 say")
  (message "stop saying buffer"))

(defvar emacsay-mode-map nil
  "Keymap for emacsay minor mode")
(unless emacsay-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-cs" 'emacsay-say-current-string)
    (define-key map "\C-cp" 'emacsay-say-buffer)
    (define-key map "\C-ct" 'emacsay-say-stop)
    (setq emacsay-mode-map map)))

(define-minor-mode emacsay-mode
  "this is the emacsay-mode for Mac OS,
   read the word you have inputed into Emacs"
  ;; The indicator for the mode line.
  :lighter " EmacSay"
  :group 'emacsay
  :keymap emacsay-mode-map
  (add-hook 'post-self-insert-hook 'emacsay-say-last-string))

(provide 'emacsay-mode)
