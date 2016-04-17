if (TRUE&FALSE) {
  5
}else if (TRUE) {
6
}

stopifnot(is.raw(source))

> switch(2,"red","green","blue")
[1] "green"

> switch(1,"red","green","blue")
[1] "red"