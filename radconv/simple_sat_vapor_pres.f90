
module simple_sat_vapor_pres_mod

!-----------------------------------------------------------------------
!
!                 simple saturation vapor pressure 
!
!      routines for computing the saturation vapor pressure (es) and
!      the derivative of es with respect to temperature
!
!      uses a simple formula based on constant latent heat
!
!-----------------------------------------------------------------------
!
!                               usage
!                               -----
!
!                       call lookup_es  (temp,es)
!
!                       call lookup_des (temp,des)
!
!    arguments
!    ---------
!      temp    intent in       temperature in degrees kelvin
!      es      intent out      saturation vapor pressure in Pascals
!      des     intent out      derivative of saturation vapor pressure
!                              with respect to temperature (Pascals/degree)
!
!-----------------------------------------------------------------------

! use        fms_mod, only:  write_version_number,   &
!                            error_mesg, FATAL

 use      constants_mod, only:  hlv,rvgas, latent_heat, &
                                cp_vapor, cp_water


implicit none
!private

! public :: lookup_es, lookup_des
! public :: escomp, descomp ! for backward compatibility
                           ! use lookup_es, lookup_des instead

!-----------------------------------------------------------------------
 interface lookup_es
   module procedure lookup_es_0d, lookup_es_1d, lookup_es_2d, lookup_es_3d
 end interface
! for backward compatibility (to be removed soon)
 interface escomp
   module procedure lookup_es_0d, lookup_es_1d, lookup_es_2d, lookup_es_3d
 end interface
!-----------------------------------------------------------------------
 interface lookup_des
   module procedure lookup_des_0d, lookup_des_1d, lookup_des_2d, lookup_des_3d
 end interface
! for backward compatibility (to be removed soon)
 interface descomp
   module procedure lookup_des_0d, lookup_des_1d, lookup_des_2d, lookup_des_3d
 end interface
!-----------------------------------------------------------------------
!  cvs version and tag name

character(len=128) :: version = '$Id: simple_sat_vapor_pres.f90,v 1.6 2002/07/16 22:56:58 fms Exp $'
character(len=128) :: tagname = '$Name: havana $'

!-----------------------------------------------------------------------
! module variables


! constants used in formula:
 real(8), parameter :: T0 = 273.16,      &   ! K
                    e0 = 611 !610.78           ! Pa

contains

!#######################################################################

 subroutine lookup_es_0d ( temp, esat )

 real(8), intent(in)  :: temp
 real(8), intent(out) :: esat

!-----------------------------------------------

 !esat = e0 * exp( -hlv/rvgas*(1.0/temp-1.0/T0))

esat = e0* exp(-hlv / rvgas &
           *(1./temp - 1./T0)) &
           * exp((cp_vapor - cp_water)/rvgas * (T0/temp -1.)) &
           * (temp/T0)**((cp_vapor - cp_water)/rvgas)
!-----------------------------------------------

 end subroutine lookup_es_0d

!#######################################################################

 subroutine lookup_es_1d ( temp, esat )

 real(8), intent(in)  :: temp(:)
 real(8), intent(out) :: esat(:)

!-----------------------------------------------

 !esat = e0 * exp( -hlv/rvgas*(1.0/temp-1.0/T0))

esat = e0* exp(-hlv / rvgas &
           *(1./temp - 1./T0)) &
           * exp((cp_vapor - cp_water)/rvgas * (T0/temp -1.)) &
           * (temp/T0)**((cp_vapor - cp_water)/rvgas)

!-----------------------------------------------

 end subroutine lookup_es_1d

!#######################################################################

 subroutine lookup_es_2d ( temp, esat )

 real(8), intent(in)  :: temp(:,:)
 real(8), intent(out) :: esat(:,:)

!-----------------------------------------------

! esat = e0 * exp( -hlv/rvgas*(1.0/temp-1.0/T0))

esat = e0* exp(-hlv / rvgas &
           *(1./temp - 1./T0)) &
           * exp((cp_vapor - cp_water)/rvgas * (T0/temp -1.)) &
           * (temp/T0)**((cp_vapor - cp_water)/rvgas)

!-----------------------------------------------

 end subroutine lookup_es_2d

!#######################################################################

 subroutine lookup_es_3d ( temp, esat )

 real(8), intent(in)  :: temp(:,:,:)
 real(8), intent(out) :: esat(:,:,:)

!-----------------------------------------------

! esat = e0 * exp( -hlv/rvgas*(1.0/temp-1.0/T0))

esat = e0* exp(-hlv / rvgas &
           *(1./temp - 1./T0)) &
           * exp((cp_vapor - cp_water)/rvgas * (T0/temp -1.)) &
           * (temp/T0)**((cp_vapor - cp_water)/rvgas)

!-----------------------------------------------

 end subroutine lookup_es_3d

!#######################################################################
!  routines for computing derivative of es
!#######################################################################

 subroutine lookup_des_0d ( temp, desat )

 real(8), intent(in)  :: temp
 real(8), intent(out) :: desat

!-----------------------------------------------

real(8) :: esat, latent
call escomp(temp, esat)
call latent_heat(temp, latent)
desat = latent /  (rvgas * temp**2) * esat
!   desat =  e0*hlv/(rvgas*temp**2)*exp( -hlv/rvgas*(1.0/temp-1.0/T0))

!-----------------------------------------------

 end subroutine lookup_des_0d

!#######################################################################

 subroutine lookup_des_1d ( temp, desat )

 real(8), intent(in)  :: temp (:)
 real(8), intent(out) :: desat(:)

!-----------------------------------------------

 !  desat =  e0*hlv/(rvgas*temp**2)*exp( -hlv/rvgas*(1.0/temp-1.0/T0))

!-----------------------------------------------

 end subroutine lookup_des_1d

!#######################################################################

 subroutine lookup_des_2d ( temp, desat )

 real(8), intent(in)  :: temp (:,:)
 real(8), intent(out) :: desat(:,:)

!-----------------------------------------------
   
  ! desat =  e0*hlv/(rvgas*temp**2)*exp( -hlv/rvgas*(1.0/temp-1.0/T0))

!-----------------------------------------------

 end subroutine lookup_des_2d

!#######################################################################

 subroutine lookup_des_3d ( temp, desat )

 real(8), intent(in)  :: temp (:,:,:)
 real(8), intent(out) :: desat(:,:,:)

!-----------------------------------------------

   !desat =  e0*hlv/(rvgas*temp**2)*exp( -hlv/rvgas*(1.0/temp-1.0/T0))


!-----------------------------------------------

 end subroutine lookup_des_3d

!#######################################################################

end module simple_sat_vapor_pres_mod

