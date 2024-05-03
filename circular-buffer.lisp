(defstruct circ
  buffer
  size
  (read 0)
  (write 0)
  (length 0))

(defun new-circ (size)
  (make-circ :buffer (make-array size
                                 :initial-element nil)
             :size size
             :read 0
             :write 0
             :length 0))

(defun write-to (circ num)
  (let* ((cur-write (circ-write circ))
         (next-write (mod (1+ cur-write)
                          (circ-size circ))))
    (unless (>= (circ-length circ)
                (circ-size circ))
      (setf (aref (circ-buffer circ)
                  cur-write)
            num)
      (setf (circ-write circ)
            next-write)
      (incf (circ-length circ)))))

(defun read-from (circ)
  (let ((cur-read (circ-read circ)))
    (unless (= (circ-length circ) 0)
      (setf (circ-read circ)
            (mod (1+ cur-read)
                 (circ-size circ)))
      (decf (circ-length circ))
      (aref (circ-buffer circ) cur-read))))
;; demonstration
(defun fill-buffer (circ)
  (let ((x 1))
    (loop while (write-to circ x)
          do (setf x (1+ x)))))

(defun read-buffer (circ)
  (let ((result (read-from circ)))
    (loop while result
          do (print result)
          (setf result (read-from circ)))))










