# 2) گرفتن مختصات و زمان
lon_obsrp  <- ncvar_get(obsrp, "longitude")
lat_obsrp  <- ncvar_get(obsrp, "latitude")
range(lon_obsrp)
range(lat_obsrp)

time_obsrp <- ncvar_get(obsrp, "valid_time")

# 3) گرفتن میدان‌های u10 و v10
u10 <- ncvar_get(obsrp, "u10")
v10 <- ncvar_get(obsrp, "v10")

# الان u10 و v10 آرایه سه‌بعدی هستند: lon × lat × time

# 4) محاسبهٔ سرعت باد در هر سلول و هر زمان
ws_array <- sqrt(u10^2 + v10^2)

# 5) میانگین گرفتن روی همه سلول‌های باکس برای هر زمان
# (یعنی برای هر ماه یک عدد متوسط)
ws_obsrp <- apply(ws_array, 3, mean, na.rm = TRUE)

# 6) تبدیل time به تاریخ
time_units_obsrp <- ncatt_get(obsrp, "valid_time", "units")$value
print(time_units_obsrp)

origin_obsrp <- as.POSIXct("1970-01-01 00:00:00", tz = "UTC")
dates_obsrp  <- origin_obsrp + time_obsrp
dates_obsrp  <- as.Date(dates_obsrp)


# 7) بستن فایل
nc_close(obsrp)

# 8) ساختن دیتافریم ساده
df_obsrp <- data.frame(date = dates_obsrp, ws = ws_obsrp)

# چک اولیه
head(df_obsrp)
summary(df_obsrp$ws)
