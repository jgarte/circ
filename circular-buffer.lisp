(defstruct circ
  buffer
  size
  (read 0)
  (write 0))

(defun new-circ (size)
  (make-circ :buffer (make-array size
                                 :initial-element nil)
             :size (1+ size)
             :read 0
             :write 0))

(defun write-to (circ num)
  (let* ((cur-write (circ-write circ))
         (next-write (mod (1+ cur-write)
                          (circ-size circ))))
    (unless (= next-write (circ-read circ))
      (setf (aref (circ-buffer circ)
                  cur-write)
            num)
      (setf (circ-write circ)
            next-write))))

(defun read-from (circ)
  (let ((cur-read (circ-read circ)))
    (unless (= cur-read (circ-write circ))
      (setf (circ-read circ)
            (mod (1+ cur-read)
                 (circ-size circ)))
      (aref (circ-buffer circ) cur-read))))
;; demonstration
(defun fill-buffer (circ)
  (let ((x (circ-write circ)))
    (loop while (write-to circ x)
          do (setf x (1+ x)))))

(defun read-buffer (circ)
  (let ((result (read-from circ)))
    (loop while result
          do (print result))))










