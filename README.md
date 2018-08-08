# Preamble

The first function of a shell is to interact, and only a second to write programs (scripts); and a very distant third to be a general purpose language (if need be -- because one can always use other languages for that).

# Wishlist

## Stacked contexts for short options

```
$ with <net-context>
```
This should set the context for single letter options. For example -h should always expand to --host=xxx in net-context, and -h=yyy should expand to --host=yyy. -wl for example, might expand to --port=80 --host=localhost

## Variables

* Plan9 like: mount env as a file system
* Array access with /<n> and hash access with /<key>
* Allow stack data type where, if `s` is a stack, `$s` should access only the last item, so that the previous values are still saved in the stack, and can be poped back or rotated. Allow the stack at any place a string would be acceptible.
* exported env should be separate from variables, and should be handled as /env/PATH
* Should we take hints from powershell, and use $.fieldname ? or $[fieldnum]?

## Sample generation for any command

Any command should be able to provide an automatic sample of outputs for a given set of options when invoked in an environment that requests samples (env?)

## Type information for any command

Any command should be able to provide the type information of outputs when invoked with a given set of options

## Environment and options

A command's output type (columns and data types) should be dependent only on its command line options and not on the environment.

## Should allow concatenative pipe wrangling

## Should use ascii field and record separators

Old utilities might still use single field records, but a wrapper can be used to split them and give headers too. Else, use pascal string like fields with length indicated before the field.

## Deal with spaces in filenames

### Alternatives

* Interpret space in filenames as space, but use tabs for separation of commands and args and other control.
* Should interpret space in filenames as unicode space (input shift+space), and let normal space be used for control.

## Investigate a good command line editing mechanism

* Emacs (modeless + ctrl keys)
* Vi  (mode + verb object)
* Kakoune/sed (mode + object verb)

## Type info if needed

The shell should parse the command line, and determine the type info of each commands by interrogating the command with required options in a typeinterrogation environment.

(Check also how powershell does type checking)

## Addressing results of commands

To avoid explicity copy/paste operations, consider using a variable such as `itor _` in many repls.

## Allow detaching of current process from terminal by default, and reattaching

# Others, not fully thought out

* Investigate using Env to transmit the previous commands headers for field names
* builtin: cd & exit should be different from normal execs
* Have awk like syntax integrated into the shell for case
* Shell should provide default argument parsing
* Take over -word for keyword args, and = for single letter shortcuts
* Don't throw away error records, keep all of them in different pipes until shell finishes (todo, see how that can be done)
* Save all the exit codes of individual programs. Or use exit failure as a transaction failure (we already save all error records), with standardized exceptions. (unless wrapped by exception handling subshells)
* Allow {} or () for subshells -- not both
* To be evaluated: Is arithmetic useful for bare syntax? should we take over { and } for shell redirection?
* Use +> for append (maybe)
* Allow named pipes to be created just for the session perhaps by :> syntax
* Handholding may be counterproductive: http://dl.acm.org/citation.cfm?id=1150148
* [The art of unix usability](http://www.catb.org/~esr/writings/taouu/taouu.html)
* Remember unix domain sockets; you can pass open files over them; it may be a reasonable implementation for higher dimentional/infinite records. i.e a list of open fds pased as a single record in a stream
* Differentiate between map and fold/filter pipes clearly with types; For the awk like pipe, you can use Null record for those records selected away to other pipes so that they can be recombined later. Same could be used for error records
* Think carefully about whether it should be a command line or an Rstudio/Python notebook like interface
* A transpose operator would be nice.
* We really need the record separate and guarantee from programs to flush each record atomically to make sure that the outputs and combinations make sense.
http://www.ceri.memphis.edu/people/smalley/ESCI7205F2009/misc_files/The_truth_about_Unix_cleaned.pdf
* [Bernstein Chaining](http://www.catb.org/~esr/writings/taoup/html/ch06s06.html)
* Be consistent with short options (=). They are made to combine, so they should be boolean.
* Think deeply about whether to take advantage of peoples knowledge of unix shells and reuse the names (and confuse people); or break completely and thus not confuse people (but make transition really hard)
* Optimize cats, and other pipe fragments so that the useless-use-of-cat objection is not raised against the user, and implementor does not have an incentive to bake things in.
* Pipes should always reinterpret their output to ascii by default. They can be converted back at the end points either at the starting or at the end of '>' so the pipes can always expect correct filed and record separators and types
* Making '<' xxx (like cat) into source and '>' into sink can allow us to annotate and typecheck the entire pipeline; i.e whether the pipeline expects ascii, json, xml or binary
* Parallel by default: The source should parallelize the records, and sink should serialize it based on their sequence number. The serial dependency should not be allowed except in carefully demarcated areas using a type system.
* Filters should start/end with '?' i.e ?awk, and those that require serial dependence should start/end with '!' i.e !sort or !sum
* Allow easy and nested strings with {} or {xx:} where {} is interpreted according to xxx
* Dont worry too much about non-linear pipes. This may be handled separately by make and its ilk.



# Other advanced environments

* [Directed Graph Shell](https://github.com/dspinellis/dgsh), [Extending Unix Pipelines to DAGs](https://ieeexplore.ieee.org/document/7903579/)
* [CMS Pipelines](http://vm.marist.edu/~pipeline/) also called Hartmann pipelines
* [IShell: a visual UNIX shell](http://dl.acm.org/citation.cfm?id=97274)
* Hadleyverse in R
