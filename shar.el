;;; shar.el --- Share current buffer via email and SMS

;; Copyright (C) 2015 Daniel Bordak

;; Author: Daniel Bordak <dbordak@fastmail.fm>
;; URL: TODO
;; Version: 0.1
;; Package-Requires: ((request "0.2") (sendgrid "0.1") (twelio "0.1") (gist "0") (git-link "0"))

;;; Commentary:
;;
;; todo maybe if i feel like it
;;

;;; Code:

(require 'cl-lib)
(require 'request)
(require 'twelio)
(require 'sendgrid)
(require 'gist)

(defgroup shar nil
  ""
  :prefix "shar-")

;; (defun shar-normalize-phone-number (number)
;;   "Normalize NUMBER for use in Twilio's API.  Return nil if it's not a valid number."
;;   (let ((normalized (replace-regexp-in-string "[()- ]" "" number)))
;;     (if (string-match "@" normalized)
;;         nil
;;       normalized)))

(defun shar (arg to)
  "Intelligently share the current buffer, or a part of it, to email or number TO."
  (interactive "P\nsEnter email or phone number: ")
  (if (vc-backend (buffer-file-name))
      (progn
        (git-link git-link-default-remote
                  (car (git-link-get-region))
                  (cdr (git-link-get-region)))
        (if (not (string-match "@" to))
          (twelio-send-message to (current-kill 0))
        (sendgrid-send-message to (current-kill 0))))
    (if (not (string-match "@" to))
        (twelio-send-message to (elt (elt (elt (elt (gist-buffer) 4) 3) 0) 5))
      (if arg
          (sendgrid-send-message to (elt (elt (elt (elt (gist-buffer) 4) 3) 0) 5))
          (sendgrid-send-message to (buffer-string))))))

(provide 'shar)

;;; shar.el ends here
