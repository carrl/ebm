Emacs Bookmarks
===============


Linux
----
	cd ~/.emacs.d
	mkdir ebm
	cd ebm
	git clone https://github.com/carrl/carrltest.git


.emacs
----
	;; ebm set
	(add-to-list 'load-path "~/.emacs.d/ebm/")
	(require 'ebm)

	(global-set-key (kbd "<f2>") 'ebm-jump-to-next-bookmark-in-current-buffer)
	(global-set-key (kbd "<C-f2>") 'ebm-set-bookmark)
