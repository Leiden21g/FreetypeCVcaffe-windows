# DOWNLOADとINSTALLのフォルダ区切りは / を使うこと

!IF      ![ echo VisualStudioVersion = %VisualStudioVersion% | grep 15.0 ]
G="-GVisual Studio 15 2017 Win64"
!ELSE IF ![ echo VisualStudioVersion = %VisualStudioVersion% | grep 16.0 ]
G="-GVisual Studio 16 2019"
A=-Ax64
!ENDIF

!IF [ echo %INSTALL% | grep % -q ]
I=-DCMAKE_INSTALL_PREFIX=%INSTALL%
!ELSE
I=-DCMAKE_INSTALL_PREFIX=$(MAKEDIR)Install
!ENDIF

C=2>&1 | tee -a build.log
B=-Tv140 $(G) $(A) $(I) $(MAKEDIR) $(C) && cmake --build . --target install --config

Quick: .phony
	title $(MAKEDIR) quick
	rm -rf $(MAKEDIR)$*
	mkdir $(MAKEDIR)$*
	cd $(MAKEDIR)$* && cmake $(B) Release $(C)

config: .phony
	title $(MAKEDIR)Quick config
	mkdir -p $(MAKEDIR)Quick
	cd $(MAKEDIR)Quick && cmake -Tv140 $(G) $(A) $(I) $(MAKEDIR) $(C) 

all: .phony
	rm -rf $* && mkdir $*
	title $(MAKEDIR) $* debug
	cd $* && cmake -DALL_BUILD=1 $(B) Debug $(C)
	title $(MAKEDIR) $* release
	cd $* && cmake -DALL_BUILD=1 $(B) Release $(C)

Debug: .phony
	title $(MAKEDIR)$*
	rm -rf $(MAKEDIR)$*
	mkdir $(MAKEDIR)$*
	cd $(MAKEDIR)$* && cmake -DALL_BUILD=1 $(B) $* $(C)

Release: .phony
	title $(MAKEDIR)$*
	rm -rf $(MAKEDIR)$* 
	mkdir $(MAKEDIR)$*
	cd $(MAKEDIR)$* && cmake -DALL_BUILD=1 $(B) $* $(C)

.phony:


#  2>&1 | tee -a build.log
# PATH=$(PATH);\nonesuch

# all:
#    echo %%PATH%%