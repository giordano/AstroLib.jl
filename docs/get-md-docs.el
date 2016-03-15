;;; get-md-docs.el --- Extract Markdown documentation from source files.

;; Copyright (C) 2016 Mosè Giordano

;; get-md-docs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; get-md-docs is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with get-md-docs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
;; MA 02110-1301, USA.

;;; Code:

(defvar get-md-docs--docs-regexp "\"\"\"\\(\\(?:.\\|\n\\)*\\)\"\"\""
  "Regexp matching Markdown docstrings in Julia source files.")

(defvar get-md-docs--file-name-regexp "^include(\"\\([^\"\n]+\\)\")$"
  "Regexp matching names of files included in the project.")

(defun get-md-docs-on-file (file-name)
  "Extract Markdown docstring in file FILE-NAME."
  (with-current-buffer
      (find-file-noselect file-name t)
    (goto-char (point-min))
    (when (re-search-forward get-md-docs--docs-regexp nil t)
      ;; Demote sections for the online docs.
      (replace-regexp-in-string
       "^### \\([^#\n]*\\) ###$"
       "##### \\1 ####"
       (match-string-no-properties 1)))))

(defun get-md-docs-search-file (file-name)
  "Search in FILE-NAME files from which extract docstrings.

The real extraction is then done by `get-md-docs-on-file'."
  (let ((backup-inhibited backup-inhibited)
	file docs)
    (with-current-buffer
	(find-file-noselect (concat "../src/" file-name ".jl") t)
      (goto-char (point-min))
      (save-excursion
	(save-match-data
	  (while (re-search-forward get-md-docs--file-name-regexp nil t)
	    (setq
	     file (match-string-no-properties 1)
	     docs
	     (concat
	      docs
	      "\n### " (file-name-base file) " ###\n"
	      (get-md-docs-on-file file)))))))
    (with-current-buffer
	(find-file-noselect (concat file-name ".md") t)
      (setq backup-inhibited t)
      (erase-buffer)
      (insert docs)
      (delete-trailing-whitespace)
      (save-buffer))))

(defun get-md-docs ()
  "Extract all Mardown docstring and save to file."
  (dolist (file '("utils" "misc"))
    (get-md-docs-search-file file)))

;;; get-md-docs.el ends here
