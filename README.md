Introduction
------------

The tokenizer tokenizes a text into sentences and words. 

### Confused by some terminology?

This software is part of a larger collection of natural language processing
tools known as "the OpeNER project". You can find more information about the
project at [the OpeNER portal](http://opener-project.github.io). There you can
also find references to terms like KAF (an XML standard to represent linguistic
annotations in texts), component, cores, scenario's and pipelines.

Quick Use Example
-----------------

Installing the tokenizer can be done by executing:

    gem install tokenizer

Please bare in mind that all components in OpeNER take KAF as an input and
output KAF by default.


### Command line interface

You should now be able to call the tokenizer as a regular shell
command: by its name. Once installed the gem normally sits in your path so you can call it directly from anywhere.

Tokenizing some text:

    echo "This is English text" | tokenizer -l en --no-kaf
    
Will result in

    <?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <KAF version="v1.opener" xml:lang="en">
      <kafHeader>
        <linguisticProcessors layer="text">
          <lp name="opener-sentence-splitter-en" timestamp="2013-05-31T11:39:31Z" version="0.0.1"/>
          <lp name="opener-tokenizer-en" timestamp="2013-05-31T11:39:32Z" version="1.0.1"/>
        </linguisticProcessors>
      </kafHeader>
      <text>
        <wf length="4" offset="0" para="1" sent="1" wid="w1">This</wf>
        <wf length="2" offset="5" para="1" sent="1" wid="w2">is</wf>
        <wf length="7" offset="8" para="1" sent="1" wid="w3">English</wf>
        <wf length="4" offset="16" para="1" sent="1" wid="w4">text</wf>
      </text>
    </KAF>

  The available languages for tokenization are: English (en), German (de), Dutch (nl), French (fr), Spanish (es), Italian (it)

#### KAF input format

The tokenizer is capable of taking KAF as input, and actually does so by
default. You can do so like this:

    echo "<?xml version='1.0' encoding='UTF-8' standalone='no'?><KAF version='v1.opener' xml:lang='en'><raw>This is what I call, a test!</raw></KAF>" | tokenizer

Will result in

    <?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <KAF version="v1.opener" xml:lang="en">
      <kafHeader>
        <linguisticProcessors layer="text">
          <lp name="opener-sentence-splitter-en" timestamp="2013-05-31T11:39:31Z" version="0.0.1"/>
          <lp name="opener-tokenizer-en" timestamp="2013-05-31T11:39:32Z" version="1.0.1"/>
        </linguisticProcessors>
      </kafHeader>
      <text>
        <wf length="4" offset="0" para="1" sent="1" wid="w1">this</wf>
        <wf length="2" offset="5" para="1" sent="1" wid="w2">is</wf>
        <wf length="2" offset="8" para="1" sent="1" wid="w3">an</wf>
        <wf length="7" offset="11" para="1" sent="1" wid="w4">english</wf>
        <wf length="4" offset="19" para="1" sent="1" wid="w5">text</wf>
      </text>
    </KAF>

If the argument -k (--kaf) is passed, then the argument -l (--language) is ignored.

### Webservices

You can launch a language identification webservice by executing:

    tokenizer-server

This will launch a mini webserver with the webservice. It defaults to port 9292,
so you can access it at <http://localhost:9292>.

To launch it on a different port provide the `-p [port-number]` option like
this:

    tokenizer-server -p 1234

It then launches at <http://localhost:1234>

Documentation on the Webservice is provided by surfing to the urls provided
above. For more information on how to launch a webservice run the command with
the ```-h``` option.


### Daemon

Last but not least the tokenizer comes shipped with a daemon that
can read jobs (and write) jobs to and from Amazon SQS queues. For more
information type:

    tokenizer-daemon -h

Description of dependencies
---------------------------

This component runs best if you run it in an environment suited for OpeNER
components. You can find an installation guide and helper tools in the [OpeNER installer](https://github.com/opener-project/opener-installer) and [an installation guide on the Opener Website](http://opener-project.github.io/getting-started/how-to/local-installation.html)

At least you need the following system setup:

### Dependencies for normal use:

* Perl 5
* MRI 1.9.3

### Dependencies if you want to modify the component:

* Maven (for building the Gem)


Language Extension
------------------

The tokenizer module is a wrapping around a Perl script, which performs the actual tokenization based on rules (when to break a character sequence). The tokenizer already supports a lot of languages. Have a look to the core script to figure out how to extend to new languages.

The Core
--------

The component is a fat wrapper around the actual language technology core. The core is a rule based tokenizer implemented in Perl. You can find the core technologies in the following repositories:

* [tokenizer-base](http://github.com/opener-project/tokenizer-base)

Where to go from here
---------------------

* [Check the project website](http://opener-project.github.io)
* [Checkout the webservice](http://opener.olery.com/tokenizer)

Report problem/Get help
-----------------------

If you encounter problems, please email support@opener-project.eu or leave an
issue in the (issue tracker)[https://github.com/opener-project/tokenizer/issues].


Contributing
------------

1. Fork it ( http://github.com/opener-project/tokenizer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
