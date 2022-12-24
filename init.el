; Enable MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

; use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

; UI stuff 
(setq x-select-enable-clipboard-manager nil)
;; Unclutter
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-startup-message t)
(global-set-key (kbd "<C-tab>")  'mode-line-other-buffer)
;; Line numbers
(setq-default display-line-numbers 'visual)
;; Font
(set-face-attribute 'default nil :font "SF Mono")
(set-frame-font "SF Mono" nil t)
(use-package dashboard
  :init (setq dashboard-startup-banner "/home/orvergon/happy-gon.gif"
	      dashboard-set-heading-icons t
	      dashboard-set-file-icons t
	      dashboard-set-navigator t
	      dashboard-items '((recents . 10)
				(bookmarks . 5)
				(projects . 5)))
				;(agenda . 5)
				;;(registers . 5)
  :ensure t
  :config (dashboard-setup-startup-hook))


; Installing packages
(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs helm-lsp all-the-icons ;all-the-icons-dired
    projectile hydra flycheck company avy which-key helm-xref dap-mode evil helm-projectile))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))


; Packages
;; which-key
(use-package which-key
    :ensure t
    :config (which-key-mode 1))

;; Dired
;(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;(use-package treemacs-icons-dired
;  :after treemacs dired
;  :ensure t
;  :config (treemacs-icons-dired-mode))
;(use-package treemacs
;  :ensure t)
;(use-package dired-subtree
;  :ensure t
;  :after dired
;  :config
;  (bind-key "<tab>" #'dired-subtree-toggle dired-mode-map))


; Evil
(use-package evil
;    :hook prog-mode)
  :config (evil-mode 1))

; Helm
;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
(use-package helm
  :bind
    (([remap find-file] . helm-find-files)
	 ([remap execute-extended-command] . helm-M-x)
	 ([remap switch-to-buffer] . helm-mini))
  :config
  (helm-mode 1)

  (define-key evil-normal-state-map (kbd "C-t")  'helm-lsp-workspace-symbol))

(require 'iimage)
(setq iimage-mode-image-regex-alist
    `((,(concat "\\(file://\\)" "\\(" iimage-mode-image-filename-regex "\\)") . 2)))
; LSP
(use-package lsp
  :init
    (add-hook 'c-mode-hook 'lsp)
    (add-hook 'rust-mode-hook 'lsp)
    (add-hook 'c++-mode-hook 'lsp)
    (add-hook 'prog-mode-hook 'hs-minor-mode)
    (add-hook 'lsp-mode-hook 'iimage-mode)
    (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  :config
    ;(require 'dap-cpptools)
    (add-hook 'c++-mode-hook (lambda () (evil-close-folds)))
    (yas-global-mode))

;slime
(setq inferior-lisp-program "/usr/bin/sbcl")

; Tree-sitter
(use-package tree-sitter
  :init
    (add-hook 'c++-mode-hook 'tree-sitter-hl-mode))


(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      ;treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

;(with-eval-after-load 'lsp-mode
;  ;(add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
;  (require 'dap-cpptools)
;  (yas-global-mode))

(global-set-key (kbd "<f12>") 'xref-find-definitions)


(require 'dired )
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file) ; was dired-advertised-find-file
(define-key dired-mode-map (kbd "^") (lambda () (interactive) (find-alternate-file "..")))  ; was dired-up-directory
(put 'dired-find-alternate-file 'disabled nil)

;(use-package dap-mode
;    :defer
;    :custom
;      (dap-auto-configure-features '(sessions locals breakpoints expressions repl controls tooltip))
;      (dap-lldb-debug-program '("/usr/bin/lldb-vscode"))
;    :requires (dap-lldb)
;    :init
;      (require 'dap-lldb)
;      (require 'dap-gdb-lldb)
;    :config
;      (require 'dap-lldb)
;      (require 'dap-gdb-lldb)
;      (dap-mode 1)
;      (dap-tooltip-mode 1)
;      (dap-auto-configure-mode 1)
;      (dap-ui-controls-mode 1)
;      (dap-register-debug-template
;          "LLDB::Run"
;          (list :type "lldb"
;                :cwd "/home/orvergon/myen/build"
;                :request "launch"
;                :args (list "")
;                :program "/home/orvergon/myen/build/myen"
;                :name "LLDB::Run")))
;(require 'dap-lldb)
;(require 'dap-gdb-lldb)
;(dap-gdb-lldb-setup)
;(use-package dap-ui
;    :after (dap-mode)
;    :config
;      (dap-ui-mode 1))

(setq projectile-switch-project-action #'projectile-dired)
(setq projectile-indexing-method 'native)
(setq projectile-sort-order 'recently-active)
(setq projectile-enable-caching t)

(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file) ; was dired-advertised-find-file

(projectile-mode)
(require 'helm-projectile)
(define-key evil-normal-state-map (kbd "C-p") nil)
(global-set-key (kbd "C-p") 'helm-mini)
(global-set-key (kbd "C-S-p") 'helm-projectile-find-file)
(electric-pair-mode)
(setq electric-pair-preserve-balance nil)

(setq c-default-style "linux"
      c-basic-offset 4)


; Build hack
(defun reset-buffer (buffer-name)
  ;(kill-buffer (get-buffer-create buffer-name))
  (get-buffer-create buffer-name))

(defun run-cmake ()
    (let* ((default-directory "/home/orvergon/myen/build")
	   (my-process (start-process "run-cmake-process"
				      (get-buffer-create "*build*") "cmake" ".."
					"-D" "CMAKE_BUILD_TYPE=Debug")))
      (set-process-filter my-process 'comint-output-filter)))

(defun run-make ()
    (let* ((default-directory "/home/orvergon/myen/build")
	   (my-process (start-process "run-make-process"
				      (get-buffer-create "*build*") "make")))
      (set-process-filter my-process 'comint-output-filter)))

(defun run-project ()
    (let* ((default-directory "/home/orvergon/myen/build")
	   (my-process (start-process "run-project"
				      (get-buffer-create "*build*") "/home/orvergon/myen/build/myen")))
      (set-process-filter my-process 'comint-output-filter)))

(defun run-make-callback (process signal)
  (message signal)
  (when (memq (process-status process) '(exit signal))
    (run-make)))

(defun run-project-callback (process signal)
  (when (memq (process-status process) '(exit signal))
    (run-project)))

(defun build ()
  (interactive)
    (reset-buffer "*build*")
    (display-buffer "*build*" '(display-buffer-at-bottom . ((window-height . 10))))
    (with-current-buffer (get-buffer-create "*build*")
    (goto-char (point-max))
    (erase-buffer)
    (ansi-color-for-comint-mode-on)
    (comint-mode))
    (run-cmake)
    (set-process-sentinel (get-process "run-cmake-process") 'run-make-callback))

(defun run-myen()
  (interactive)
    (with-current-buffer (get-buffer-create "*build*")
    (goto-char (point-max)))
    (run-project))

(global-set-key (kbd "<f4>") 'build)
(global-set-key (kbd "<f5>") 'run-myen)


(load-theme 'github-modern t)
(setq lsp-headerline-breadcrumb-enable nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(elfeed-feeds
   '(("https://www.youtube.com/feeds/videos.xml?channel_id=UCXuqSBlHAE6Xw-yeJA0Tunw" ltt)
     "https://www.youtube.com/feeds/videos.xml?channel_id=UCeTfBygNb1TahcNpZyELO8g"))
 '(package-selected-packages
   '(slime doom-modeline helm-ag racket-mode glsl-mode elfeed-tube elfeed realgud dashboard cmake-font-lock rustic rust-mode lsp-mode yasnippet lsp-treemacs helm-lsp all-the-icons all-the-icons-dired projectile hydra flycheck company avy which-key helm-xref dap-mode evil helm-projectile))
 '(warning-suppress-types '((comp) (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
