#crawler data


download.file("https://github.com/rwinlib/webp/archive/v0.5.0.zip", "lib.zip", quiet = TRUE)

unzip("lib.zip", exdir = "../windows")
unlink("lib.zip")