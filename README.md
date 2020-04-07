# Data Example

The data example is an abstract example showing off most of OpenSpaces 
features, namely:

- The definition of two processing units, a processor and a feeder, 
  sharing the same domain model.
- Definition of a Space within the processing unit, with different schemas 
  and SLA.
- Show cases for OpenSpaces Events module, including the polling container 
  and notify container.
- Usage of OpenSpaces Remoting.
- Usage of GigaSpaces local view within a the processing unit.
- Usage of GigaSpaces JMS in OpenSpaces
- Usage of the MessageConverter JMS feature that allows writing POJOs to 
  the space by using the JMS API.

## STRUCTURE

The example has three modules:

- The Common module includes the domain model and a data processor interface 
  that are shared between the feeder and the processor modules.

- The Processor module is a processing unit with the main task of processing 
  unprocessed data objects. The processing of data objects is done both 
  using event container and remoting.

- The Feeder module is a processing unit that contains two feeders, a standard 
  space feeder and a JMS feeder, that feeds unprocessed data objects which 
  are in turn processed by the processor module. The standard space feeder 
  feeds unprocessed data objects both by directly writing them to the space 
  and by using OpenSpaces Remoting. The JMS feeder uses JMS API to feed 
  unprocessed data objects. It does so by using a MessageConverter that 
  converts JMS ObjectMessages to the data objects.
	    
## BUILD AND DEPLOYMENT

The example uses maven as its build tool. It comes with a build script that 
runs maven automatically. Running the build script with no parameters within 
the current directory will list all the relevant tasks that can be run with 
this example.

The available commands are:

- clean     - Cleans all output dirs
- compile   - Builds all; don't create JARs
- package   - Builds the distribution
- deploy    - Deploys the processor and the feeder onto the service grid
- undeploy  - Undeploys running processing units
- intellij  - Creates run configuration for IntelliJ IDE

Running `build.(sh/bat) compile` will compile all the different modules. 
In case of the Processor and Feeder modules, it will compile the classes 
directly into their respective PU structure.

Running `build.(sh/bat) package` will finalize the processing unit structure 
of both the Processor and the Feeder by copying the Common module jar file 
into the 'lib' directory within the  processing unit structure. In case 
of the processor module, it will copy the jar file to 
`/examples/data-app/event-processing/processor/target/data-processor/lib`, 
and will make `/examples/data-app/event-processing/processor/target/data-processor/` 
a ready to use processing unit.

Running `build.(sh/bat) intellij` will create run configuration for IntelliJ 
IDE, allowing you to run the Processor and the Feeder using IntelliJ run 
(or debug) targets (to run from intellij the mvn profile IDE should be on).

In order to deploy the data example onto the Service Grid, simply run XAP 
agent with manager `$XAP_HOME/bin/gs.(sh|bat) host run-agent --auto --gsc=2` which will start a Manager ,2 GSCs and GS-WEBUI
note: we need two GSCs because of the SLA defined  within the processor module.

run `build.(sh|bat) deploy` - This will deploy the processor.jar and the 
feeder.jar into the running GSM. This will cause the feeder to be deployed 
into one of the GSC and start feeding unprocessed data into the two processing 
units. Run the GS-UI in order to see the 4 PU instances deployed (two partitions, 
each with one backup).

Running `build.(sh|bat) undeploy` will remove all of the processing units 
of this example from the service grid.

Another option to deploy the example can be using the CLI 'deploy' option. 
`$XAP_HOME/bin/gs.(sh|bat) pu deploy data-processor ../examples/data-app/event-processing/processor/target/data-processor.jar`

The number of partitions can be configured when deploying using the `--partitions=<NUM_OF_PARTITIONS>`

In order to run the feeder using the CLI:
`$XAP_HOME/bin/gs.(sh|bat) pu deploy ../examples/data-app/event-processing/feeder/target/data-feeder.jar`

Some ways to play with the examples can be:

1. Start another GSC (via the GS-UI) and relocate (click and drag on GS-UI) the feeder to 
the other GSC.

2. Kill one of the GSC that runs the Processor processing unit. The missing
instance that was killed will be re-deployed on a new GSC. Based on the 
SLA, each partition (primary and backup) of an instance will run on different 
GSCs (i.e. JVMs).
