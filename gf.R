## 1) خواندن مختصات، زمان و باد سطحی از datagf

lon_datagf  <- ncvar_get(datagf, "lon")
lat_datagf  <- ncvar_get(datagf, "lat")
time_datagf <- ncvar_get(datagf, "time")
ws_gf       <- ncvar_get(datagf, "sfcWind")   # ابعاد: space × time (مثلاً 75 × N)

# کنترل ابعاد
dim(ws_gf)
length(time_datagf)

## 2) تبدیل time → تاریخ، با استفاده از units داخل فایل

time_units_gf <- ncatt_get(datagf, "time", "units")$value
print(time_units_gf)
# مثلاً: "days since 1850-01-01"

# جدا کردن واحد و مبدأ از رشته‌ی units
parts_gf   <- strsplit(time_units_gf, " since ")[[1]]
time_unit_gf  <- parts_gf[1]   # "days" یا "hours" یا "seconds"
origin_str_gf <- parts_gf[2]   # مثلاً "1850-01-01"

origin_gf <- as.POSIXct(paste0(origin_str_gf, " 00:00:00"), tz = "UTC")

# ضریب تبدیل بر اساس واحد
mult_gf <- switch(time_unit_gf,
                  "days"    = 86400,
                  "day"     = 86400,
                  "hours"   = 3600,
                  "hour"    = 3600,
                  "seconds" = 1,
                  "second"  = 1,
                  1)

dates_gf <- origin_gf + time_datagf * mult_gf
dates_gf <- as.Date(dates_gf)

## 3) میانگین روی بعد مکانی برای هر زمان → سری زمانی آینده

# ws_gf: [space, time] = [nspace, ntime]
ws_gf_mean <- colMeans(ws_gf, na.rm = TRUE)  # یا apply(ws_gf, 2, mean, na.rm = TRUE)

length(ws_gf_mean)  # باید = length(time_datagf)
length(dates_gf)    # باید = length(time_datagf)

## 4) ساختن دیتافریم سری زمانی آینده

df_gf <- data.frame(
  date = dates_gf,
  ws   = ws_gf_mean
)

head(df_gf)
summary(df_gf$ws)

## 5) بستن فایل
nc_close(datagf)
