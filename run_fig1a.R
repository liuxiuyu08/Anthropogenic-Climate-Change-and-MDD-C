
# Usage: Rscript run_fig1a.R analysis_ready.rds results

library_path <- Sys.getenv("MDD_R_LIBRARY")
if (nzchar(library_path)) .libPaths(c(library_path, .libPaths()))
suppressPackageStartupMessages({library(data.table); library(fixest)})
setFixest_nthreads(4L)
args <- commandArgs(trailingOnly = TRUE)
if (!length(args)) stop("Usage: Rscript run_fig1a.R analysis_ready.rds [output_directory]")
d <- as.data.table(if (grepl("\\.rds$", args[1], ignore.case = TRUE)) {
  readRDS(args[1])
} else {
  fread(args[1], showProgress = FALSE)
})
output_dir <- if (length(args) >= 2L) args[2] else "results"
stopifnot(nrow(d) == 245272L)

formula <- mddyngchld ~
  temp_mean_1y_std + c_precip_sum_1y_std + c_er_pct95_81_1y_std +
  c_cwd_1_b30_h_std + kidagemo_std + kidsex + urban + hheadsexhh +
  toilettype + drinkwtr + educlvl + wealthq + GRIProaddist_std +
  pop_density_std + citycenter_std + HAND_std + prop_lt5m_std |
  country^intyear + country^monthint

required <- unique(c(all.vars(formula), "gid_1"))
stopifnot(all(required %in% names(d)), all(complete.cases(d[, ..required])))
model <- feols(formula, data = d, cluster = ~gid_1, notes = FALSE)
stopifnot(nobs(model) == 245272L, uniqueN(d$country) == 32L,
          uniqueN(d$gid_1) == 601L, !length(model$collin.var))

coefficients <- as.data.table(coeftable(model), keep.rownames = "term")
setnames(coefficients, names(coefficients),
         c("term", "estimate", "std_error", "t_value", "p_value"))
ci <- confint(model, level = 0.95)
coefficients[, `:=`(ci_low = ci[term, 1], ci_high = ci[term, 2],
                    observations = nobs(model), countries = uniqueN(d$country),
                    adm1_clusters = uniqueN(d$gid_1))]

figure_terms <- c("c_precip_sum_1y_std", "c_er_pct95_81_1y_std", "temp_mean_1y_std")
fig1a <- coefficients[match(figure_terms, term)]
fig1a[, climate_variable := c("Annual total precipitation", "Extreme precipitation (R95p)",
                              "Mean temperature")]
fig1a[, `:=`(estimate_pp = 100 * estimate, ci_low_pp = 100 * ci_low,
             ci_high_pp = 100 * ci_high)]
setcolorder(fig1a, c("climate_variable", "term", "estimate_pp", "ci_low_pp", "ci_high_pp",
                    setdiff(names(fig1a), c("climate_variable", "term", "estimate_pp", "ci_low_pp", "ci_high_pp"))))

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
fwrite(coefficients, file.path(output_dir, "main_model_coefficients.csv"))
fwrite(fig1a, file.path(output_dir, "fig1a_results.csv"))
capture.output(summary(model), file = file.path(output_dir, "main_model_summary.txt"))
print(fig1a[, .(climate_variable, estimate_pp, ci_low_pp, ci_high_pp, p_value)])
