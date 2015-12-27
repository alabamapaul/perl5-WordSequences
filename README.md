# WordsSequences
## Overview

WordsSequences is an object oriented module for parsing a file into arbitrary
length sequences of letters.

## Installation
It is recommendded to use the cpanm utility (see [App::cpanm](https://metacpan.org/pod/App::cpanminus)) to ensure any required modules are installed if needed.  

To use the cpanm utility to install the script and associated modules, at a command prompt, type the following:
```
cpanm WordSequences-x.yy.tar.gz
```
Where x.yy is the version to install.

## Module Documentation
After installation, documentation for the *WordSequences* and *WrodSequence* modules can be accessed using the perldoc command as follows:
```
perldoc WordSequences
```

## Command Line Usage
The word_sequences.pl script is used to parse an input file and generate "words" and 
"sequences" output files for the parsed data.

Using the script defaults, "words" and "sequences" output files can be generated for all unique 4 character sequences from the input file "dictionary.txt" by typing the following:
```
word_sequences.pl --input dictionary.txt
```

### Command line options
The word_sequences.pl script understand the following command line options:

#### --unique --no-unique
The --unique option indicates that only unique sequences are output in the "sequences" and corresponding "words" file.  
The --no-unique option can be used to ouput all sequences in the "sequences" and corresponding "words" file.  
**DEFAULT:** --unique

#### --length *SequenceLength*
The --length option is used to specify the length of sequence desired, and must a positive number.  
**DEFAULT:** --length 4

#### --input *InputFilename*
The --input option specifies the name of the file to read as the input file.  
If no --input option is specified, all input is read from STDIN

#### --words *WordsFilename*
The --words option specifies the name of the "words" output file.  Each line in the "words" file indicates the word (or words if --no-unique is specified) that contains the sequence on the same line number in the "sequences" file.  
If --no-unique is specified, and multiple words contain the sequence, the words are output in ascending order.  
**DEFAULT:** --words "words"

#### --sequences *SequencesFilename*
The --sequences option specifies the name of the "sequences" output file.  Each line in the "sequences" file contains a sequnce of the specified length and the word (or words if --no-unique is specified) that contains the sequence is on the same line number in the "words" file.  
The "sequence" file is ouput in ascending order.  
**DEFAULT:** --sequences "sequences"

#### --help
The --help option prints the command usage then exits.

#### --version
The --version option prints the name of the script and the script version, then exits.

#### --man
The --man option prints the command usage and additional information then exits.
