(add-to-list 'load-path "~/.emacs.d/")

;; get marmalade packages in package.el
(require 'package)
(add-to-list 'package-archives
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(package-initialize)

;; Expand region and pending delete mode: http://emacsrocks.com/e09.html
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
;; Delete active text when you start typing
(pending-delete-mode t)

;; use interactive mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(push "/usr/bin" exec-path)
(push "/usr/local/bin" exec-path)
(push "/opt/local/bin" exec-path)

;; I have had it with these motherfuckin' bakup files on this motherfuckin' filesystem
(setq make-backup-files nil)

(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

;; Close magit with one key
;; http://whattheemacsd.com/setup-magit.el-01.html
(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))
(defun magit-quit-session ()
  "Restores the previous window configuration and kills the magit buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))
(define-key magit-status-mode-map (kbd "q") 'magit-quit-session)

(require 'git-commit-mode)
(require 'gitconfig-mode)
(require 'gitignore-mode)
(require 'magithub)

;; Toggle between split windows and a single window
;; http://thornydev.blogspot.com/2012/08/happiness-is-emacs-trifecta.html
(defun toggle-windows-split()
  "Switch back and forth between one window and whatever split of windows we might have in the frame. The idea is to maximize the current buffer, while being able to go back to the previous split of windows in the frame simply by calling this command again."
  (interactive)
  (if (not (window-minibuffer-p (selected-window)))
      (progn
        (if (< 1 (count-windows))
            (progn
              (window-configuration-to-register ?u)
              (delete-other-windows))
          (jump-to-register ?u))))
  (my-iswitchb-close))

;; ace-jump-mode https://github.com/winterTTr/ace-jump-mode
;; word jump C-c spc
;; char jump C-u C-c spc
;; line jump C-u C-u C-c spc
(require 'ace-jump-mode)
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

(define-key global-map (kbd "C-|") 'toggle-windows-split)

;; clear eshell - http://www.khngai.com/emacs/eshell.php
(defun eshell/clear ()
  "04Dec2001 - sailor, to clear the eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

;; http://emacs.wordpress.com/2007/01/17/eval-and-replace-anywhere/
(defun fc-eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))
(global-set-key (kbd "C-c e") 'fc-eval-and-replace)

;; start emacs server
(server-start)

;; replace highlighted text when possible
(delete-selection-mode 1)

;; font-lock mode enables syntax highlighting
(global-font-lock-mode 1)

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format (concat  "%b - emacs@" system-name))

;; color theme
;; (add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme-solarized")
;; (load-theme 'solarized-light t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/tomorrow-theme/GNU Emacs")
;; (load-theme 'tomorrow-night t)
;; (load-theme 'tomorrow-night-bright t)
(load-theme 'tomorrow-night-eighties t)

;; GUIs are for hipsters
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; custom key bindings
(global-set-key [\C-tab] 'other-window)
(global-set-key [\C-\`] 'switch-to-buffer)
(global-set-key "\M-\`" 'ff-find-other-file)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-x\C-k" 'compile)
(global-set-key "\C-c\C-c" 'comment-region)
(global-set-key "\C-c\C-x" 'uncomment-region)
(global-set-key "\M-q" 'query-replace)
(global-set-key "\M-1" 'revert-buffer)
(global-set-key [\C-escape] 'electric-buffer-list)

;; scroll line by line
(setq scroll-step 1)

;; show time
(display-time)

;; use y or n instead of yes or not
(fset 'yes-or-no-p 'y-or-n-p)

;; show column number
(column-number-mode t)

;; Parenthesis matching
(show-paren-mode 1)

;; compilation stuff
(setq compilation-scroll-output 1)   ;; automatically scroll the compilation window
(setq compilation-window-height 10)

;; inconsolata font (this sometimes doesn't work...)
;; (set-default-font "Inconsolata-14")
;; (set-default-font "Menlo-13:antialias=natural")
(set-default-font "Menlo-13:antialias=none")

;; don't wrap long lines onto new lines
(set-default 'truncate-lines t)

;; say no to unecessary whitespace
(require 'whitespace)
(setq whitespace-line-column 100
      whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)

;; if you want to be really hardcore
;;(require 'drill-instructor)
;;(setq drill-instructor-global t)

;; indentation for different file types
(setq js-indent-level 2)
(setq-default indent-tabs-mode nil)
(add-hook 'python-mode-hook
      (lambda ()
        (setq tab-width 2)
        (setq python-indent 2)))

;; coffee-mode: https://github.com/defunkt/coffee-mode
(add-to-list 'load-path "~/.emacs.d/coffee-mode")
(require 'coffee-mode)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))
(setq coffee-tab-width 2)

;; less css mode: https://github.com/purcell/less-css-mode
(setq css-indent-offset 2)
(require 'less-css-mode)

;; use markdown mode
(require 'markdown-mode)
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
;;(setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))

(defun markdown-custom ()
       "markdown-mode-hook"
       (setq markdown-command "/usr/local/bin/markdown"))
     (add-hook 'markdown-mode-hook '(lambda() (markdown-custom)))

;; use js mode for json
(add-to-list 'auto-mode-alist '("\\.json$" . js-mode))

;; jade html templates
(require 'sws-mode)
(require 'jade-mode)
(add-to-list 'auto-mode-alist '("\\.styl$" . sws-mode))
(add-to-list 'auto-mode-alist '("\\.jade$" . jade-mode))

;; Longlines mode for markdown files
(add-to-list 'auto-mode-alist '("\\.md$" . longlines-mode))

;; clojure
(require 'clojure-mode)

;; php
(require 'php-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(solarized-contrast (quote high)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'erase-buffer 'disabled nil)

;; highlight current line
(global-hl-line-mode +1)

;; add recently opened files to the menu
(require 'recentf)
(setq recentf-max-saved-items 200
      recentf-max-menu-items 15)
(recentf-mode +1)

;; make them accessible through ido
(defun recentf-ido-find-file ()
  "Find a recent file using ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))
(global-set-key (kbd "C-c f") 'recentf-ido-find-file)

;; display visited file's path in the frame title
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; http://emacsredux.com/blog/2013/03/30/kill-other-buffers/
(defun kill-other-buffers ()
  "Kill all buffers but the current one.
Don't mess with special buffers."
  (interactive)
  (dolist (buffer (buffer-list))
    (unless (or (eql buffer (current-buffer)) (not (buffer-file-name buffer)))
      (kill-buffer buffer))))
(global-set-key (kbd "C-c k") 'kill-other-buffers)

(add-to-list 'load-path "~/.emacs.d/inf-mongo")
(require 'inf-mongo)

;; http://stackoverflow.com/questions/8606954/path-and-exec-path-set-but-emacs-does-not-find-executable
;; use the same $PATH that we have on the shell
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))
