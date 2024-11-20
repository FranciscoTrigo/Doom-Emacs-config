;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "YamiFrankc"
      user-mail-address "Yami@YamiFrankc.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 18 :weight 'medium))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'srcery)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;;(setq org-directory
;;    (cond
;;    ((string= (system-name) "anomalocarisWin") "/mnt/c/Users/yamifrankc/code/orgmode/")
;;  (t  "~/code/orgmode/")))



(setq org-directory
      (cond
       ((and (string-equal system-type "gnu/linux")
             (file-exists-p "/mnt/c"))
        "/mnt/c/Users/yamifrankc/code/orgmode/")
       (t "~/code/orgmode"))) ; Default org directory

;; Define function to generate paths inside org-directory
(defun org-file-path (filename)
  "Construct the full path to an org file inside `org-directory'."
  (expand-file-name filename org-directory))

(add-hook 'org-mode-hook
          (lambda () (org-autolist-mode)))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; This is so buffers auto-save
;; Auto-save every 60 seconds
(setq auto-save-visited-interval 15)
(auto-save-visited-mode +1)
(setq auto-save-default t
      make-backup-files t)
(setq auto-save-interval 15)


;; Enable showing a word count in the modeline. Only works in Markdown, GFM and Org by default
(setq doom-modeline-enable-word-count t)

;; Enable logging of done ORG task and lof stuff into the LOGBOOK drawer
(after! org
  (require 'ox-md)
  (setq org-log-done t)
  (setq org-log-drawer t))

;; Disable electric mode for weird indents in org-mode
(add-hook! org-mode (electric-indent-local-mode -1))

;; Org mode capture templates
(after! org
  (setq org-capture-templates
        '(("T" "TODO with link to here" entry (file+headline "todo.org" "Inbox")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n %a")
          ("t" "TODO entry" entry (file+headline "todo.org" "Inbox")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n")
          ("d" "Dream entry" entry (file+headline "Personal.org" "Dreams")
           "* %t %?")
          ("j" "Journal" entry (file+datetree+prompt "journal.org")
           "* %U %?")
          ("G" "Good things" entry (file+datetree+prompt "feats.org")
           "* %U %?  :goodThing:")
          ("B" "Bad things" entry (file+datetree+prompt "feats.org")
           "* %U %?  :badThing:")
          ("b" "Buy list" entry (file+headline "todo.org" "Things to buy")
           "* TODO %? :buyThis:\n - Date: %T")
          ("r" "Random inbox" entry (file "Inbox.org" )
           "* %? \n:PROPERTIES:\n:CREATED: %U\n:END:\n")
          )))

;; Roam the org
(after! org
  (setq org-roam-directory "org-file-path")
  (setq org-roam-index-file "org-file-path index.org"))

;; Different colors for org-roam and org links
;;(custom-set-faces
;;      '((org-roam-link org-roam-link-current)
;;      :foreground "#e24888" :underline t))

