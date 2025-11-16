# 2) گرفتن مختصات و زمان
lon_obsval  <- ncvar_get(obsval, "longitude")
lat_obsval  <- ncvar_get(obsval, "latitude")
time_obsval <- ncvar_get(obsval, "valid_time")

# 3) گرفتن میدان‌های u10 و v10
u10 <- ncvar_get(obsval, "u10")
v10 <- ncvar_get(obsval, "v10")

# الان u10 و v10 آرایه سه‌بعدی هستند: lon × lat × time

# 4) محاسبهٔ سرعت باد در هر سلول و هر زمان
ws_array <- sqrt(u10^2 + v10^2)

# 5) میانگین گرفتن روی همه سلول‌های باکس برای هر زمان
# (یعنی برای هر ماه یک عدد متوسط)
ws_obsval <- apply(ws_array, 3, mean, na.rm = TRUE)

# 6) تبدیل time به تاریخ
time_units_obsval <- ncatt_get(obsval, "valid_time", "units")$value
print(time_units_obsval)

origin_obsval <- as.POSIXct("1970-01-01 00:00:00", tz = "UTC")
dates_obsval  <- origin_obsval + time_obsval
dates_obsval  <- as.Date(dates_obsval)


# 7) بستن فایل
nc_close(obsval)

# 8) ساختن دیتافریم ساده
df_obsval <- data.frame(date = dates_obsval, ws = ws_obsval)

# چک اولیه
head(df_obsval)
summary(df_obsval$ws)
