;;; packages.el --- spacemacs-solidity layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Ran Xing <p749227@C02X4C53JG5H>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.  ;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `spacemacs-solidity-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `spacemacs-solidity/init-PACKAGE' to load and initialize the package.
;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `spacemacs-solidity/pre-init-PACKAGE' and/or
;;   `spacemacs-solidity/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst spacemacs-solidity-packages
  '((solidity-mode :location (recipe
                               :fetcher github
                               :repo "lemontreeran/emacs-solidity"))
    company
    company-solidity
    flycheck)
  "The list of Lisp packages required by the spacemacs-solidity layer.

Each entry is either:
1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun spacemacs-solidity/init-company ()
  (use-package company
    :init
    :config
    (add-hook 'after-init-hook 'global-company-mode))
    )
;;激活自动补全))

(defun spacemacs-solidity/init-solidity-mode ()
  (use-package solidity-mode
    :defer t
    :init
    (progn
      (setq solidity-comment-style 'slash)
      (add-to-list 'auto-mode-alist
                   '("\\.sol\\'" . solidity-mode))
      ;; (add-hook 'solidity-mode-hook
	    ;;           (lambda ()
	    ;;             (set (make-local-variable 'company-backends)
		  ;;                  (append '((company-solidity company-capf company-dabbrev-code))
			;;                          company-backends))))
      )
    :config
    (spacemacs/set-leader-keys-for-major-mode 'solidity-mode
      "g" #'solidity-estimate-gas-at-point)
    (define-key solidity-mode-map (kbd "C-c C-g") 'solidity-estimate-gas-at-point)))



(when (configuration-layer/layer-usedp 'auto-completion)
  (defun spacemacs-solidity/post-init-company ()
    (with-eval-after-load 'company
      (spacemacs|add-company-backends
       :backends (company-files company-solidity company-capf company-dabbrev-code)
       :modes solidity-mode
       :variables
       company-minimum-prefix-length 1)))
  ;; (push '(company-files company-sourcekit) company-backends-swift-mode)
  )

(defun spacemacs-solidity/init-company-solidity ()
  (use-package company-solidity
    ;; :defer t
    :ensure t
    ;; :after (company)
    ))

(defun spacemacs-solidity/post-init-flycheck ()
  (spacemacs/add-flycheck-hook 'solidity-mode))
;;; packages.el ends here
