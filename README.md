# Description

This repository holds the prototype for an experiment in structuring applications in a way that avoids common problems when developing a web-deployed applications.

The goals this experiment tries to achieve are:

* Make implementing cross-cutting concerns such as instrumentation, logging and authorization easy
* Writing fast unit tests should be easy
* Always provide an answer to "where should I put this code"
* Make introspection of the system easy: what actions are possible in this context? what would happen if ...? what data can I get from the system?
* Provide an overview of what types of messages are accepted by the system

Achieving these goals is attempted by reducing the application to these concepts:

* *Commands* represents an intended state change to the system.  They only describe what parameters are required for making that change but do not hold the logic for actually applying that change to the system.
* *Queries* are an analogue to commands: they represent the intenation to get some data out of the system.  All read access to data in the system is modelled through queries
* *Effects* represent side-effects that should be applied as the result of processing a command, e.g. writing to a database, updating a search index, queuing a message on a message queue, etc.
* *Types* are functions that accept values coming from external systems and either accept (and possibly transform them) or reject them.

Commands, Queries and Effects are serializable descriptions of what data comes into the system, goes out of the system and how the system interacts with the outside world.

Each of these categories has associated handlers, that defined how to actually change data, fetch data or apply changes to the outside world:

* *Command Handlers* accept a set of parameters according to the command they are mapped to together with a context object that holds the results of queries that needed to be executed in order for the command handler to do its job.  They return a list of effects that are to be applied by the system.
* *Query Handlers* receive a set of parameters according to the query they are mapped to and are responsible for actually fetching the data.  They return data as defined by the query they are mapped to.
* *Effect handlers* are invoked with the effects they are mapped to; their purpose is to actually make changes to external systems.

An application then in effect becomes a container for holding the definitions of all of these components and mappings.

What does this buy us?

* Commands, queries and effects can be introspected to give a list of possible actions / queries, generate documentation, etc
* Commands can be processed with a different command handler that simply returns effects instead of applying, essentially providing a "what-if" function
* This "what-if" function can be used to give a detailed overview of what effects a command results in
* An index of this information can be built to answer queries like "what commands end up sending emails?"
* In tests individual query handlers can be overridden to provide the values required by the test

This repository contains a reference implementation of this idea in Ruby.
