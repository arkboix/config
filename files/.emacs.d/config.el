(defvar elpaca-installer-version 0.10)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Install a package via the elpaca macro
;; See the "recipes" section of the manual for more details.

;; (elpaca example-package)


;; Install use-package support
(elpaca elpaca-use-package
  ;; Enable use-package :ensure support for Elpaca.
  (elpaca-use-package-mode))


(setq use-package-always-ensure t)

;;When installing a package used in the init file itself,
;;e.g. a package which adds a use-package key word,
;;use the :wait recipe keyword to block until that package is installed/configured.
;;For example:
;;(use-package general :ensure (:wait t) :demand t)

;; Expands to: (elpaca evil (use-package evil :demand t))
(use-package evil
:ensure t
:init
(setq evil-want-integration t
      evil-want-keybinding nil)
:config
(evil-mode 1))  ;; Enable Evil mode at startup



;;Turns off elpaca-use-package-mode current declaration
;;Note this will cause evaluate the declaration immediately. It is not deferred.
;;Useful for configuring built-in emacs features.
(use-package emacs :ensure nil :config (setq ring-bell-function #'ignore))

;; Install general.el
    (elpaca general)

    ;; Wait for general to be installed
    (elpaca-wait)

    ;; Now configure general after it's properly installed
    (require 'general)

    ;; Create a leader key definer that only applies in normal and visual modes, not insert mode
    (general-create-definer my-leader-def
      :states '(normal visual)  ;; Only apply in normal and visual states, not insert
      :prefix "SPC")

    ;; Define keybindings using the definer
    (my-leader-def
      ;; SPC + . to find file
      "." '(find-file :which-key "find file")

      
      ;; SPC + . to find file
      "bs" '(switch-to-buffer :which-key "Switch to buffer")
      
      ;; SPC + q q Kill Emacs
      "qq" '(kill-emacs :which-key "quit emacs")

      ;; SPC + c d change default DIR
      "cd" '(cd :which-key "change default directory")
      
      ;; SPC + f s to save file
      "fs" '(save-buffer :which-key "save file"))


  ;; Unbind M-e so it can be used as a prefix
  (global-unset-key (kbd "M-e"))

  ;; Define tab-related keybindings
  ;;(general-create-definer my-leader-def-tab
  ;;  :prefix "M-e")

  ;;(my-leader-def-tab
  ;;  "t" '(tab-new :which-key "new tab")
  ;;  "q" '(tab-close :which-key "close tab")
  ;;  "w" '(tab-next :which-key "next tab"))

;; Unbind C-= and C-- so they can be used for zooming
(global-unset-key (kbd "C-="))
(global-unset-key (kbd "C--"))

 

    ;; For non-Evil users, create an alternative global map with C-c as prefix
    ;; This is optional but provides a fallback if you're not always in Evil mode
    (general-create-definer my-leader-def-global
      :prefix "C-c"
      :non-normal-prefix "C-c")

    (my-leader-def-global
      ;; C-c . to find file
      "." '(find-file :which-key "find file")

      ;; C-c q q to kill emacs
      "qq" '(kill-emacs :which-key "quit emacs")
      
      ;; C-c f s to save file
      "fs" '(save-buffer :which-key "save file"))

(use-package nerd-icons
    :ensure t)

  (elpaca-wait)
  ;; Run this ONCE after installing nerd-icons
;; uncomment this line, wait for it to install fonts and them comment this line.
;;  (nerd-icons-install-fonts t)

;; First ensure all-the-icons is installed and loaded
(use-package all-the-icons
  :ensure t)

;; Enhanced dashboard configuration with colors and features
(use-package dashboard
  :ensure t
  :after all-the-icons  ;; Make sure all-the-icons is loaded first
  :init
  (use-package page-break-lines :ensure t)
  :custom
  ;; Set the title with fancy formatting
  (dashboard-banner-logo-title
   (propertize "Welcome to Emacs. Vim users just don't get this, do they?"
               'face '(:family "Fira Code" :height 1.2 :weight bold
                      :foreground "#61AFEF")))
  
  ;; Set the banner
  (dashboard-startup-banner "~/.emacs.d/icons/arkmacs-4.png" "~/.emacs.d/icons/arkmacs-4.txt")
  
  ;; Enable icons for a more modern look
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  
  ;; Content is not centered by default
  (dashboard-center-content nil)
  ;; Vertically center content
  (dashboard-vertically-center-content t)
  ;; Hide shortcut indicators
  (dashboard-show-shortcuts nil)
  
  ;; Show project list with fancy icon
  (dashboard-items '((recents  . 5)
                    (bookmarks . 5)
                    (projects . 5)
                    (agenda . 5)))
  
  ;; Customize item names with colors
  (dashboard-item-names '(("Recent Files:" . "Recent Files:")
                          ("Bookmarks:" . "Bookmarks:")
                          ("Projects:" . "Projects:")
                          ("Agenda:" . "Agenda:")))
  
  ;; Custom footer with cool quotes
  (dashboard-footer-messages '("Emacs: Making Vim users question their life choices since 1976"
                              "Where there's a shell, there's a way"
                              "May the source be with you!"))
  :config
  ;; Set up pretty symbols for various elements only if all-the-icons is available
  (when (package-installed-p 'all-the-icons)
    (setq dashboard-footer-icon (all-the-icons-faicon "code" 
                                                     :height 1.1 
                                                     :v-adjust -0.05 
                                                     :face '(:foreground "#98C379")))
    
    ;; Only set navigator buttons if all-the-icons is available
    (setq dashboard-navigator-buttons
         `(((,(all-the-icons-octicon "mark-github" :height 1.1 :v-adjust 0.0)
            "GitHub" "Browse GitHub" (lambda (&rest _) (browse-url "https://github.com")))
            (,(all-the-icons-fileicon "emacs" :height 1.1 :v-adjust 0.0)
            "Config" "Edit config" (lambda (&rest _) (find-file "~/.emacs.d/init.el")))
            (,(all-the-icons-faicon "refresh" :height 1.1 :v-adjust 0.0)
            "Update" "Update packages" (lambda (&rest _) (package-refresh-contents)))
            (,(all-the-icons-octicon "gear" :height 1.1 :v-adjust 0.0)
            "Settings" "Open settings" (lambda (&rest _) (find-file "~/.emacs.d/settings.org"))))))
    
    (dashboard-modify-heading-icons '((recents . "file-text")
                                     (bookmarks . "bookmark")
                                     (agenda . "calendar")
                                     (projects . "file-directory")
                                     (registers . "database"))))
  
  ;; Custom item face colors
  (custom-set-faces
   '(dashboard-heading ((t (:foreground "#C678DD" :weight bold))))
   '(dashboard-items-face ((t (:foreground "#ABB2BF"))))
   '(dashboard-banner-logo-title-face ((t (:foreground "#56B6C2" :weight bold)))))
  
  ;; Enable the dashboard
  (dashboard-setup-startup-hook))

;; Optional: Make the dashboard more colorful with rainbow mode
(use-package rainbow-mode
  :ensure t
  :hook (dashboard-mode . rainbow-mode))

(use-package vertico
 :ensure t
 :init
 (vertico-mode))

(use-package doom-themes
    :ensure t
:config
(load-theme 'doom-meltbus t))


 ;; Additonal Themes
 (use-package constant-theme)
 (use-package simplicity-theme)

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic partial-completion substring))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion))
                                   (eglot (styles orderless)))))

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)                       ;; Enable auto completion
  (corfu-auto-delay 0.0)               ;; No delay for auto completion (more responsive)
  (corfu-auto-prefix 1)                ;; Show completions after typing just 1 character
  (corfu-cycle t)                      ;; Allow cycling through candidates
  (corfu-preselect 'first)             ;; Always preselect first candidate
  (corfu-count 14)                     ;; Show more candidates
  (corfu-max-width 80)                 ;; Set maximum width for popup
  (corfu-preview-current t)            ;; Preview current candidate
  (corfu-on-exact-match nil)           ;; Don't auto-complete exact matches
  (tab-always-indent 'complete)        ;; Use TAB for both indent and completion
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous)
        ("RET" . corfu-insert)
        ("M-SPC" . corfu-insert-separator)
        ("C-g" . corfu-quit))
  :init
  (global-corfu-mode)
  :config
  ;; Enable Corfu completion in the minibuffer
  (defun corfu-enable-always-in-minibuffer ()
    "Enable Corfu in the minibuffer regardless of `completion-at-point'."
    (setq-local corfu-auto nil)        ;; Enable manual triggering only
    (corfu-mode 1))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer))

;; Helper function to restart Corfu if needed
(defun restart-corfu ()
  "Restart corfu-mode globally."
  (interactive)
  (global-corfu-mode -1)
  (sleep-for 0.1)
  (global-corfu-mode 1)
  (message "Corfu restarted"))

(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 28) ;; Adjust height
  (setq doom-modeline-bar-width 4)
  (setq doom-modeline-project-detection 'auto)
  (setq doom-modeline-buffer-file-name-style 'truncate-upto-project))

;; (use-package powerline
;;  :ensure t
;;  :config
;;  (powerline-default-theme))
;;

(use-package vterm
    :ensure t)

;; (use-package org-bullets
;;   :ensure t
;;   :init
;;       (add-hook 'org-mode-hook (lambda ()
;;                            (org-bullets-mode 1))))

;; (use-package org-modern
   ;;  :ensure t
   ;;  :hook (org-mode . org-modern-mode))
  (elpaca-wait)
(use-package org-modern
  :ensure t
  :after org
  :init
  (global-org-modern-mode)
  :config
  (setq org-modern-list nil)
  (setq org-modern-star 'fold)
  (setq org-modern-fold-stars '(("◉" . "○") ("◈" . "◇") ("▣" . "□") ("◉" . "○") ("◈" . "◇") ("▣" . "□") ("◉" . "○") ("◈" . "◇") ("▣" . "□")))
  (setq org-modern-block-fringe nil)
  (setq org-modern-progress 18)
  (setq org-modern-table nil)
  (setq org-modern-todo-faces
    '(("TODO" :background "#323c41" :foreground "#83c092" :weight semibold)
      ("NEXT" :background "#323c41" :foreground "#ddbc7f" :weight semibold)
      ("DONE" :background "#323c41" :foreground "#a7c080" :weight semibold)
      ("BACKLOG" :background "#323c41" :foreground "#e67e80" :weight semibold)
      ("PLAN" :background "#323c41" :foreground "#ddbc74" :weight semibold)
      ("READY" :background "#323c41" :foreground "#a7c080" :weight semibold)
      ("ACTIVE" :background "#323c41" :foreground "#7fbbb3" :weight semibold)
      ("REVIEW" :background "#323c41" :foreground "#e69875" :weight semibold)
      ("WAIT" :background "#323c41" :foreground "#abb2bf" :weight semibold)
      ("HOLD" :background "#323c41" :foreground "#abb2bf" :weight semibold)
      ("COMPLETED" :background "#323c41" :foreground "#a7c080" :weight semibold)
      ("CANC" :background "#323c41" :foreground "#e67e80" :weight semibold))))

(use-package which-key
  :ensure t
  :config
  (which-key-mode)  ;; Enable which-key globally
  (setq which-key-idle-delay 0.5))  ;; Show suggestions faster

(use-package embark
  :bind
  (("C-," . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)

(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))

;; Enable tab bar mode
(setq tab-bar-show 1)    ;; Always show tabs
(setq tab-bar-position 'bottom) ;; Move tabs to the bottom
(setq tab-bar-new-tab-choice "*dashboard*")
(tab-bar-mode 1)

;; Set the default font globally (including size)
(add-to-list 'default-frame-alist '(font . "Ubuntu Mono-14"))

(dolist (face '((org-level-1 . 2.2)
                (org-level-2 . 1.4)
                (org-level-3 . 1.2)
               (org-level-4 . 1.1)
                (org-level-5 . 1.0)))
  (set-face-attribute (car face) nil :height (cdr face)))

;; Bind C-= to increase text scale
  (global-set-key (kbd "C-=") #'text-scale-increase)
  ;; Bind C-- to decrease text scale
  (global-set-key (kbd "C--") #'text-scale-decrease)

(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "C-t") nil)
  (define-key evil-normal-state-map (kbd "C-q") nil)
  (define-key evil-normal-state-map (kbd "C-r") nil))

;; Now set your global keybindings
(global-set-key (kbd "C-t") #'tab-new)
(global-set-key (kbd "C-q") #'tab-close)
(global-set-key (kbd "C-r") #'tab-next)

(electric-pair-mode 1)

;; Ensure dashboard icons appear in emacsclient
(when (daemonp)
  (add-hook 'server-after-make-frame-hook #'dashboard-refresh-buffer))

(setq make-backup-files t)
(setq backup-directory-alist `(("." . "~/emacs-backups")))
