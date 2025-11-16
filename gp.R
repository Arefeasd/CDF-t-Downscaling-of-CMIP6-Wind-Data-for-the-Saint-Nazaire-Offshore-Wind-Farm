# 2) خواندن مختصات و زمان و متغیر باد سطحی
lon_datagp  <- ncvar_get(datagp, "lon")
lat_datagp  <- ncvar_get(datagp, "lat")
range(lon_datagp)
range(lat_datagp)


time_datagp <- ncvar_get(datagp, "time")
ws_gp       <- ncvar_get(datagp, "sfcWind")   # dim باید 75 x 240 باشد

dim(ws_gp)          # برای کنترل
length(time_datagp) # انتظار: 240

# 3) تبدیل time -> تاریخ، بر اساس units در فایل
time_units_gp <- ncatt_get(datagp, "time", "units")$value
print(time_units_gp)
# معمولاً چیزی مثل "days since 1850-01-01" است

# استخراج unit و origin از رشته‌ی units
parts      <- strsplit(time_units_gp, " since ")[[1]]
time_unit  <- parts[1]   # مثلا "days"
origin_str <- parts[2]   # مثلا "1850-01-01"

origin_gp <- as.POSIXct(paste0(origin_str, " 00:00:00"), tz = "UTC")

mult <- switch(time_unit,
               "days"    = 86400,
               "day"     = 86400,
               "hours"   = 3600,
               "hour"    = 3600,
               "seconds" = 1,
               "second"  = 1,
               1)

dates_gp <- origin_gp + time_datagp * mult
dates_gp <- as.Date(dates_gp)

# 4) میانگین روی بعد مکانی برای هر زمان → سری زمانی
#   ws_gp: [space, time] = [75, 240]
ws_gp_mean <- colMeans(ws_gp, na.rm = TRUE)  # یا apply(ws_gp, 2, mean, na.rm = TRUE)

length(ws_gp_mean)  # باید = 240
length(dates_gp)    # باید = 240

# 5) ساختن دیتافریم سری زمانی
df_gp <- data.frame(
  date = dates_gp,
  ws   = ws_gp_mean
)

head(df_gp)
summary(df_gp$ws)

# 6) بستن فایل
nc_close(datagp)