library(lubridate)

library(dplyr)

hist_start <- as.Date("1980-01-01")
hist_end   <- as.Date("1999-12-31")


obs_hist <- df_obsrp %>%
  mutate(
    year  = year(date),
    month = month(date)
  )

gp_hist <- df_gp %>%
  mutate(
    year  = year(date),
    month = month(date)
  )

head(obs_hist)
head(gp_hist)



hist_join <- inner_join(
  obs_hist %>% select(year, month, ws_obs = ws),
  gp_hist  %>% select(year, month, ws_gp  = ws),
  by = c("year", "month")
)

nrow(hist_join)
head(hist_join)

hist_join <- hist_join %>%
  mutate(date_month = as.Date(paste(year, month, "01", sep = "-"))) %>%
  arrange(date_month)

gf_fut <- df_gf %>%
  arrange(date)

head(gf_fut)
tail(gf_fut)
nrow(gf_fut)
range(gf_fut$date)


ObsRp  <- hist_join$ws_obs   # مشاهدات محلی در دورهٔ مرجع
DataGp <- hist_join$ws_gp    # GCM historical در دورهٔ مرجع
DataGf <- gf_fut$ws          # GCM «آینده» 2000–2014

length(ObsRp)    # مثلاً 240
length(DataGp)   # باید برابر با ObsRp
length(DataGf)   # طول آینده، مثلاً 180 (15 سال × 12 ماه)


install.packages("CDFt")   # فقط یک‌بار
library(CDFt)

res_cdft <- CDFt(ObsRp, DataGp, DataGf)

str(res_cdft)


ws_fut_bc <- res_cdft$DS   # سری آیندهٔ bias-corrected

length(ws_fut_bc)   # باید = length(gf_fut$ws)
length(gf_fut$ws)

df_gf_bc <- data.frame(
  date = gf_fut$date,  # همان تاریخ‌های 2000–2014
  ws   = ws_fut_bc     # سرعت باد downscaled
)



head(df_gf_bc)
summary(df_gf_bc$ws)

library(ggplot2)

df_plot_fut <- data.frame(
  date = gf_fut$date,
  gp_raw = gf_fut$ws,
  gp_bc  = ws_fut_bc
)

ggplot(df_plot_fut, aes(x = date)) +
  geom_line(aes(y = gp_raw), linetype = "dashed") +
  geom_line(aes(y = gp_bc))


x   <- res_cdft$x
FRp <- res_cdft$FRp
FGp <- res_cdft$FGp
FGf <- res_cdft$FGf
FRf <- res_cdft$FRf

plot(x, FGp, type = "l", lty = 2, ylim = c(0, 1), xlab = "ws", ylab = "CDF")
lines(x, FGf, lty = 2, col = 2)
lines(x, FRp)
lines(x, FRf, col = 2)
legend("bottomright",
       legend = c("GCM hist", "GCM fut", "Obs hist", "Downscaled fut CDF"),
       lty = c(2, 2, 1, 1),
       col = c(1, 2, 1, 2),
       bty = "n")


ds_val <- res_cdft$DS
dates_gf <- df_gf$date   # تاریخ‌هایی که از CMIP6 برای این دوره داری

df_downscaled <- data.frame(
  date = dates_gf,
  ws_ds = ds_val
)
head(df_downscaled)
tail(df_downscaled)



library(dplyr)
library(lubridate)

down_scaled <- df_downscaled %>%
  mutate(
    year  = year(date),
    month = month(date)
  )

obs_val <- df_obsval %>%
  mutate(
    year  = year(date),
    month = month(date)
  )

val_join <- inner_join(
  down_scaled %>% select(year, month, ws_ds = ws_ds),
  obs_val     %>% select(year, month, ws_obs = ws),
  by = c("year", "month")
)

MAE  <- val_join %>% summarise(mae  = mean(abs(ws_ds - ws_obs))) %>% pull(mae)
RMSE <- val_join %>% summarise(rmse = sqrt(mean((ws_ds - ws_obs)^2))) %>% pull(rmse)

MAE
RMSE


cdf_ds  <- ecdf(df_downscaled$ws_ds)
cdf_obs <- ecdf(df_obsval$ws)
ks <- ks.test(df_downscaled$ws_ds, df_obsval$ws)
ks$statistic   # مقدار KS
ks$p.value     # p-value


install.packages("cramer")
library(cramer)

cvm_res <- cramer.test(df_downscaled$ws_ds, df_obsval$ws)
cvm_res

