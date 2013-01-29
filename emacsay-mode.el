
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

(defun say-current-string()
  (interactive)
  (let ((pos (point)))
	(say-this-string)
	(goto-char pos)))

;;if last char is not blank, say last word you have just input 
(defun say-last-string()
  (interactive)
  (setq input_char (buffer-substring (- (point) 1) (point)))
  (setq  prev_char (buffer-substring (- (point) 2) (- (point) 1)))
  ;;only when emacsay-mode is on , say this word 
  (if (and emacsay-mode (string= input_char " ") (eq nil (string= prev_char " ")))
      (let ((prev_pos (point)))
       (backward-word 1)
       (say-this-string)
       (goto-char prev_pos))))  

(defun say-buffer()
  (interactive)
  (setq cmd_str (buffer-substring (point-min) (point-max)))
  (start-process "say" nil "say" cmd_str))

(defun say-stop()
  (interactive)
  (shell-command "pkill -9 say")
  (message "stop saying buffer"))

(defvar emacsay-mode-map nil
  "Keymap for emacsay minor mode")
(unless emacsay-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-cs" 'say-current-string)
    (define-key map "\C-cp" 'say-buffer)
    (define-key map "\C-ct" 'say-stop)
    (setq emacsay-mode-map map)))


(define-minor-mode emacsay-mode()
  "this is the emacsay-mode for Mac OS,
   read the word you have inputed into Emacs"
  ;; The initial value.
  :init-value nil
  ;; The indicator for the mode line.
  :lighter " EmacSay"
  :keymap emacsay-mode-map)
  (add-hook 'post-self-insert-hook 'say-last-string))
  
(provide 'emacsay-mode)

