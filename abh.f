      real*8 FUNCTION abh(mwr,porb,kw)
*
********
*     BH dimensionless spin as a function
*     of WR mass mwr [Msun] and orbital period porb [day]
*     kw is the stellar type of the BH progenitor
*     mwr and porb are at He-depletion (kw=7) or C-depletion (kw>7).
*     mwr and porb are to be recorded just before the type change (currently
*     done in evolv1.f and evolv2.f).
*     Reference: Bavera, Zevin, & Fragos arXiv:2105.09077 (AAS Research Notes) 
********
*
      implicit none
*
      integer kw
      real*8 mwr, porb, lp
      real*8 ca1, ca2, ca3, cb1, cb2, cb3, alpha, beta
      real*8 func1
      external func1
*
      abh = 0.0d0
*
      if(kw.lt.7.or.kw.gt.9) goto 90
*
      if(kw.eq.7)then
         ca1 = 0.059305d0
         ca2 = 0.035552d0
         ca3 = 0.270245d0
         cb1 = 0.026960d0
         cb2 = 0.011001d0
         cb3 = 0.420739d0
      else
         ca1 = 0.051237d0
         ca2 = 0.029928d0
         ca3 = 0.282998d0
         cb1 = 0.027090d0
         cb2 = 0.010905d0
         cb3 = 0.422213d0
      endif
*
      if(porb.le.1.0d0)then
         lp = DLOG10(porb)
         alpha = func1(mwr,ca1,ca2,ca3)
         beta = func1(mwr,cb1,cb2,cb3)
         abh = alpha*(lp**2) + beta*lp
      endif
*
 90   return
      END
*
*
*
      real*8 FUNCTION func1(m,c1,c2,c3)
*
********
*     Fitting function as defined in
*     Bavera, Zevin, & Fragos arXiv:2105.09077 (AAS Research Notes)
********
* 
      real*8 m, c1, c2, c3, x, y
*
      x = c3*m
      y = c2 + DEXP(-x)
      func1 = (-c1)/y
*
      return
      END
