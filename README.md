# 5G-Modulation-Technique
Analysis of different modulation techniques which could be used for the implementation of 5G


## OFDM vs FBMC
The power spectral density of the FBMC transmit signal is plotted to highlight the low out-of-band leakage.
Comparing the plots of the spectral densities for OFDM and FBMC schemes, FBMC has lower side lobes. This allows a higher utilization of the allocated spectrum, leading to increased spectral efficiency.

![image](https://user-images.githubusercontent.com/78743757/161910686-a80a8eba-c57d-4c3e-bb11-31c12bad158a.png)
![image](https://user-images.githubusercontent.com/78743757/161910698-3e6a24db-aea8-400c-a9b1-f51e1f074e48.png)
<br>
![image](https://user-images.githubusercontent.com/78743757/161910715-06deb222-283e-490b-8a20-f76c59d1ff51.png)
<br>
![image](https://user-images.githubusercontent.com/78743757/161910733-5b0962f1-436b-42d9-be69-67db62a9a5f2.png)

## OFDM vs UFMC
Comparing the plots of the spectral densities for OFDM and UFMC schemes, UFMC has lower side-lobes. This allows a higher utilization of the allocated spectrum, leading to increased spectral efficiency. UFMC also shows a slightly better PAPR.

![image](https://user-images.githubusercontent.com/78743757/161910893-54a2e659-5614-4f0a-8435-641e13759c58.png)
![image](https://user-images.githubusercontent.com/78743757/161910902-5563e819-c54e-4b7e-95b1-e2ec6c9d060f.png)
<br>
![image](https://user-images.githubusercontent.com/78743757/161910916-4d517295-2234-4414-a34b-86a5643c2a03.png)
<br>
![image](https://user-images.githubusercontent.com/78743757/161910932-198d6acc-5106-4f90-a67b-fd390d5d6dd7.png)
![image](https://user-images.githubusercontent.com/78743757/161910939-b43b9d80-0211-455a-ace2-588908cf225e.png)
<br>
![image](https://user-images.githubusercontent.com/78743757/161911038-6812abf7-0569-4955-9f24-17a1a166489b.png)

In the first constellation diagram, the symbols are highly concentrated towards the origin, which can lead to high amplitude noise. In the second constellation diagram, when an equalizer is used, the symbols are equally distributed around the ideal points of a 16QAM-based modulation technique.

## Conclusion
<p>
UFMC is considered advantageous in comparison to OFDM by offering higher spectral efficiency. Sub-band filtering has the benefit of reducing the guards between sub-bands and also reducing the filter length, which makes this scheme attractive for short bursts. UFMC is more potent to multi-user interference, provide higher spectral efficiency, greater performance in case of coordinated multipoint transmission. UFMC is able to deliver complex orthogonality by avoiding many traps and compared to FBMC it improves at short burst/low latency transmission scenarios. The waveforms associated with UFMC are promising and have shown the technique can be utilized for 5G wireless technologies. Filter Bank Multi Carrier modulation has recently gained attention as a potential solution to face the limitations of OFDM. In particular FBMC presents an improvement of the spectral efficiency and relaxes the strict synchronization constrains. It can be understood as just a modification of the general OFDM in which each of the different sub-carriers is filtered to minimize their side-lobes, and thus reduce interference among them and out-of-band effect of the global allocated bandwidth. GFDM should be understood as the alternative providing highest degree of flexibility, giving the possibility to modify it according to each situation requirements. However, this great flexibility makes one loose the complete control of the inbound emission, with a spectral efficiency also more relaxed in comparison to the rest of alternatives.
</p>
