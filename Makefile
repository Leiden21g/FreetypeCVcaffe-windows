# DOWNLOADとINSTALLのフォルダ区切りは / を使うこと

!IF      ![ echo VisualStudioVersion = %VisualStudioVersion% | grep 15.0 ]
G="-GVisual Studio 15 2017 Win64"
!ELSE IF ![ echo VisualStudioVersion = %VisualStudioVersion% | grep 16.0 ]
G="-GVisual Studio 16 2019"
A=-Ax64
!ENDIF

!IF      ![ echo %INSTALL% | grep / -q ]
I=-DCMAKE_INSTALL_PREFIX=%INSTALL%
!ENDIF

B=-Tv140 $(G) $(A) $(I) .. && cmake --build . --target install --config
R=$(B) Release 2>&1 | tee -a build.log
D=$(B) Debug   2>&1 | tee -a build.log

build :
	title $(MAKEDIR) build
	rm -rf $* && mkdir $*
	cd $* && cmake $(R)

config :
	title $(MAKEDIR) build config
	mkdir -p build
	cd build && cmake  -Tv140 $(G) $(A) $(I) ..

all :
	rm -rf $* && mkdir $*
	title $(MAKEDIR) $* debug
	cd $* && cmake -DALL_BUILD=1 $(D)
	title $(MAKEDIR) $* release
	cd $* && cmake -DALL_BUILD=1 $(R)

Debug :
	rm -rf $* && mkdir $*
	title $(MAKEDIR) $* $*
	cd $* && cmake -DALL_BUILD=1 $(D)

Release :
	rm -rf $* && mkdir $*
	title $(MAKEDIR) $* $*
	cd $* && cmake -DALL_BUILD=1 $(R)

#  2>&1 | tee -a build.log
# PATH=$(PATH);\nonesuch

# all:
#    echo %%PATH%%