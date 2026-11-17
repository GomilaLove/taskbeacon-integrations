# --- TaskBeacon: top of the script (base R only) ---
tb <- "https://taskbeacon.io/ping/YOUR-JOB-ADDRESS"
tb_log <- ""   # optional: this script's log file (e.g. Rscript job.R > job.log 2>&1); its last 20 lines go with a failure
tb_ping <- function(path = "") {
  old <- options(timeout = 10)   # wait at most 10 seconds (R's default is 60)
  on.exit(options(old))
  invisible(try(suppressWarnings(readLines(paste0(tb, path), warn = FALSE)), silent = TRUE))
}
tb_num <- function(x) utils::URLencode(format(x, scientific = FALSE, digits = 15, trim = TRUE), reserved = TRUE)
tb_tail <- function() {
  if (!nzchar(tb_log) || !file.exists(tb_log)) return("")
  text <- paste(utils::tail(readLines(tb_log, warn = FALSE), 20), collapse = "\n")
  if (nchar(text) > 700) text <- sub("^[^\n]*\n", "", substr(text, nchar(text) - 700, nchar(text)))
  paste0("&log=", utils::URLencode(text, reserved = TRUE))
}
tb_ping("/start")
tryCatch({
  # --- your code here ---
  df <- data.frame(x = 1:3)  # example data: replace with your own
}, error = function(e) {
  tb_ping(paste0("/fail?error=", utils::URLencode(substr(conditionMessage(e), 1, 200), reserved = TRUE), tb_tail()))
  stop(e)
})
# --- TaskBeacon: end of the script ---
tb_ping(paste0("?", "rows=", tb_num(nrow(df))))
