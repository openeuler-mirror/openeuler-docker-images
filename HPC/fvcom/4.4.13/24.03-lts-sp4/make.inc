#/===========================================================================/
# FVCOM make.inc for openEuler 24.03-LTS + gfortran + OpenMPI
# Generated for building FVCOM 4.4.12 without PETSc.
# This mirrors the official build procedure: edit make.inc, then 'make'.
#---------------------------------------------------------------------------/

#========== TOPDIR ========================================================
           TOPDIR        = /fvcom/src
#========== INSTALLDIR =====================================================
            INSTALLDIR    = $(TOPDIR)/libs/install
#===========================================================================
# PREPROCESSOR OPTIONS FOR CPP
            DEF_FLAGS     = -P -traditional
#===========================================================================
# Library search paths
             LIBDIR       = -L/usr/local/lib -L/usr/local/lib64 -L/usr/lib64 -L/usr/lib
             INCDIR       = -I/usr/local/include -I/usr/include
#--------------------------------------------------------------------------
#       NETCDF OUTPUT      NETCDF IS REQUIRED TO COMPILE FVCOM
             IOLIBS       = -lnetcdff -lnetcdf -lhdf5_hl -lhdf5 -lz -lcurl -lm
             IOINCS       =
#--------------------------------------------------------------------------
#     JULIAN  (calendar calculation)
             DTLIBS       = -ljulian
             DTINCS       =
#--------------------------------------------------------------------------
#     METIS   (serial graphic partition, version 4 - pmetis)
             PARLIB       = -lmetis
             PARTLIBS     = -L/usr/local/lib
             PARTINCS     = -I/usr/local/include
#--------------------------------------------------------------------------
#     MODEL OPTIONS  (PETSc-dependent features are left disabled)
             FLAG_3       = -DWET_DRY
             FLAG_4       = -DMULTIPROCESSOR
             FLAG_8       = -DLIMITED_NO
             FLAG_10      = -DGCN
             FLAG_14      = -DRIVER_FLOAT
             FLAG_15      = -DMPDATA
             FLAG_28      = -DAIR_PRESSURE
             FLAG_44      = -DTVD
#--------------------------------------------------------------------------
#     COMPILER SETTINGS  (gfortran with MPI wrappers)
             COMPILER     = -DGFORTRAN
             CPP          = /usr/bin/cpp
             CC           = mpicc
             CXX          = mpicxx
             FC           = mpif90
             CFLAGS       = -O3
             DEBFLGS      =
             OPT          = -O3
#==========================================================================
            FFLAGS = $(DEBFLGS) $(OPT)
            CPPFLAGS = $(DEF_FLAGS) $(COMPILER)
            RANLIB = ranlib
            AR = ar rc
#--------------------------------------------------------------------------
#     CPP Preprocessing Flags
#--------------------------------------------------------------------------
           CPPARGS =  $(CPPFLAGS) $(DEF_FLAGS) $(FLAG_1) $(FLAG_2) \
   $(FLAG_3) $(FLAG_4) $(FLAG_5) $(FLAG_6)  \
   $(FLAG_7) $(FLAG_8) $(FLAG_9) $(FLAG_10) \
   $(FLAG_11) $(FLAG_12) $(FLAG_13) $(FLAG_14) \
   $(FLAG_15) $(FLAG_16) $(FLAG_17) $(FLAG_18) \
   $(FLAG_19) $(FLAG_20) $(FLAG_21) $(FLAG_22) \
   $(FLAG_23) $(FLAG_24) $(FLAG_25) $(FLAG_26) \
   $(FLAG_27) $(FLAG_28) $(FLAG_29) $(FLAG_30) \
   $(FLAG_31) $(FLAG_32) $(FLAG_33) $(FLAG_34) \
   $(FLAG_35) $(FLAG_36) $(FLAG_37) $(FLAG_38) \
   $(FLAG_39) $(FLAG_40) $(FLAG_41) $(FLAG_42) \
   $(FLAG_43) $(FLAG_44) $(FLAG_80) $(FLAG_411)
#--------------------------------------------------------------------------
#     Libraries
#--------------------------------------------------------------------------
            LIBS  = $(LIBDIR) $(CLIB) $(PARLIB) $(PARTLIBS) $(IOLIBS) $(DTLIBS) $(MPILIB)
            INCS  = $(INCDIR) $(IOINCS) $(PARTINCS)