@echo off

call "%~dp0..\..\..\bin\setenv.bat"
set DIR_NAME=%~dp0

if "%1" == "clean" (
  cd %DIR_NAME%
  call mvn clean
  cd %CD%
) else (
	if "%1" == "compile" (
	    cd %DIR_NAME%
		call mvn compile
		cd %CD%
	) else (
		if "%1" == "package" (
		    cd %DIR_NAME%		
			call mvn package
			cd %CD%
		) else (
			if "%1" == "deploy" (
				cd %DIR_NAME%		
				call "%XAP_HOME%\bin\gs" pu deploy data-processor processor\target\data-processor.jar
				call "%XAP_HOME%\bin\gs" pu deploy data-feeder feeder\target\data-feeder.jar
				cd %CD%
			) else (
				if "%1" == "undeploy" (
					cd %DIR_NAME%
                    call "%XAP_HOME%\bin\gs" pu undeploy data-feeder
					call "%XAP_HOME%\bin\gs" pu undeploy data-processor
					cd %CD%
				) else (
					if "%1" == "intellij" (
						xcopy %DIR_NAME%\runConfigurations %DIR_NAME%\.idea\runConfigurations\
					) else (
					  	echo.
                      	echo "Error: Invalid input command %1"
						echo. 
						echo The available commands are:
						echo. 
						echo clean                    --^> Cleans all output dirs
						echo compile                  --^> Builds all; don't create JARs
						echo package                  --^> Builds the distribution
						echo deploy                   --^> Deploys the processor and the feeder onto the service grid
						echo undeploy                 --^> Undeploys running processing units
						echo intellij                 --^> Creates run configuration for IntelliJ IDE
						echo. 
					)	
				)
			)
		)
	)
)
 



