;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------


(require 'package)


(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")))


(package-initialize) ;; init record of what packages are installed and then run their autoreloads (make them availaible for the session)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t) ;; ensure that the package in installed if not download and install


;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq exec-path (append exec-path '("/home/tarun/.pyenv/versions/pureawesome/pureawesome/bin")))

(setq inhibit-startup-message t) ;; hide the startup message
(tab-bar-mode) ;; before you apply theme
;; (load-theme 'hc-zenburn t)
(load-theme 'material t)
;; (load-theme 'monokai t)
;; (load-theme 'zenburn t)
;; (load-theme 'solarized-dark t)
;; (load-theme 'atom-one-dark t)

;; (load-theme 'afternoon t)


;; (desktop-save-mode)
;; optional: automatically load previous session on startup
;; (desktop-read)

;; (global-linum-mode t) ;; enable line numbers globally
(menu-bar-mode -1) ;; disable menu
(tool-bar-mode -1) ;; disable toolbar
(scroll-bar-mode -1) ;; disable visible scrollbars
(setq visible-bell t) ;; stop the bell on C-g etc.
(setq enable-remote-dir-locals t)
;; nicer buffer things for search, buffer etc.
(use-package ivy
  :diminish ;; hide name from mode-list
  :bind (("C-s" . swiper))
  :init (ivy-mode 1))


(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; Python Config

(use-package treemacs
  :ensure t
  :defer t
  :config
  (setq treemacs-no-png-images t
	  treemacs-width 24)
  :bind ("C-c t" . treemacs))



(use-package eglot
  :ensure t
)



(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  )


(defun ff ()
  "sample code to show region begin/end positions"
  (interactive)
  ;; (message "begin at %s\nend at %s"
  ;;          (region-beginning)
  ;;          (region-end))
  (p-send (region-beginning) (region-end))
  )

(defun select-line-send ()
  (interactive)
  (beginning-of-line-text)
  (set-mark (line-end-position))
  (ff)
  (end-of-line)
  (deactivate-mark)
  )


;; (defun region-send ()
;;   (interactive)
;;   (beginning-of-line-text)
;;   (set-mark (line-end-position))
;;   (ff)
;;   (end-of-line)
;;   )


(defun p-send(start end)
  (interactive "r") ;;Make the custom function interactive and operative on a region
  (setq temp-buffer (buffer-name))
  (append-to-buffer (get-buffer "*Python*") start end) ;;append to the buffer named *PYTHON*
  (switch-to-buffer-other-window (get-buffer "*Python*")) ;;switches to the buffer
  (execute-kbd-macro "\C-m")
  (switch-to-buffer-other-window (get-buffer temp-buffer))) ;;sends the enter keystroke to the shell


(define-key elpy-mode-map (kbd "C-c C-r") 'ff)
(define-key elpy-mode-map (kbd "C-c C-l") 'select-line-send)


;; (defun select)



(setq elpy-shell-echo-input t)
(setq elpy-shell-echo-output t)

;; (setq python-shell-interpreter "ipython")
(setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
             "jupyter")


;; (setq python-shell-interpreter "ipython"
;;       python-shell-interpreter-args "-i --simple-prompt")

;; provide LSP-mode for python, it requires a language server.
;; I use `lsp-pyright`. Know that you have to `M-x lsp-restart-workspace` 
;; if you change the virtual environment in an open python buffer.

;; (use-package lsp-mode
;; :ensure t
;; :defer t
;; :commands (lsp lsp-deferred)
;; :init (setq lsp-keymap-prefix "C-c l")
;; :config (setq lsp-enable-file-watchers nil)
;; :hook ((python-mode julia-mode) . lsp-deferred)
;; )

;; ;; Provides completion, with the proper backend
;; ;; it will provide Python completion.

;; (use-package company
;;   :ensure t
;;   :defer t
;;   :diminish
;;   :config
;;   (setq company-dabbrev-other-buffers t
;;         company-dabbrev-code-other-buffers t)
;;   :hook ((text-mode . company-mode)
;;          (prog-mode . company-mode)))

;; ;; Provides visual help in the buffer 
;; ;; For example definitions on hover. 
;; ;; The `imenu` lets me browse definitions quickly.
;; (use-package lsp-ui
;;   :ensure t
;;   :defer t
;;   :config
;;   (setq lsp-ui-sideline-enable nil
;; 	    lsp-ui-doc-delay 2)
;;   :hook (lsp-mode . lsp-ui-mode)
;;   :bind (:map lsp-ui-mode-map
;; 	      ("C-c i" . lsp-ui-imenu)))

;; ;; Integration with the debug server 
;; (use-package dap-mode
;;   :ensure t
;;   :defer t
;;   :after eglot
;;   :config
;;   (dap-auto-configure-mode))

;; ;; Built-in Python utilities
;; (use-package python
;;   :ensure t
;;   :config
;;   ;; Remove guess indent python message
;;   (require 'dap-python)
;;   ;; (dap-python-executable "/home/tarun/.pyenv/versions/pureawesome/bin/python")
  
;;   (setq python-indent-guess-indent-offset-verbose nil)
;;   ;; Use IPython when available or fall back to regular Python 
;;   (cond
;;    ((executable-find "jupyterwerwerwer")
;;     (progn
;;       ;; (setq python-shell-buffer-name "IPython")
;;       (setq python-shell-interpreter "ipython")
;;       (setq python-shell-interpreter-args "-i --simple-prompt")))
;;    ((executable-find "python3")
;;     (setq python-shell-interpreter "python3"))
;;    ((executable-find "python2")
;;     (setq python-shell-interpreter "python2"))
;;    (t
;;     (setq python-shell-interpreter "python"))))

;; ;; Hide the modeline for inferior python processes
;; (use-package inferior-python-mode
;;   :ensure nil
;;   :hook (inferior-python-mode . hide-mode-line-mode))



;; Required to hide the modeline 
(use-package hide-mode-line
  :ensure t
  :defer t)

;; ;; Required to easily switch virtual envs 
;; ;; via the menu bar or with `pyvenv-workon` 
;; ;; Setting the `WORKON_HOME` environment variable points 
;; ;; at where the envs are located. I use miniconda. 
(use-package pyvenv
  :ensure t
  :defer t
  :config
  ;; Setting work on to easily switch between environments
  (setenv "WORKON_HOME" (expand-file-name "/home/tarun/.pyenv/versions"))
  ;; Display virtual envs in the menu bar
  (setq pyvenv-menu t)
  ;; Restart the python process when switching environments
  (add-hook 'pyvenv-post-activate-hooks (lambda ()
					  (pyvenv-restart-python)))

  ;; experiment above
  :hook (python-mode . pyvenv-mode))




;; ;; (use-package lsp-jedi
;; ;;   :ensure t
;; ;;   :defer t
;; ;;   :hook ((python-mode . (lambda () 
;; ;;                           (require 'lsp-jedi) (lsp-deferred))))
;; ;;   :config

;; ;;   (lsp-register-client
;; ;;    (make-lsp-client
;; ;;     :new-connection (lsp-tramp-connection
;; ;;                    (lambda () "jedi-language-server"))
;; ;;     :major-modes '(python-mode cython-mode)
;; ;;     :remote? t
;; ;;     :priority 2
;; ;;     :server-id 'jedi-remote
;; ;;     :library-folders-fn (lambda (_workspace) '("/usr/"))
;; ;;     :initialization-options (lambda () (gethash "jedi" (lsp-configuration-section "jedi")))))
  
;; ;;   (with-eval-after-load "lsp-mode"
;; ;;     (add-to-list 'lsp-disabled-clients 'pyls)
;; ;;     (add-to-list 'lsp-enabled-clients 'jedi)
;; ;;     (add-to-list 'lsp-enabled-clients 'jedi-remote)
;; ;;     ))




;; ;; Language server for Python 
;; ;; Read the docs for the different variables set in the config.
;; (use-package lsp-pyright
;;   :ensure t
;;   :defer t
;;   :config
;;   (setq lsp-clients-python-library-directories '("/usr/" "/home/tarun/.pyenv/versions/pureawesome/pureawesome/lib/python3.8/site-packages"))
;;   (setq lsp-pyright-disable-language-service nil
;; 	lsp-pyright-disable-organize-imports nil
;; 	lsp-pyright-auto-import-completions t
;; 	lsp-pyright-use-library-code-for-types t
;; 	lsp-pyright-venv-path "/home/tarun/.pyenv/versions/pureawesome/")
;;   ;; (lsp-register-client
;;   ;;  (make-lsp-client
;;     ;;    :new-connection (lsp-tramp-connection (lambda ()
;;     ;;                                    (cons "pyright-langserver"
;;     ;;                                          lsp-pyright-langserver-command-args)))
;;     ;; ;; :new-connection (lsp-tramp-connection "pyright-langserver")
;;     ;; 		    :major-modes '(python-mode)
;;     ;; 		    :remote? t
;;     ;; 		    :server-id 'pyright-remote))

;;    (setq lsp-log-io t)
;;    (setq lsp-pyright-use-library-code-for-types t)
;;    (setq lsp-pyright-diagnostic-mode "workspace")
;;    (lsp-register-client
;;      (make-lsp-client
;;        :new-connection (lsp-tramp-connection (lambda ()
;;                                        (cons "pyright-langserver"
;;                                              lsp-pyright-langserver-command-args)))
;;        :major-modes '(python-mode)
;;        :remote? t
;;        :server-id 'pyright-remote
;;        :multi-root t
;;        :priority 3
;;        :initialization-options (lambda () (ht-merge (lsp-configuration-section "pyright")
;;                                                     (lsp-configuration-section "python")))
;;        :initialized-fn (lambda (workspace)
;;                          (with-lsp-workspace workspace
;;                            (lsp--set-configuration
;;                            (ht-merge (lsp-configuration-section "pyright")
;;                                      (lsp-configuration-section "python")))))
;;        :download-server-fn (lambda (_client callback error-callback _update?)
;;                              (lsp-package-ensure 'pyright callback error-callback))
;;        :notification-handlers (lsp-ht ("pyright/beginProgress" 'lsp-pyright--begin-progress-callback)
;;                                      ("pyright/reportProgress" 'lsp-pyright--report-progress-callback)
;;                                      ("pyright/endProgress" 'lsp-pyright--end-progress-callback))
;;        :initialization-options (lambda () (let* ((pyright_hash (lsp-configuration-section "pyright"))
;; 						 (python_hash (lsp-configuration-section "python"))
;; 						 (_ (puthash "pythonPath" (concat (replace-regexp-in-string (file-remote-p default-directory) "" pyvenv-virtual-env) "bin/python") (gethash "python" python_hash))))
;;                                             (ht-merge pyright_hash
;;                                                       python_hash)))
;;        :initialized-fn (lambda (workspace)
;; 			 (with-lsp-workspace workspace
;;                         (lsp--set-configuration
;;                          (let* ((pyright_hash (lsp-configuration-section "pyright"))
;;                                                (python_hash (lsp-configuration-section "python"))
;;                                                (_ (puthash "pythonPath" (concat (replace-regexp-in-string (file-remote-p default-directory) "" pyvenv-virtual-env) "bin/python") (gethash "python" python_hash))))
;;                            (ht-merge pyright_hash
;;                                      python_hash)))))))
       


;;    :hook ((python-mode . (lambda () 
;;                            (require 'lsp-pyright) (lsp-deferred)))))




;; (defun ff ()
;;   "Prompt user to enter a dir path, with path completion and input history support."
;;   (interactive)
;;   (message "Path is %s" (read-directory-name "Directory:")))

;; Format the python buffer following YAPF rules
;; There's also blacken if you like it better.
(use-package yapfify
  :ensure t
  :defer t
  :hook (python-mode . yapf-mode))


(require 'dap-python)



;; (use-package lsp-julia
;;   :ensure t
;;   :config
;;   (setq lsp-julia-command "/home/tarun/.local/bin/julia")
;;   (setq lsp-julia-default-environment "/home/tarun/.julia/environments/v1.6")
;;   )

;; julia things disabled

;; (use-package eglot-jl
;;   :ensure t
;;   :config
;;   (setq eglot-jl-language-server-project "/home/tarun/.julia/environments/v1.6"))


;; (setq julia-program "/home/tarun/.local/bin/julia")
;; (setq julia-repl-executable-records '((default "/home/tarun/.local/bin/julia")))


;; (use-package julia-mode
;;   :ensure t
;;   :config
;;   (setq julia-program "/home/tarun/.local/bin/julia"))
  
(setenv "JULIA_NUM_THREADS" "4")

;; (use-package julia-repl
;;   :ensure t
;;   :config
;;   (setq julia-repl-executable-records '((default "/home/tarun/.local/bin/julia" :basedir nil)))
;;   :hook (julia-mode . julia-repl-mode)
;;   )

(windmove-default-keybindings 'shift)

(use-package yasnippet
  :config
  (setq yas-snippet-dirs '("~/codesnips"))
  (yas-global-mode 1))



(use-package vterm
  :ensure t)
;; Now run `M-x vterm` and make sure it works!

(define-key vterm-mode-map (kbd "M-RET")  #'vterm-send-M-i)
(define-key vterm-mode-map (kbd "M-i")  #'vterm-send-M-i)
;; (define-key vterm-mode-map (kbd "M-n")  #'vterm-send-M-n)


;; (use-package vterm-extra
;;               :bind (("s-t" . vterm-extra-dispatcher)
;;                   :map vterm-mode-map
;;                   (("C-c C-e" . vterm-extra-edit-command-in-new-buffer))))



(use-package julia-snail
  :ensure t
  :hook (julia-mode . julia-snail-mode)
  :init (setq julia-snail-executable "/usr/local/bin/julia")
  (setq julia-snail-extra-args "--threads=auto")
  )

(electric-pair-mode t)


(defun test-vterm-insert-string ()
  (interactive)
  (vterm-send-string (read-from-minibuffer "What do you want do send? ")))

(defun test-vterm-insert-string ()
  (interactive)
  (vterm-send-string (read-from-minibuffer "What do you want do send? "))
  (vterm-send-return))

(global-set-key "\C-c\C-f" 'ivy-yasnippet)


(use-package julia-mode)
;; (use-package julia-formatter
;;     :hook (julia-mode . (lambda() (julia-formatter-server-start))))


(use-package org
  :ensure f
  :init
  (setq org-agenda-files  (list
			   "/home/tarun/Dropbox/Orgzly/goodlife.org"
			   "/home/tarun/Dropbox/Orgzly/projects.org"
			   "/home/tarun/Dropbox/Orgzly/readytogo.org"
			   "/home/tarun/Dropbox/Orgzly/notes.org"
			   "/home/tarun/Dropbox/Orgzly/unhashed.org"))
  (setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  )

(use-package rust-mode
  :bind ( :map rust-mode-map
               (("C-c C-t" . racer-describe)
                ([?\t] .  company-indent-or-complete-common)))
  :config
  (progn
    ;; add flycheck support for rust (reads in cargo stuff)
    ;; https://github.com/flycheck/flycheck-rust
    (use-package flycheck-rust)

    ;; cargo-mode for all the cargo related operations
    ;; https://github.com/kwrooijen/cargo.el
    (use-package cargo
      :hook (rust-mode . cargo-minor-mode)
      :bind
      ("C-c C-c C-n" . cargo-process-new)) ;; global binding

    ;;; separedit ;; via https://github.com/twlz0ne/separedit.el
    (use-package separedit
      ;; :straight (separedit :type git :host github :repo "idcrook/separedit.el")
      :config
      (progn
        (define-key prog-mode-map (kbd "C-c '") #'separedit)
        (setq separedit-default-mode 'markdown-mode)))


    ;;; racer-mode for getting IDE like features for rust-mode
    ;; https://github.com/racer-rust/emacs-racer
    (use-package racer
      :hook (rust-mode . racer-mode)
      :config
      (progn
        ;; package does this by default ;; set racer rust source path environment variable
        ;; (setq racer-rust-src-path (getenv "RUST_SRC_PATH"))
        (defun my-racer-mode-hook ()
          (set (make-local-variable 'company-backends)
               '((company-capf company-files)))
          (setq company-minimum-prefix-length 1)
          (setq indent-tabs-mode nil))

        (add-hook 'racer-mode-hook 'my-racer-mode-hook)

        ;; enable company and eldoc minor modes in rust-mode (racer-mode)
        (add-hook 'racer-mode-hook #'company-mode)
        (add-hook 'racer-mode-hook #'eldoc-mode)))

    (add-hook 'rust-mode-hook 'flycheck-mode)
    (add-hook 'flycheck-mode-hook 'flycheck-rust-setup)

    ;; format rust buffers on save using rustfmt
    (add-hook 'before-save-hook
              (lambda ()
                (when (eq major-mode 'rust-mode)
                  (rust-format-buffer))))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-backends
   '(company-capf company-bbdb company-semantic company-cmake company-capf company-clang company-files
		  (company-dabbrev-code company-gtags company-etags company-keywords)
		  company-oddmuse company-dabbrev))
 '(ignored-local-variable-values
   '((julia-snail-repl-buffer . "*julia local*")
     (julia-snail-port . 10050)))
 '(julia-snail-remote-port nil)
 '(package-selected-packages
   '(python eval-sexp-fu elpy monokai-theme monokai-pro-theme hc-zenburn-theme afternoon-theme gruvbox-theme sublime-themes vscode-dark-plus-theme zenburn-theme atom-one-dark-theme solarized-theme ivy ivy-yasnippet julia-formatter julia-vterm julia-mode julia-snail yasnippet-snippets vterm separedit racer cargo flycheck-rust rust-mode org-mode pyimpsort json-rpc eglot tramp lsp-jedi yapfify use-package swiper pyvenv python-mode projectile material-theme lsp-ui lsp-pyright lsp-julia julia-repl doom-modeline dap-mode company))
 '(safe-local-variable-values
   '((julia-snail-repl-buffer . "*julia local*")
     (julia-snail-port . 10050))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))


