
The new standalone SSE/BSE as of 25 December 2018

Sambaran Banerjee, University of Bonn, Germany
sambaran@astro.uni-bonn.de
sambaran.banerjee@gmail.com
---------------------------------------------------

New ingredients have been added to make SSE/BSE at par with
the latest, 'state-of-the-art' population synthesis programs. 
A few updates have been adopted from the public NBODY6/7 version of
SSE/BSE - it is mentioned when this is the case.
The rest of all the updates, as described below, are newly
implemented. The latter updates are also exported into a private
version of NBODY6/7. This private NBODY6/7 and this standalone
SSE/BSE are now fully parallel in terms of available
stellar-evolutionary recipes.

1. The new wind function:

The wind mass loss function 'mlwind' is updated to be fully
consistent with the wind model of
Belczynski, K. et al., 2010, ApJ, 714, 1217 (the B10 model).
Note that an updated wind function to include B10 is also
available with the public version of NBODY6/7, but the implementation
of the B10 wind is partly faulty in that routine. The present routine
is rewritten to rectify this and the resulting outcomes agree perfectly
with StarTrack which also uses the same wind model, for ZAMS masses
well beyond 100 Msun (Banerjee, S., Belczynski, K., et al. in prep.).

2. The new remnant-mass prescriptions:

In addition to the existing Belczynski et al. 2002 and 2008 remnant-mass
models (the 2008 model being dittoed from the public NBODY6/7 version of BSE),
the newer Fryer at al. 2012 rapid and delayed remnant-mass prescriptions
are adopted. In addition, the modification of BH masses due to
pulsational pair-instability supernova (PPSN) and pair-instability supernova (PSN),
according to the prescriptions of Belczynski et al. 2016, are adopted
(see below for the full references). These extensions
are implemented in the subroutine 'hrdiag'. The recipe for
the formation of electron-capture
supernova NSs (ECS-NS) are recruited from the public NBODY6/7 version
of 'hrdiag', which is also implemented according to
Belczynski et al. 2008. All these implementations are tested
extensively to agree perfectly with StarTrack ZAMS mass-remnant mass relations
(Banerjee, S., Belczynski, K., et al. in prep.). At present, these
prescriptions can be selected independently with three
flags in the input file (no recompilation is needed):

nsflag = 1/2/3/4

1: Remnant-mass prescription of Belczynski et al., 2002, ApJ, 572, 407. (original BSE model)
2: Remnant-mass prescription of Belczynski et al., 2008, ApJS, 174, 223. (B08 model)
3: Remnant-mass prescription of Fryer et al., 2012, ApJ, 749, 91. (F12-rapid model) 
4: Remnant-mass prescription of Fryer et al., 2012, ApJ, 749, 91. (F12-delayed model)

psflag = 1/0

1: PPSN/PSN schemes according to Belczynski et al., 2016, A&A 594, A97. (B16-PPSN/PSN) 
0: No PPSN/PSN 

ecflag = 1/0

1: ECS-NS formation according to Belczynski et al., 2008, ApJS, 174, 223.
0: No ECS-NS formation

3. The new natal-kick prescriptions:

The 'kick' routine has been updated to explicitly include natal kick reduction due
to fallback (the fallback amount and fraction being evaluated in 'hrdiag'
and transported to the 'kick' routine via a common block; the same is done
to transport the carbon-oxygen core mass that is required for the alternative kick
prescriptions - see below). In addition to
the standard, momentum-conserving kick, as in Belczynski et al. 2008,
three variants of the kick prescription, as recently proposed by Chris Fryer, have been incorporated
(Banerjee, S., Belczynski, K., et al. in prep.).
At present, the kick mechanisms can be selected with a flag in the input file
(no recompilation is needed):

kmech = 1/2/3/4

1: Standard, momentum-conserving kick of Belczynski et al., 2008, ApJS, 174, 223.
2: Convection-asymmetry-driven kick
3: Collapse-asymmetry-driven kick
4: Neutrino-emission-asymmetry-driven kick

Note: instead of the default mass-based identification of the ECS-NSs in the 'kick'
routine, a flag 'ECS' is now generated in 'hrdiag' upon an ECS-NS formation which
is then transported to 'kick' (again, via the common block) to identify ECS-NSs
and to give them smaller or zero kicks (by assigning ECSIG).

All these input flags are tested to function as intended. Feel free to report any bug.

4. Other changes/suggestions:

mix.f:
A parameter 'ftzacc' is defined in the header to specify the fraction of matter to
be accreted during a BH-MS merger. This corresponds to a minor update near
line 114. This is inspired by suggestions from Mirek Giersz and Abbas Askar.

comenv.f:
The 'ftzacc' parameter is introduced here too with a similar modification near
line 170.
Note: it is recommended to use the common-envelope (CE) efficiency parameter 'alpha1'=1
in the BSE input file 'binary.in'.

It is also highly recommended to use smaller input time step parameters in SSE/BSE
(Banerjee, S., Belczynski, K., et al. in prep.). A recommended set of values is
pts1=0.001, pts2=0.01, pts3=0.02.

To be parallel to the public NBODY6/7 version of BSE, the 100 Msun ceiling is removed
from both single-star and binary evolutions (commented out in hrdiag.f, star.f, evolv2.f).  

The star.f is slightly updated to be parallel to the public NBODY6/7 version.

A bash shell script 'init_fnl_new' is added that would facilitate obtaining ZAMS mass-remnant mass
relations from SSE for any case. (Make sure to change to the correct path for the SSE executable.)

The SSE input file 'evolve.in' has been slightly updated in format to accommodate the newer input flags:

File evolve.in:
mass,z,tphysf
neta,bwind,hewind,sigma
ifflag,wdflag,bhflag,nsflag,mxns,idum
psflag,kmech,ecflag
pts1,pts2,pts3

Similarly, the format of the BSE input file 'binary.in' is updated to:

File binary.in: 
mass0(1),mass0(2),tphysf,tb,kstar(1),kstar(2),z,ecc
neta,bwind,hewind,alpha1,lambda
ceflag,tflag,ifflag,wdflag,bhflag,nsflag,mxns,idum
psflag,kmech,ecflag
pts1,pts2,pts3
sigma,beta,xi,acc2,epsnov,eddfac,gamma

All of the above new updates are also incorporated in a private NBODY6/7 version of SSE/BSE with
essentially identical versions of the relevant subroutines. The kick.f of
NBODY6/7 is substantially different in implementation which is available
upon request.

At present, nsflag, psflag, kemch, ecflag, mxns,
alpha1 needs to be set in headers in NBODY6/7 and recompilation
is needed if they are to be changed. This will be amended in the
near future so that at least these and perhaps some additional SSE/BSE parameters
can be supplied from input to eliminate the need of recompiling every time.

Feel free to use it for your work. You can also adopt individual subroutines in your own
programs. In either case, please acknowledge Sambaran Banerjee, especially
if you use the 'mlwind.f', 'kick.f', or 'hrdiag.f' or adopt parts of these.

Please report any bugs. Your suggestions are most welcome. 

Have fun!
