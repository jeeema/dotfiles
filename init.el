;; init.el --- My init.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; My init.el.

;;; Code:

;; global-map bindings
(keymap-global-unset "<insert>")		; ミスって発動するのがうざすぎる
(keymap-global-set "M-<delete>" 'kill-word)
(keymap-global-set "<mouse-8>" 'previous-buffer)
(keymap-global-set "<mouse-9>" 'next-buffer)
(keymap-global-set "C-M-d" 'kill-sexp)
(keymap-global-unset "C-M-k")
(keymap-global-set "M-j" 'eval-print-last-sexp)
(keymap-global-unset "C-j")
(find-function-setup-keys)							; find-functionにキーを割り当てる

;;WSLのEmacsでコピペがうまくいかないので追加の設定
;;http://cha.la.coocan.jp/wp/2023/12/02/post-925/
(if (featurep 'pgtk)
    ; you need to install "wl-clipboard" first
    (if (and (zerop (call-process "which" nil nil nil "wl-copy"))
             (zerop (call-process "which" nil nil nil "wl-paste")))
        ;; credit: yorickvP on Github
        (progn
          (setq wl-copy-process nil)
          (defun wl-copy (text)
            (setq wl-copy-process (make-process :name "wl-copy"
                                                :buffer nil
                                                :command '("wl-copy" "-f" "-n")
                                                :connection-type 'pipe))
            (process-send-string wl-copy-process text)
            (process-send-eof wl-copy-process))
          (defun wl-paste ()
            (if (and wl-copy-process (process-live-p wl-copy-process))
                nil ; should return nil if we're the current paste owner
              (shell-command-to-string "wl-paste -n | tr -d \r")))
          (setq interprogram-cut-function 'wl-copy)
          (setq interprogram-paste-function 'wl-paste)
          )
      ))

;; help-mode
(use-package help-mode
	:bind (:map help-mode-map
				("<mouse-8>" . 'help-go-back)
				("<mouse-9>" . 'help-go-forward)))

;; this enables this running method
;; emacs -q -l ~/.debug.emacs.d/init.el
(eval-and-compile
	(when (or load-file-name byte-compile-current-file)
		(setq user-emacs-directory
			  (expand-file-name
			   (file-name-directory (or load-file-name byte-compile-current-file))))))

; https://a.conao3.com/blog/2024/7c7c265/ から拝借
(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")))
  (package-initialize)
  (use-package leaf :ensure t)

  (leaf leaf-keywords
    :ensure t
    :init
    (leaf blackout :ensure t)
    :config
    (leaf-keywords-init)))

(leaf leaf-convert
	:doc "Convert many format to leaf format"
	:ensure t)

(leaf leaf-tree
	:ensure t
	:custom ((imenu-list-size . 30)
			 (imenu-list-position . 'left)))

;; ここにleafによる設定を書く

;;source:https://qiita.com/conao3/items/347d7e472afd0c58fbd7#%E4%BE%BF%E5%88%A9%E3%83%91%E3%83%83%E3%82%B1%E3%83%BC%E3%82%B8%E3%81%AE%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB
(leaf macrostep
	:ensure t
	:bind (("C-c e" . macrostep-expand)))

;;Emacsの標準添付パッケージ

;;leafの :custom で設定するとinit.elにcustomが勝手に設定を追記します。この状況になると、変数の二重管理になってしまうので、customがinit.elに追記しないように設定します。

;;(自分)上のQiita記事の「変数の変更について」の節を読むに、どうもこの設定をするとEmacsのGUIで行なった変更を保存する (メニューバー>Options>Save Options) と custom.el に変更が書き込まれるようになるが、加えてこの設定によって custom.el がロードされないようになるので、結局GUIで行った変更が反映されなくなるようだ
;;(自分)同じ影響を受けるのは Options に限らず、メニューバーからアクセスできる Customize Emacs から行った変更もそうかもしれない
;;(自分)そもそも、EmacsのCustomizeという仕組みの本体が下のcus-という一群の標準パッケージな気がする。おそらくメニューバーで操作したときもこのcus-editパッケージとかが動いているんだと思う
(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

;;EmacsのC言語部分で定義されている変数をcustomで扱えるようにまとめているファイルです。 私の設定を書いておくので、取捨選択して頂ければと思います。変数の説明は F1 v で確認できます。 無効にしているGUI要素についてはコメントアウトしておきました。
(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :preface
  (defun c/redraw-frame nil
    (interactive)
    (redraw-frame))

  :bind (("M-ESC ESC" . c/redraw-frame))
  :custom '((user-full-name . "")
						(user-mail-address . "")
            (user-login-name . "")
            (create-lockfiles . nil)
            (debug-on-error . t)
            (init-file-debug . t)
            (frame-resize-pixelwise . t)
            (enable-recursive-minibuffers . t)
            (history-length . 1000)
            (history-delete-duplicates . t)
            (scroll-preserve-screen-position . t)
            (scroll-conservatively . 100)
            (mouse-wheel-scroll-amount . '(1 ((control) . 5)))
            (ring-bell-function . 'ignore)
            (text-quoting-style . 'straight)
            (require-final-newline . t) ; 保存時にファイル末尾に改行を追加
            (truncate-lines . t)
						;; (use-dialog-box . nil)
						;; (use-file-dialog . nil)
						(cua-mode . t)
            (window-divider-mode . t)
            (window-divider-default-places . 'right-only) ; window-divider を水平分割にのみ表示
            (menu-bar-mode . nil)
            (tab-bar-mode . t)
            (tool-bar-mode . nil)
            (scroll-bar-mode . nil)
						(pixel-scroll-precision-mode . t)
            (line-number-mode . nil)    ; モードラインに行数を表示しない
            (column-number-mode . t)    ; モードラインに列数を表示
            (indent-tabs-mode . t)     ; タブはタブで
            (tab-width . 2)
            (lisp-body-indent . 2)
						)
  :config
  (defalias 'yes-or-no-p 'y-or-n-p)
  (keyboard-translate ?\C-h ?\C-?)
  )

(leaf display-line-numbers
	:doc "interface for display-line-numbers"
	:tag "builtin"
	:added "2025-04-27"
	:hook prog-mode-hook
	:custom (display-line-numbers-type . 'relative)) ; 今いる行からの相対行数を表示

;;Emacsの外でファイルが書き変わったときに自動的に読み直すマイナーモードです。 もちろん、Emacsで編集している場合は外の変更で上書きされることはありません。
(leaf autorevert
	:doc "revert buffers when files on disk change"
	:tag "builtin"
	:custom ((auto-revert-interval . 1))
	:global-minor-mode global-auto-revert-mode)

;;kill-ringの数を制御したり、kill-lineの挙動を変更したりします。
(leaf simple
	:doc "basic editing commands for Emacs"
	:tag "builtin" "internal"
	:custom ((kill-ring-max . 100)
			 (kill-read-only-ok . t)
			 (kill-whole-line . t)
			 (eval-expression-print-length . nil)
			 (eval-expression-print-level . nil)))

;;Emacsで好みが分かれる設定として、バックアップファイルを開いているファイルと同じディレクトリに作成するという挙動があります。単にdisableするのではなく、バックアップファイルを一箇所に集めることでバックアップのメリットを享受しつつ、バックアップファイルが散らばるのを防ぎます。
(leaf files
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :custom `((auto-save-timeout . 15)
            (auto-save-interval . 60)
            (auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                        (,tramp-file-name-regexp . nil)))
            (version-control . t)
            (delete-old-versions . t)))

;;自動保存されたファイルのリストです。 .emacs.d/backup 以下にまとめて保存するようにします。
(leaf startup
  :doc "process Emacs shell arguments"
  :tag "builtin" "internal"
  :custom `((auto-save-list-file-prefix . ,(locate-user-emacs-file "backup/.saves-"))))

;; 現在行を強調する
(leaf hl-line
  :doc "highlight the current line"
  :tag "builtin"
  :added "2025-04-21"
  :custom (global-hl-line-sticky-flag . nil) ; ハイライトするのはアクティブなウィンドウでだけ
  :global-minor-mode global-hl-line-mode)

;; view-mode
;; https://syohex.hatenablog.com/entry/20110114/1294958917
(leaf view
  :doc "peruse file or buffer without editing"
  :tag "builtin"
  :added "2025-04-21"
  :bind (:view-mode-map
	 ("N" . 'View-search-last-regexp-backward)
	 ("?" . 'View-search-regexp-backward))
  :custom (view-read-only . t) ; read-only-mode) (C-x C-q) を有効にした時に自動で view-mode も有効にする
  )

(leaf recentf
  :doc "keep track of recently opened files"
  :tag "builtin"
  :added "2025-04-21"
  :custom (recentf-max-saved-items . 1024) ;; 1024ファイルまで履歴保存する
  (recentf-auto-cleanup . 'never)  ;; 存在しないファイルは消さない
  (recentf-exclude . '("/recentf" "COMMIT_EDITMSG" "/.?TAGS" "^/sudo:" "/\\.emacs\\.d/games/*-scores" "/\\.emacs\\.d/\\.cask/"))
  ;; (recentf-auto-save-timer . (run-with-idle-timer 30 t 'recentf-save-list))
  :config (recentf-mode t))

(leaf savehist
  :doc "Save minibuffer history"
  :tag "builtin"
  :added "2025-04-21"
  :custom `((savehist-file . ,(locate-user-emacs-file "savehist")))
  :global-minor-mode t)

(leaf desktop
  :doc "save partial status of Emacs when killed"
  :tag "builtin"
  :added "2025-04-01"
  :init (desktop-save-mode))

(leaf treesit
  :doc "tree-sitter utilities"
  :tag "builtin" "languages" "tree-sitter" "treesit"
  :added "2025-04-08"
  :custom
  (treesit-language-source-alist . '((bash "https://github.com/tree-sitter/tree-sitter-bash")
																		 (c "https://github.com/tree-sitter/tree-sitter-c")
																		 (cpp "https://github.com/tree-sitter/tree-sitter-cpp")))
  (major-mode-remap-alist . '((c-mode . c-ts-mode)
															(sh-mode . bash-ts-mode)))
  (treesit-font-lock-level . 4))

(leaf eglot
	:doc "The Emacs Client for LSP servers"
	:tag "builtin"
	:added "2025-03-20"
	:hook   (sh-mode-hook . eglot-ensure)
	(bash-ts-mode-hook . eglot-ensure)
	(c-ts-mode-hook . eglot-ensure))

(leaf completion-preview
	:doc "Preview completion with inline overlay"
	:tag "builtin"
	:added "2025-03-20"
	:global-minor-mode global-completion-preview-mode)

(leaf which-key
  :doc "Display available keybindings in popup"
  :tag "builtin"
  :added "2025-04-21"
  :global-minor-mode t)

(electric-pair-mode +1)
(fido-vertical-mode +1)

(load-theme 'modus-vivendi)

;;ここまで Emacsの標準添付パッケージの設定

;; Code folding using treesit.el
(leaf treesit-fold
	:vc (:url "https://github.com/emacs-tree-sitter/treesit-fold")
	:ensure t
	:global-minor-mode global-treesit-fold-indicators-mode
	:custom (treesit-fold-line-count-show . t)
	(treesit-fold-line-count-format . "… %d lines …")
	(treesit-fold-indicators-fringe . 'right-fringe))

(leaf treemacs
	:doc "A tree style file explorer package"
	:req "emacs-26.1" "cl-lib-0.5" "dash-2.11.0" "s-1.12.0" "ace-window-0.9.0" "pfuture-1.7" "hydra-0.13.2" "ht-2.2" "cfrs-1.3.2"
	:tag "emacs>=26.1"
	:url "https://github.com/Alexander-Miller/treemacs"
	:added "2025-04-21"
	:emacs>= 26.1
	:ensure t
	:bind (
				 ("C-S-t" . treemacs)						; orig. transpose-chars
				 )
	:after ace-window pfuture hydra cfrs)

(leaf eglot-booster
	:vc (:url "https://github.com/jdtsmith/eglot-booster")
	:ensure t
	:after eglot
	:config (eglot-booster-mode))

;; SKK
(leaf ddskk
	:ensure t
	:custom (skk-kutouten-type . 'en))	; 日本語での句読点を全角ピリオドと全角コンマに (他のオプションは変数 skk-kuten-touten-alist を評価したら見られるよ)

;; カラースキーム
;; (leaf nord-theme
;; 	:ensure t
;; 	:custom (nord-region-highlight . "snowstorm") ; Use `nord4` from Nord's "Snow Storm" palette as background color.
;; 	:config
;; 	(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/themes/"))
;; 	(load-theme 'nord t)
;; 	)

;; (leaf solarized-theme
;; 	:doc "The Solarized color theme"
;; 	:req "emacs-24.1"
;; 	:tag "solarized" "themes" "convenience" "emacs>=24.1"
;; 	:url "http://github.com/bbatsov/solarized-emacs"
;; 	:added "2025-04-08"
;; 	:emacs>= 24.1
;; 	:ensure t
;; 	:config
;; 	(load-theme 'solarized-dark t)

;; Copied from https://a.conao3.com/blog/2024/7c7c265/
(leaf consult
	:doc "Consulting completing-read"
	:req "emacs-28.1" "compat-30"
	:tag "completion" "files" "matching" "emacs>=28.1"
	:url "https://github.com/minad/consult"
	:added "2025-03-19"
	:emacs>= 28.1
	:ensure t
	:preface
  (defun c/consult-line (&optional at-point)
    "Consult-line uses things-at-point if set C-u prefix."
    (interactive "P")
    (if at-point
        (consult-line (thing-at-point 'symbol))
      (consult-line)))
	:bind (
				 ("C-x b" . consult-buffer)			 ; orig. switch-to-buffer
				 ("M-g g" . consult-goto-line)	 ; orig. goto-line
         ("M-g M-g" . consult-goto-line) ; orig. goto-line
				 ("C-s" . c/consult-line)				 ; orig. isearch-forward
				 )
	:init
	:after compat)

(leaf marginalia
  :doc "Enrich existing commands with completion annotations"
  :ensure t
  :global-minor-mode t)

(leaf corfu
  :doc "COmpletion in Region FUnction"
  :req "emacs-28.1" "compat-30"
  :tag "text" "completion" "matching" "convenience" "abbrev" "emacs>=28.1"
  :url "https://github.com/minad/corfu"
  :added "2025-03-20"
  :emacs>= 28.1
  :ensure t
  :init (global-corfu-mode)
  :after compat)

(leaf puni
	:doc "Parentheses Universalistic"
	:req "emacs-26.1"
	:tag "tools" "lisp" "convenience" "emacs>=26.1"
	:url "https://github.com/AmaiKinono/puni"
	:added "2025-03-19"
	:emacs>= 26.1
	:ensure t
	:init (puni-global-mode)
	:bind (puni-mode-map
         ;; default mapping
         ;; ("C-M-f" . puni-forward-sexp)
         ;; ("C-M-b" . puni-backward-sexp)
         ;; ("C-M-a" . puni-beginning-of-sexp)
         ;; ("C-M-e" . puni-end-of-sexp)
         ;; ("M-)" . puni-syntactic-forward-punct)
         ;; ("C-M-u" . backward-up-list)
         ;; ("C-M-d" . backward-down-list)
				 ("C-)" . puni-slurp-forward)
				 ;; ("C-}" . puni-barf-forward)
				 ;; ("M-(" . puni-wrap-round)
				 ;; ("M-s" . puni-splice)
				 ;; ("M-r" . puni-raise)
				 ;; ("M-U" . puni-splice-killing-backward)
				 ;; ("M-z" . puni-squeeze)
				 ))

;; (use-package smartparens
;; 	:bind (:map smartparens-mode-map
;; 				("C-<up>" . 'sp-up-sexp)
;; 				("C-<down>" . 'sp-down-sexp)
;; 				("M-<up>" . 'sp-backward-up-sexp)
;; 				("M-<down>" . 'sp-backward-down-sexp)
;; 				;; ("" . 'sp-next-sexp)
;; 				;; ("" . 'sp-previous-sexp)
;; 				("C-M-t" . 'sp-transpose-sexp)
;; 				;; ("" . 'sp-transpose-hybrid-sexp)

;; 				("C-M-d" . 'sp-kill-sexp)
;; 				("C-M-<backspace>" . 'sp-backward-kill-sexp)
;; 				;; ("C-M-w" . 'sp-copy-sexp)

;; 				("C-<delete>" . 'sp-unwrap-sexp)
;; 				("C-<backspace>" . 'sp-backward-unwrap-sexp)

;; 				("C-)" . 'sp-forward-slurp-sexp)
;; 				("C-M-)" . 'sp-forward-barf-sexp)
;; 				("C-(" . 'sp-backward-slurp-sexp)
;; 				("C-M-(" . 'sp-backward-barf-sexp)

;; 				;; ("M-D" . 'sp-splice-sexp)
;; 				;; ("C-M-<delete>" . 'sp-splice-sexp-killing-forward)
;; 				;; ("" . 'sp-splice-sexp-killing-backward)
;; 				;; ("" . 'sp-splice-sexp-killing-around)

;; 				;; ("C-]" . 'sp-select-next-thing-exchange)
;; 				;; ("C-<left_bracket>" . 'sp-select-previous-thing)
;; 				;; ("C-M-]" . 'sp-select-next-thing)

;; 				("C-S-f" . 'sp-forward-symbol)
;; 				("C-S-b" . 'sp-backward-symbol)

;; 				;; ("C-\"" . 'sp-change-inner)
;; 				;; ("M-i" . 'sp-change-enclosing)
;; 				)
;; 	)

(leaf rainbow-delimiters
	:doc "Highlight brackets according to their depth"
	:tag "tools" "lisp" "convenience" "faces"
	:url "https://github.com/Fanael/rainbow-delimiters"
	:added "2025-04-28"
	:ensure t
	:hook prog-mode-hook)

(leaf indent-bars
	:doc "Highlight indentation with bars"
	:req "emacs-27.1" "compat-29.1"
	:tag "convenience" "emacs>=27.1"
	:url "https://github.com/jdtsmith/indent-bars"
	:added "2025-04-27"
	:emacs>= 27.1
	:ensure t
	:after compat
	:hook ((c-ts-mode-hook bash-ts-mode-hook) . indent-bars-mode)
	:custom ((indent-bars-no-descend-lists . t) ; n)o extra bars in continued func arg lists
					 (indent-bars-treesit-support . t)
					 ; (indent-bars-display-on-blank-lines . t)
					 (indent-bars-treesit-ignore-blank-lines-types . '("module"))))

(leaf magit
	:doc "A Git porcelain inside Emacs"
	:req "emacs-26.1" "compat-30.0.0.0" "dash-2.19.1" "magit-section-4.1.2" "seq-2.24" "transient-0.7.8" "with-editor-3.4.2"
	:tag "vc" "tools" "git" "emacs>=26.1"
	:url "https://github.com/magit/magit"
	:added "2024-12-06"
	:emacs>= 26.1
	:ensure t
	:after compat magit-section with-editor)

(leaf open-junk-file
	:doc "Open a junk (memo) file to try-and-error"
	:tag "tools" "convenience"
	:url "http://www.emacswiki.org/cgi-bin/wiki/download/open-junk-file.el"
	:added "2023-05-06"
	:ensure t
	)

(leaf lispxmp
	:doc "Automagic emacs lisp code annotation"
	:tag "convenience" "lisp"
	:url "http://www.emacswiki.org/cgi-bin/wiki/download/lispxmp.el"
	:added "2023-05-06"
	:ensure t
	:config
	(keymap-set emacs-lisp-mode-map "C-c C-d" 'lispxmp))

(leaf find-file-in-project
	:doc "Find file/directory and review Diff/Patch/Commit efficiently"
	:req "emacs-25.1"
	:tag "convenience" "project" "emacs>=25.1"
	:url "https://github.com/redguardtoo/find-file-in-project"
	:added "2023-06-05"
	:emacs>= 25.1
	:ensure t
	:custom (ffip-use-rust-fd . t))

(leaf auctex
	:doc "Integrated environment for *TeX*"
	:req "emacs-27.1"
	:tag "preview-latex" "doctex" "context" "texinfo" "latex" "tex" "emacs>=27.1"
	:url "https://www.gnu.org/software/auctex/"
	:added "2025-05-16"
	:emacs>= 27.1
	:ensure t)

(leaf graphviz-dot-mode
	:doc "Mode for the dot-language used by graphviz (att)."
	:req "emacs-25.0"
	:tag "att" "graphs" "graphviz" "dotlanguage" "dot-language" "dot" "mode" "emacs>=25.0"
	:url "https://ppareit.github.io/graphviz-dot-mode/"
	:added "2023-08-08"
	:emacs>= 25.0
	:ensure t
	:custom ((graphviz-dot-indent-width . 2)
					 (graphviz-dot-preview-extension . "svg") ;https://github.com/ppareit/graphviz-dot-mode/issues/75
					 )
	:config
	(add-hook 'graphviz-dot-mode-hook 'company-mode))

;; Markdown
(leaf markdown-mode
	:doc "Major mode for Markdown-formatted text"
	:req "emacs-27.1"
	:tag "itex" "github flavored markdown" "markdown" "emacs>=27.1"
	:url "https://jblevins.org/projects/markdown-mode/"
	:added "2023-08-09"
	:emacs>= 27.1
	:ensure t
	:custom (markdown-command . '("pandoc" "--from=markdown" "--to=html5")))

;; CSV
(leaf csv-mode
	:doc "Major mode for editing comma/char separated values"
	:req "emacs-27.1" "cl-lib-0.5"
	:tag "convenience" "emacs>=27.1"
	:url "https://elpa.gnu.org/packages/csv-mode.html"
	:added "2024-11-25"
	:emacs>= 27.1
	:ensure t)

;; Gnuplot
(leaf gnuplot
  :doc "Major-mode and interactive frontend for gnuplot"
  :req "emacs-25.1"
  :tag "plotting" "gnuplot" "data" "emacs>=25.1"
  :url "https://github.com/emacs-gnuplot/gnuplot"
  :added "2025-03-21"
  :emacs>= 25.1
  :ensure t
	:mode ("\\.gp$" "\\.plt$")
	:init (autoload 'gnuplot-mode "gnuplot" "Gnuplot major mode" t)
	(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot-mode" t)
	;; :config (add-to-list 'Info-default-directory-list "/usr/share/info/gnuplot.info.gz") ; For gnuplot-info-lookup-symbol to work (コメントアウトしても大丈夫だった．普通の場所にInfoファイルが置かれているから自動で見つけてくれているのだろう，知らんけど)
	)

(leaf cmake-mode
	:doc "Major-mode for editing CMake sources"
	:req "emacs-24.1"
	:tag "emacs>=24.1"
	:added "2025-04-17"
	:emacs>= 24.1
	:ensure t)

;;Coq の設定

(leaf proof-general
	:doc "A generic front-end for proof assistants (interactive theorem provers)"
	:req "emacs-24.5"
	:tag "emacs>=24.5"
	:added "2021-05-09"
	:url "https://proofgeneral.github.io/"
	:emacs>= 24.5
	:ensure t)

(leaf company-coq
	:doc "A collection of extensions for Proof General's Coq mode"
	:req "cl-lib-0.5" "dash-2.12.1" "yasnippet-0.11.0" "company-0.8.12" "company-math-1.1"
	:tag "languages" "convenience"
	:added "2021-05-09"
	:url "https://github.com/cpitclaudel/company-coq"
	:ensure t
	:hook (coq-mode-hook))

;;Clojureの設定
(leaf clojure-mode
	:doc "Major mode for Clojure code"
	:req "emacs-25.1"
	:tag "lisp" "clojurescript" "clojure" "languages" "emacs>=25.1"
	:added "2022-06-25"
	:url "http://github.com/clojure-emacs/clojure-mode"
	:emacs>= 25.1
	:ensure t
	:config
	(add-hook 'clojure-mode-hook #'cider-mode))

(leaf cider
	:doc "Clojure Interactive Development Environment that Rocks"
	:req "emacs-26" "clojure-mode-5.14" "parseedn-1.0.6" "queue-0.2" "spinner-1.7" "seq-2.22" "sesman-0.3.2"
	:tag "cider" "clojure" "languages" "emacs>=26"
	:url "http://www.github.com/clojure-emacs/cider"
	:added "2022-06-26"
	:emacs>= 26
	:ensure t)

;;フォントの設定
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "HackGen Console NF" :foundry "PfEd" :slant normal :weight regular :height 188 :width normal)))))

(add-to-list 'default-frame-alist '(fullscreen . maximized)) ;起動時フレームを全画面化
(add-to-list 'default-frame-alist '(cursor-type . bar))		 ;カーソルを縦棒に

(provide 'init)

(server-start)

;; Local Variables:
;; End:

;;; init.el ends here
