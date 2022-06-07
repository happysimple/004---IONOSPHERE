# GIM TEC数据详解

## 1.数据下载

网站1:[https://cddis.nasa.gov/Data_and_Derived_Products/GNSS/atmospheric_products.html#iono](https://cddis.nasa.gov/Data_and_Derived_Products/GNSS/atmospheric_products.html#iono)

网站2(FTP): [http://ftp.aiub.unibe.ch/CODE/ ](http://ftp.aiub.unibe.ch/CODE/)

codg0010.22i.Z文件即为GIM TEC文件，文件名为codg0010.22i，表明这是2022年001天的数据。

## 2.数据详解

<img src="..\_static\001.png" alt="1" style="zoom:100%;" />

在文件内部，也可以看到时间信息，见上图红框。其次，该文件的时间分辨率为1h，见上图红框。

---

<img src="..\_static\002.png" alt="1" style="zoom:100%;" />

如上图，将下文的数据乘以0.1才能得到真正的TEC数据。

---

<img src="..\_static\003.png" alt="1" style="zoom:100%;" />

上图首先指明了该数据是2022年01月01日00时00分00秒的，纬度依次是87.5°N、85.0°N、82.5°N，在87.5°N这条纬线上，经度范围为-180°至180°，间隔为5°，因此，在这条纬线上有73条数据。

---

<img src="..\_static\004.png" alt="1" style="zoom:100%;" />

前半部分是TEC数据，如上图

---

<img src="..\_static\005.png" alt="1" style="zoom:100%;" />

后半部分是RMS数据，如上图





