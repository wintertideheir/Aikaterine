# Waterfall Document for Aikaterine

## What is the Waterfall Model?

The waterfall model of project management and software development describes the creation of a final product through sequential stages.
The five stages of the waterfall model, as originally presented by Herbert D. Benington, are

1. __Requirements__:
    1. __System Requirements__: Create a product requirements document.
    2. __Analysis__: Perform analysis to validate and elaborate on the requirements document.
2. __Design__: Describe the software architecture best suited to meet the requirements.
3. __Implementation__: Code and test the software.
4. __Verification__: Test the software to ensure it reliably and efficiently meets the requirements.
5. __Maintenance__: Install, update, and maintain the software.

The primary benefit of the waterfall model is that it's simplicity and rigor enables rapid development of good design while remaining accessible to new contributors.

The primary criticism of the waterfall model is that it may be necessary to return to previous phases if either the requirements change or if previously unknown issues arise.

## How does Aikaterine implement the waterfall model?

As a compromise, Aikaterine uses a modification of the waterfall model called the _destructive waterfall model_. This model is identical to the waterfall model, except that in case that a phase uncovers a error, shortcoming, or contradiction in the previous phase, the phase initiates _destruction_,

1. __Termination__ Complete termination of all analysis, design, coding, testing, and maintenance.
2. __Deletion__ Delete of all parts of the entire project, including the waterfall design document, that is affected by the error, shortcoming, or contradiction.
3. __Revision__ Revise the waterfall document to remove the error, address the shortcoming, or fix the contradiction.
4. __Expropriation__ Scavenge the deleted parts of the project for any useful writing, code, or tools. 
5. __Annihilation__ End destruction and continue development.

However, because carrying out destruction would be onerous in practice, Aikaterine uses Git to approximate the process as closely as possible. At least one branch must be a _conforming_ branch that closely follows the destructive waterfall method. All other branches may and should be _non-conforming_.

Conforming branches must have a versioned waterfall document. The version of a waterfall document is in a five number format, `a.b.c.d.e`, which corresponds to the phases requirements, design, implementation, verification, and maintenance. Every destruction cycle increments the number associated with the first affected phase and resets the following numbers. Conforming branches must not have a versioned waterfall document. A temporary planning document is recommended instead.

Conforming branches must follow the destructive waterfall method. 