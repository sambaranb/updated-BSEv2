
The new standalone SSE/BSE as of 18 November 2024

Dr. Sambaran Banerjee, University of Bonn, Germany
sambaran@astro.uni-bonn.de
sambaran.banerjee@gmail.com

Including suggestions from Dr. Aleksandra Olejak, Max Planck Institut fuer Astrophysik (MPA), Garching
aolejak@MPA-Garching.mpg.de
---------------------------------------------------

New ingredients are being added to make SSE/BSE at par with
the latest, 'state-of-the-art' population synthesis programs. 
A batch of new features have been added in the version that accompanies
the paper S. Banerjee, et al., A&A 639, A41 (2020).  
https://doi.org/10.1051/0004-6361/201935332

This version contains additional extensions, as described in the paper
by S. Banerjee and A. Olejak, "On effective spin - mass ratio
'Xeff-q' relation of binary black hole mergers evolved in isolation".
Please refer to the description in the paper and the source code 
for the details. This file describes the usage of the additional input
parameters in BSE that are required to run this version.
For the other parameters, refer to the file 'README_2020.txt'
and the description in 'bse.f'. All the extensions in the 2020
version are available in this version as well. 

If you use this version for your work, please acknowledge the authors
and/or cite the above papers.

Input/Output:
To facilitate inclusion in wrappers and scripts and on-the-fly data processing,
this BSE version reads the input parameters from the standard input (STDIN)
and outputs the detailed evolutionary data and the summary information
in the standard output (STDOUT). The default file-based I/O of SSE
remains the same.

The format of the input (to be read from STDIN, e.g., via a UNIX pipe) is as follows:
 
mass0(1) mass0(2) tphysf tb kstar(1) kstar(2) z ecc
neta bwind hewind wconst alpha1 lambda
ceflag tflag ifflag wdflag bhflag nsflag mxns idum
psflag kmech ecflag edflag wrflag
pts1 pts2 pts3
sigma beta xi acc2 epsnov ftzacc fmrg eddfac gamma
dtp qcr0 FA hgflag

wconst <= 1

Wind fudge factor. Use wconst = 1 for the full/default BSE stellar wind.
wconst < 1 will reduce the wind proportionally.

bhflag = 2/3/4

2: BH birth spin according to the 'Geneva' model of Belczynski et al., A&A, 636, A104 (2020) (Be20)
3: BH birth spin according to the 'MESA' model of Be20
4: Zero BH birth spin (Fuller and Ma model)

psflag = 1/0/-1

1: PPSN/PSN schemes according to Belczynski et al., 2016, A&A 594, A97. (B16-PPSN/PSN) 
0: No PPSN/PSN 
-1: Woosley (2017) PPSN/PSN model as described in Spera M., Mapelli M., 2017, MNRAS, 470, 4739
and Giacobbo N., Mapelli M., Spera M., 2018, MNRAS, 474, 2959

edflag: 1/0

1: Wind Eddington factor ON. Wind mass loss includes the Eddington factor as of
Giacobbo, N., Mapelli, M., and Spera M., MNRAS 474, 2959–2974 (2018); their MOBSE-1 mode.

0: Wind Eddington Factor OFF. Wind mass loss according to the prescription of
Belczynski et al., ApJ, 714, 1217 (2010) (MOBSE-2 mode).

wrflag: 0/1/2/3/4

Natal spin of BH formed from a tidally spun-up Wolf-Rayet (WR) star

0: Disabled. BH birth spin always according to the choice of 'bhflag' (see above)
1: Belczynski et al. 2020 (Be20) BH spin-up model, standard approach (without spin-up check)
2: Belczynski et al. 2020 (Be20) BH spin-up model including spin-up check
3: Bavera et al. 2021 (Ba21) BH spin-up model including spin-up check
4: Bavera et al. 2021 (Ba21) BH spin-up model, standard approach (without spin-up check)

ftzacc <= 1

Thorne-Zytkow accretion fraction: fraction of mass accreted onto the BH
during a BH-star merger

fmrg <= 1

Fraction of mass lost during a star-star merger

dtp

output interval (Myr) of the evolutionary data
dtp = 0 implies output at every time step

qcr0

>=0: BSE's default q_crit (maximum/critical mass ratio for stable mass transfer) recipe
< 0: q_crit set to MOD(qcr0)

FA <= 1

Mass accretion efficiency during star-star mass transfer.
FA = 1: BSE's default mass transfer
FA < 1: more non-conservative mass transfer

hgflag

>=0: common envelope evolution is allowed for Hertzsprung-gap donors (BSE default; 'optimistic CE')  
< 0: CE evolution is disallowed for HG-gap donors ('pessimistic CE')

Please report any bugs. Suggestions are most welcome. 

Have fun!
