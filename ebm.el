;;; ebm.el --- Emacs Bookmarks

;; Copyright (C) 2008 Free Software Foundation, Inc.

;; Author: carrl yea <carrl@5432.tw>
;; Maintainer: carrl yea
;; Version: 0.1
;; Date: 2012-12-27
;; Keywords: bookmark

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.


(defun ebm-includep (aitem alist)
  " includep "
  (let ((yn nil))
    (dolist (i alist)
      (if (equal i aitem)
	(setf yn t)))
    yn))

(defun ebm-delete-bookmark ()
  " delete bookmark "
  (let ((alist nil) (result nil))
    (dolist (aitem (copy-sequence register-alist))
      (if (markerp (cdr aitem))
	  (push aitem alist)))
    (dolist (aitem alist)
      (progn
	(if (and 
	     (equal 
	      (get-buffer (buffer-name))
	      (marker-buffer (cdr aitem)))
	     (equal
	      (point)
	      (marker-position (cdr aitem))))
	    (progn
	      (setf register-alist (remove aitem register-alist))
	      (setf result t)))))
    (if result
	(princ "delete-bookmark"))
    result))

(defun ebm-next-register-id ()
  " find next unuse register id "
  (let ((cont t) (my-id nil) (alist nil))
    (dolist (aitem (copy-sequence register-alist))
      (if (< (car aitem) 27)
	  (if (markerp (cdr aitem))
	      (push (car aitem) alist))))
    (loop for i from 1 to 27 do
	  (if (and (not (ebm-includep i alist)) cont)
	      (progn
		(setq my-id i)
		(setq cont nil))))
    my-id
    ))

(defun ebm-set-bookmark ()
  " 設定 register "
  (interactive)
  (let ((my-id nil))
    (if (not (ebm-delete-bookmark))
     (progn
       (setq my-id (ebm-next-register-id))
       (if my-id
	   (progn
	     (point-to-register my-id)
	     (princ "set bookmark"))
	 (error " no register id can use ")))
     )
    ))

(defun ebm-jump-to-next-bookmark-in-current-buffer ()
  " jump to next bookmark "
  (interactive)
  (let ((cont t) (aitem nil) (alist nil) (poslist nil))
    ;; find all register id in current buffer, push to alist
    (dolist (aitem (copy-sequence register-alist))
      (cond
       ((markerp (cdr aitem))		;; markerp
	(if (equal (get-buffer (buffer-name)) (marker-buffer (cdr aitem)))
	   (push aitem alist)))))
    ;; get marker-position data, push to poslist, and sort
    (dolist (aitem alist)
      (push (marker-position (cdr aitem)) poslist))
    (setf poslist (sort poslist #'<))
    ;; jump to next bookmark
    (if (> (length poslist) 0)
	(progn
	  (dolist (aitem poslist)
	    (if cont
		(if (> aitem (point))
		    (progn
		      (goto-char aitem)
		      (setf cont nil)
		      ))))
	  (if cont
	      (goto-char (car poslist)))))
    ))

(provide 'ebm)