;; Some custom keyobard shortcuts
;; exmaple:
;; (map! "<C-left>" #'something)
(map! "C-c n l" #'org-roam-buffer-toggle
      "C-c n f" #'org-roam-node-find
      "C-c n i" #'org-roam-node-insert
      "C-c n c" #'org-id-get-create)
(map! :after evil-org
      :map evil-org-mode-map
      :ni "C-<return>" #'org-insert-heading-respect-content)
(map! "C-c b" #'ibuffer)
(map! "C-c y" #'clipboard-yank)

(map! "C-c TAB" #'other-window)

;; Add a new journal entry
(map! "C-c j n" #'org-journal-new-entry)
(map! "C-c j s" #'org-journal-search)

;; Org-journal config stuff
;;(after! org
;;(setq org-journal-dir "~/code/orgmode/journal/"))
;;(require 'org-journal)

(after! evil
  (evil-ex-define-cmd "wq" 'doom/save-and-kill-buffer)
  (evil-ex-define-cmd "q" 'kill-this-buffer)
  )

;; Set attachments to be stored with their org document
(setq org-attach-id-dir "attachments/")

(after! org-agenda
  (setq org-agenda-include-diary t))


;; Insert org headings at point, not after the current subtree
(after! org (setq org-insert-heading-respect-content nil))
;; Enable logging of done task, and logg stuff in the logbock drawer by default
(after! org
  (setq org-log-done t)
  (setq org-log-into-drawer t))


(use-package org-pomodoro
  :ensure t
  :commands (org-pomodoro)
  :config
  (setq
   alert-user-configuration (quote ((((:category . "org-pomodoro")) libnotify nil)))
   ))

(defun yf/pomodoro-bar ()
  "Produce the string for the current pomodoro counter to display on the menu bar"
  (let ((prefix (cl-case org-pomodoro-state
                  (:pomodoro "Pomodoro")
                  (:overtime "Overtime")
                  (:short-break "Break")
                  (:long-break "Long Break"))))
    (if (and (org-pomodoro-active-p) (> (length prefix) 0))
        (list prefix (org-pomodoro-format-seconds)) "N/A")))

;; Org roam capture templates
(setq org-roam-capture-templates
      '(("m" "main" plain
         "%?"
         :if-new (file+head "main/${slug}.org"
                            "#+title: ${title}\n")
         :immediate-finish t
         :unnarrowed t)
        ("r" "reference" plain "%?"
         :if-new
         (file+head "reference/${title}.org" "#+title: ${title}\n")
         :immediate-finish t
         :unnarrowed t)
        ))
(defun zz/org-reformat-buffer ()
  (interactive)
  (when (y-or-n-p "Really format current buffer? ")
    (let ((document (org-element-interpret-data (org-element-parse-buffer))))
      (erase-buffer)
      (insert document)
      (goto-char (point-min)))))


;; Org journal stuff
(setq org-journal-file-type 'monthly)
(setq org-journal-start-on-weekday t)
(setq org-extend-today-until 4)
(setq org-journal-file-format "%Y_%m_%d.org")
(setq org-journal-date-format "%A, %Y-%m-%d ")
(setq org-journal-dir
      (cond
       ((and (string-equal system-type "gnu/linux")
             (file-exists-p "/mnt/c"))
        "/mnt/c/Users/yamifrankc/code/orgmode/journal")
       (t "~/code/orgmode/journal"))) ; Default org directory



;; ORG MODERN
;;(use-package! org-modern
;;:hook (org-mode . org-modern-mode)
;;:config
;; Customize `org-modern` settings here, if needed
;;(setq org-modern-star '("◉" "○" "◈" "◇" "⁕") ;; example for bullets
;;    org-modern-hide-stars nil)




;; Function to refile stuff
(defun yf/refile-tasks-in-mass (status target-file target-heading)
  "Refile tasks with a specified STATUS from the current org buffer to a TARGET-FILE and place under TARGET-HEADING."
  (interactive
   (list (completing-read "Select task status: " '("DONE" "HALT" "NO" "KILL"))
         (read-file-name "Select target file: ")
         (read-string "Enter target heading in target file: ")))
  (when (yes-or-no-p (format "Refile all %s tasks to %s under heading \"%s\"? " status target-file target-heading))
    (save-excursion
      (goto-char (point-min))
      (let ((count 0))
        (while (re-search-forward (concat "^\\*+ " status " ") nil t)
          (let ((current-heading (org-element-at-point)))
            (org-cut-subtree) ;; Cut the subtree for the selected task status
            (with-current-buffer (find-file-noselect target-file)
              (goto-char (point-min))
              ;; Search for the target heading
              (if (re-search-forward (concat "^\\*+ " (regexp-quote target-heading)) nil t)
                  (progn
                    (org-end-of-subtree t t)
                    (org-paste-subtree)
                    (setq count (1+ count))
                    (save-buffer))
                (message "Heading \"%s\" not found in %s" target-heading target-file))))))
      (message "Refiled %d tasks with status %s to %s under heading \"%s\"" count status target-file target-heading))))


;; Org static blog
(require 'org-static-blog)

(defun my-org-static-blog-mailto-comments (post-title)
  "Generate a mailto: link for comments with the POST-TITLE as the subject."
  (format "mailto:blog@yamifrankc.com?subject=Re: %s"
          (url-hexify-string (org-static-blog-get-title post-title))))


(use-package org-static-blog
  :ensure t
  :config
  (setq org-static-blog-publish-title "A CAN Blog")
  (setq org-static-blog-publish-url "https://orgblogtest.netlify.app")
  (setq org-static-blog-publish-directory "~/org/blog/output")
  (setq org-static-blog-posts-directory "~/org/blog/posts/")
  (setq org-static-blog-drafts-directory "~/org/blog/drafts/")
  (setq org-static-blog-enable-tags t)
  (setq org-static-blog-enable-og-tags t)
  (setq org-static-blog-enable-tag-rss t)

  ;;(setq org-static-blog-post-comments "You like this? Then tomaaaaa")
  (setq org-static-blog-post-comments
        (lambda (post-title)
          (my-org-static-blog-mailto-comments post-title)))
  ;;(setq org-static-blog-page-postamble "Caca")
  (setq org-static-blog-index-file "indice.html")
  (setq org-static-blog-page-header
        "<meta name=\"author\" content=\"John Dow\">
<meta name=\"referrer\" content=\"no-referrer\">
<meta name=\"viewport\" content=\"initial-scale=1,width=device-width,minimum-scale=1\">
<link href= \"static/style.css\" rel=\"stylesheet\" type=\"text/css\" />
<link rel=\"icon\" href=\"static/favicon.ico\">")
  )

;; Astro Stuff
(use-package! astro-ts-mode
  :after treesit-auto)

(use-package! astro-ts-mode
  :after treesit-auto
  :init
  (when (modulep! +lsp)
    (add-hook 'astro-ts-mode-hook #'lsp! 'append))
  :config
  (global-treesit-auto-mode)
  (let ((astro-recipe (make-treesit-auto-recipe
                       :lang 'astro
                       :ts-mode 'astro-ts-mode
                       :url "https://github.com/virchau13/tree-sitter-astro"
                       :revision "master"
                       :source-dir "src")))
    (add-to-list 'treesit-auto-recipe-list astro-recipe)))

(set-formatter! 'prettier-astro
  '("npx" "prettier" "--parser=astro"
    (apheleia-formatters-indent "--use-tabs" "--tab-width" 'astro-ts-mode-indent-offset))
  :modes '(astro-ts-mode))

;;;; ----------------
;;;;
;; WEB MODE
(use-package web-mode
  :ensure t)

;; ASTRO
(define-derived-mode astro-mode web-mode "astro")
(setq auto-mode-alist
      (append '((".*\\.astro\\'" . astro-mode))
              auto-mode-alist))

;; EGLOT
(use-package eglot
  :ensure t
  :config
  (add-to-list 'eglot-server-programs
               '(astro-mode . ("astro-ls" "--stdio"
                               :initializationOptions
                               (:typescript (:tsdk "./node_modules/typescript/lib")))))
  :init
  ;; auto start eglot for astro-mode
  (add-hook 'astro-mode-hook 'eglot-ensure))
