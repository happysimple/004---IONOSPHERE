# COSMIC数据处理

## 1.质量控制

①$ne(i)$：第i个原始电子密度，$\overline{ne}(i)$：第i个平滑后的电子密度 (9点滑动平均),$MD$:电子密度平均偏差.
$$
MD=\sum\limits_{i=1}^N\frac{|ne(i)-\overline{ne}(i)|}{N\cdot\overline{ne}(i)}<0.1合格
$$

②

$$
\sigma=\sqrt{\frac{\sum\limits_{i=1}^N(ne(i)-\overline{ne}(i))^2}{N\cdot (NmF2)^2}}<0.05合格
$$

③

$$
h>hmF2时,\Delta_g=\frac{dne}{dh}<0合格
$$

④

$$
420km\le h \le 490km时,\Delta_l=\frac{dne}{dh}<0合格
$$

⑤ 

$$
文件读取：NmF2\ge 0
$$

⑥

$$
   文件读取：hmF2\ge 200km
$$

## 2.计算VTEC

①计算STEC
$$
STEC=trapz(MSL\_alt,ELEC\_dens)*10^{-7};
$$
②计算映射函数Mz

$z$为高度角的余角,$\alpha=0.9782，H_{ipp}=450km,R_E=6378.137km$

$$
\sin z^{'}=\frac{R_E\sin (\alpha z)}{R_E+H_{ipp}}
$$

$$
z=arccos\frac{\Delta h}{\sqrt{\Delta lon^2+\Delta lat^2+\Delta h^2}}
$$

$$
Mz=\frac{1}{cosz'}
$$

③计算VTEC

$$
VTEC=\frac{STEC}{Mz}
$$

## 3.参考文献

```latex
[1]王涵. FY-3C掩星电离层产品的反演、验证及其在偶发E层研究中的应用[D].武汉大学,2020.
```
