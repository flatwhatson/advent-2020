((nil

  (eval . (with-eval-after-load 'flycheck-guile
            (make-local-variable 'flycheck-guile-args)
            (add-to-list 'flycheck-guile-args "--r7rs" 'append)))

  (eval . (with-eval-after-load 'geiser-guile
            (make-local-variable 'geiser-guile-binary)
            (unless (listp geiser-guile-binary)
              (setq geiser-guile-binary (list geiser-guile-binary)))
            (add-to-list 'geiser-guile-binary "--r7rs" 'append)))

  (eval . (with-eval-after-load 'geiser-guile
            (if-let* ((root-dir (locate-dominating-file
                                   default-directory ".dir-locals.el"))
                      (root-dir (directory-file-name
                                 (expand-file-name root-dir))))
              (make-local-variable 'geiser-guile-load-path)
              (add-to-list 'geiser-guile-load-path root-dir))))
  ))
