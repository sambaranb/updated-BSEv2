***
      SUBROUTINE wrbh(ospin,jspin,forb,sep,mold,mnew,kwold,aspin,
     &                mode)
*
      implicit none
*
      INTEGER kwold, mode, kwsave
      REAL*8 ospin, jspin
      REAL*8 aspin, pspin, psec, aspin0, aspin1, y, pcrit
      REAL*8 forb, sep, mold, mnew, porb, psave, phems, prbhe
      REAL*8 twopi
      REAL*8 ohems, jhems, orbhe, mhems
      LOGICAL hems
      COMMON /VALU10/ ohems, jhems, orbhe, mhems, hems
      REAL*8 abh
      external abh
*
*     opsin = spin frequency of the BH's immediate
*             stellar progenitor [radian/year]
*
*     jspin = spin angular momentum of the BH's immediate
*             stellar progenitor [Msun Rsun^2 / year]
*
*     forb = orbital frequency of the pre-SN binary [radian/year]
*            (not used if single star or disrupted binary)
*
*     sep = semi-major-axis of the pre-SN binary [Rsun]
*            (<= 0 indicates single star or disrupted binary)
*     Note: wrbh needs to be called *before* 'sep' is updated
*           in 'kick.f' 
*
*     mold = mass of the BH's immediate stellar progenitor [Msun] 
* 
*     mnew = mass of the BH itself [Msun]
*
*     kwold = stellar type of the BH's immediate stellar progenitor
*
*     aspin = BH's Kerr parameter obtained from the assumed stellar
*              dynamo model (see 'kick.f')
*
*     Common imports from evolv1.f/evolv2.f (same units as above)
*     ohems = spin frequency of the He MS (naked helium) star at the last time step 
*             of the most recent He MS phase (kw=7)
*     jhems = spin angular momentum  - do -
*     mhems = mass - do -
*     orbhe = orbital frequency at the last time step 
*             of the most recent He MS phase (kw=7)
*     hems = true if a He MS phase is reached
*
      twopi = 2.d0*ACOS(-1.d0)
      aspin1 = aspin
*
*     Angular frequency (ospin,forb) to period [day/(2pi*radian)]
*     [year/(2pi*radian)]*[365 day/year] 
*
      pspin = (1.0d0/ospin)*twopi*365.24d0
      porb = (1.0d0/forb)*twopi*365.24d0
      psave = pspin
      kwsave = kwold
      if (sep.le.0.0d0.or.mode.gt.1) goto 50
      psave = porb
*
*     Belczynski et al. A&A 636, A104 (2020);
*     their Eqn. 15
      if (porb.lt.0.1d0.and.kwold.ge.7.and.kwold.le.9) then
          aspin1 = 1.0d0
      elseif (porb.ge.0.1d0.and.porb.le.1.3d0.and.
     &        kwold.ge.7.and.kwold.le.9) then
*
*     Period in seconds
*     [day]*[86400 sec/day]
          psec = porb*86400.0d0
*
          y = 0.1d0*(psec/4000.0d0-1.0d0)**1.1d0
          aspin1 = EXP(-y) + 0.125d0
          goto 70
      endif
*
 50   continue
*
      if(mode.eq.2.and.hems)then
          phems = (1.0d0/ohems)*twopi*365.24d0
          psave = phems
          kwsave = 7
*
*     Belczynski et al. A&A 636, A104 (2020);
*     their Eqn. 15 (single star mode; spin period = orbital period)
          if (phems.lt.0.1d0.and.kwold.ge.7.and.kwold.le.9) then
              aspin1 = 1.0d0
          elseif (phems.ge.0.1d0.and.phems.le.1.3d0.and.
     &            kwold.ge.7.and.kwold.le.9) then
*
*     Period in seconds
*     [day]*[86400 sec/day]
              psec = phems*86400.0d0
*
              y = 0.1d0*(psec/4000.0d0-1.0d0)**1.1d0
              aspin1 = EXP(-y) + 0.125d0
          endif
      endif
*
      if(mode.eq.3.and.hems)then
*
*     Bavera, Zevin, & Fragos arXiv:2105.09077 (AAS Research Notes)
*     See 'abh.f'
*
          phems = (1.0d0/ohems)*twopi*365.24d0
          prbhe = (1.0d0/orbhe)*twopi*365.24d0
          kwsave = 7
          pcrit = 1.2d0*prbhe
*
          write(6,*) "mode > 2: mwr [Msun] = ", mhems
*
          if(sep.gt.0.0d0.and.phems.le.pcrit
     &       .and.kwold.ge.7.and.kwold.le.9)then
*
*     Binary mode (ensure spinning up of the WR up to at least 1.2
*     times the orbital period; otherwise no spin up)
*
             psave = prbhe
             aspin1 = abh(mhems,prbhe,kwsave)
          elseif(sep.le.0.0d0.and.kwold.ge.7.and.kwold.le.9)then
*
*     Single star mode (spin period = orbital period)
*     (mainly for experiments)
*
             psave = phems 
             aspin1 = abh(mhems,phems,kwsave)
          endif
      endif
*
      if(mode.gt.3)then
*
*     Bavera, Zevin, & Fragos arXiv:2105.09077 (AAS Research Notes)
*     See 'abh.f'
*
          psave = porb
*
          write(6,*) "mode > 2: mwr [Msun] = ", mold
*
          if(sep.gt.0.0d0.and.kwold.ge.7.and.kwold.le.9)then
*
*     Simpler implementation Without spin up check - binary mode only
*
             aspin1 = abh(mold,porb,kwold)
          endif
      endif
*
 70   continue
*
      aspin0 = aspin
      aspin = MAX(aspin1,aspin)
*
      if (aspin.gt.aspin0) then
          write(6,*) "WRBH - BH spin-up! ",
     &"KW KW(ref) period(ref)[day] spin-BH-old spin-BH-new :",
     &    kwold, kwsave, psave, aspin0, aspin
      else
          write(6,*) "WRBH - no BH spin modification ",
     &"KW KW(ref) period(ref)[day] spin-BH-old spin-BH-new :",
     &    kwold, kwsave, psave, aspin0, aspin1
      endif

      RETURN
      END
***
